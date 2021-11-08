import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt


packages = pd.read_csv("PackagesData.csv")
packages['created_at'] = pd.to_datetime(packages['created_at'])
packages['clickrate'] = packages['clicks'] / packages['impressions']
packagescompact= packages.drop(['test_week', 'excerpt','lede','slug','share_text','share_image'], axis=1)

##############################################################################

firstplaces = packagescompact[packagescompact['first_place'] == True].copy()

#sortedfps is the sorted first places 
sortedfps = firstplaces.sort_values(by=['created_at'])
maximalfpclicks = sortedfps.groupby(by=['created_at'])['clickrate'].max()

mcfdf = maximalfpclicks.reset_index()


##############################################################################

winners = packagescompact[packagescompact['winner'] == True].copy()

#sortedwinners is the sorted winners
sortedwinners = winners.sort_values(by=['created_at'])
maximalwclicks = sortedwinners.groupby(by=['created_at'])['clickrate'].max()

mcwdf = maximalwclicks.reset_index()


##############################################################################


cleanedpackages = packagescompact[packagescompact['clicks'] > 0]

TestTypebyID = cleanedpackages.groupby(by=['test_id']).agg(
    date = ('created_at', lambda x : x.iloc[0]),
    headlinetest = ('headline', lambda x : not(x.eq(x.iloc[0]).all())),
    imagetest = ('image_id', lambda x : not(x.eq(x.iloc[0]).all())),
    testcount = ('test_id', 'count'),
    clickratePincrease = ('clickrate', lambda x: 100*(x.max() - x.min())/(x.min())),
    clickrateIncFromAverage = ('clickrate', lambda x: 100*(x.max() - x.mean())/(x.mean())),
    posted = ('winner', 'any')
    )

cTTbyID = TestTypebyID[(TestTypebyID['testcount'] > 1) & ((TestTypebyID['headlinetest'] == True) | (TestTypebyID['imagetest'] == True))]
cTTbyID['TestType'] = cTTbyID.apply(lambda row : "C" if ((row.headlinetest == True) & (row.imagetest == True)) else ("H" if row.headlinetest == True else "I"), axis=1)
cTTbyID.to_csv('allTests.csv')

cTTbyID.boxplot(column='clickrateIncFromAverage', by='TestType')
plt.xlabel('Clickrate % Increase')
plt.ylabel('# of Tests')
plt.ylim(0,200)
plt.title('')


headlineTests = cTTbyID[(cTTbyID['headlinetest'] == True) & (cTTbyID['imagetest'] == False)]
headlineTests = headlineTests.drop(['headlinetest', 'imagetest','testcount'], axis=1)
headlineTests.to_csv('headlineTests.csv')
headlineTests.hist(column='clickrateIncFromAverage', bins=np.linspace(0,200,40), grid=False, rwidth=.9, color='blue')
plt.xlabel('Clickrate % Increase')
plt.ylabel('# of Tests')
plt.title('Headline Tests Clickrate Increase Distribution')
print(headlineTests['clickrateIncFromAverage'].describe())

imageTests    = cTTbyID[(cTTbyID['imagetest'] == True) & (cTTbyID['headlinetest'] == False)]
imageTests = imageTests.drop(['headlinetest', 'imagetest','testcount'], axis=1)
imageTests.to_csv('imageTests.csv')
imageTests.hist(column='clickrateIncFromAverage', bins=np.linspace(0,200,40), grid=False, rwidth=.9, color='orange')
plt.xlabel('Clickrate % Increase')
plt.ylabel('# of Tests')
plt.title('Image Tests Clickrate Increase Distribution')
print(imageTests['clickrateIncFromAverage'].describe())

combinationTests = cTTbyID[(cTTbyID['headlinetest'] == True) & (cTTbyID['imagetest'] == True)]
combinationTests = combinationTests.drop(['headlinetest', 'imagetest','testcount'], axis=1)
combinationTests.to_csv('combinationTests.csv')
combinationTests.hist(column='clickrateIncFromAverage', bins=np.linspace(0,200,40), grid=False, rwidth=.9, color='purple')
plt.xlabel('Clickrate % Increase')
plt.ylabel('# of Tests')
plt.title('Combination Tests Clickrate Increase Distribution')
print(combinationTests['clickrateIncFromAverage'].describe())

print(stats.kruskal(headlineTests['clickratePincrease'], imageTests['clickratePincrease'], combinationTests['clickratePincrease']))
print(stats.kruskal(headlineTests['clickrateIncFromAverage'], imageTests['clickrateIncFromAverage'], combinationTests['clickrateIncFromAverage']))
print(stats.mannwhitneyu(headlineTests['clickrateIncFromAverage'], combinationTests['clickrateIncFromAverage']))
print(stats.mannwhitneyu(headlineTests['clickrateIncFromAverage'], imageTests['clickrateIncFromAverage']))
print(stats.mannwhitneyu(imageTests['clickrateIncFromAverage'], combinationTests['clickrateIncFromAverage']))

##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################

uanalytics = pd.read_csv("UserAnalytics.csv")
uanalytics['date'] = pd.to_datetime(uanalytics['date'])
uanalyticscompact = uanalytics.drop(uanalytics.iloc[:,3:9], axis=1)
uanalyticscompact['users'] = pd.to_numeric(uanalyticscompact['users'].replace(',' ,'', regex=True))
uanalyticscompact['new_users'] = pd.to_numeric(uanalyticscompact['new_users'].replace(',' ,'', regex=True))


##############################################################################







