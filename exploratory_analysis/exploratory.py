# -*- coding: utf-8 -*-
"""
Created on Tue Nov  2 15:40:16 2021

@author: AY
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

pd.set_option('display.max_rows', 100)
pd.set_option('display.max_columns', 100)
users = pd.read_csv('analytics_daily_users.csv')
#pageviews = pd.read_csv('analytics_daily_pageviews.csv')
packages = pd.read_csv('packages.csv')
#packages_undeployed = pd.read_csv('packages_undeployed.csv')
#print(packages_undeployed.describe())
#print(packages_undeployed[packages_undeployed['winner']])

#Look at first place data
packages['click_rate'] = packages['clicks'] / packages['impressions']
first_places = packages[packages['first_place']]
first_places_click_rate = first_places[['test_id', 'clicks']].set_index('test_id')
packages['clicks_2'] = packages['clicks']
max_click_rate = packages.groupby('test_id')['clicks_2'].max()

df = pd.concat([first_places_click_rate, max_click_rate], axis = 1)
print(df)
print(np.mean(df['clicks'] == df['clicks_2']))
#32122 tests have had a single first place, 365 tests did not
#0.8749 of the max click rates and first places agree


'''
users = users.replace(',','', regex=True)
users = users.replace('%','', regex=True)
users['users'] = pd.to_numeric(users['users'])
users['new_users'] = pd.to_numeric(users['new_users'])
users['sessions'] = pd.to_numeric(users['sessions'])
users['pageviews'] = pd.to_numeric(users['pageviews'])
users['bounce_rate'] = pd.to_numeric(users['bounce_rate'])
users['date'] = pd.to_datetime(users['date'])
print(users[100:150])
'''

'''
#Not all test ids have a first place! (355 don't have) [negligible?]
no_first_place = packages.groupby('test_id').mean()
no_first_place = no_first_place[no_first_place['first_place'] == 0]
print(packages[packages['test_id'] == '51436060220cb800020001df'])


print(len(packages['test_id'].value_counts()))
print(packages[packages['first_place']].shape)
diff = packages[packages['test_id'] == '53fca78325bba9673e00002f']
'''
'''
packages['test_week'] = pd.to_datetime(packages['test_week'])
packages['created_at'] = pd.to_datetime(packages['created_at'])
packages['diff'] = packages['test_week'] - packages['created_at']

plt.hist(packages['diff'])
'''
#packages.sort_values('test_week', inplace=True)
#print(packages)



#print(packages[packages['click_rate'] == 0])
#print(packages['click_rate'].isna().sum())
'''
#Normality testing
from scipy.stats import anderson
from statsmodels.graphics.gofplots import qqplot
nonzero_packages = packages[~(packages['click_rate'] == 0)]
packages['log_click_rate'] = np.log(nonzero_packages['click_rate'])

data = packages['log_click_rate'].values
data = data[~np.isnan(data)]

result = anderson(data, dist='norm')
print('Statistic: %.3f' % result.statistic)
p = 0
for i in range(len(result.critical_values)):
	sl, cv = result.significance_level[i], result.critical_values[i]
	if result.statistic < result.critical_values[i]:
		print('%.3f: %.3f, data looks normal (fail to reject H0)' % (sl, cv))
	else:
		print('%.3f: %.3f, data does not look normal (reject H0)' % (sl, cv))
'''

'''
average_click_rate = packages.groupby('test_week')['click_rate'].mean()
#print(average_click_rate.head())
users = users.replace(',','', regex=True)
users['new_users'] = pd.to_numeric(users['new_users'])
new_users = users.set_index('date')['new_users']
#print(new_users.head())
'''

#Some headlines were tested multiple times
#print(packages[packages['headline'] == 'Dustin Hoffman Breaks Down Crying Explaining Something That Every Woman Sadly Already Experienced'])

#packages['agree'] = (packages['first_place'] == packages['winner'])
#packages['highest'] = 0
#grouped_df = packages.groupby('test_id')['clicks'].max()


#chosen = packages[packages['winner']]
#first_place = packages[packages['first_place']]
#not_first_place = packages[~packages['first_place']]
'''
plt.title('Proportion of first places chosen by editors over time')
plt.plot(first_place.groupby('test_week')['winner'].mean())
plt.savefig('chosen_first_places.png')
'''
#print(first_place['winner'].mean()) #Out of first places, only 18% chosen by editors.
#Why is that?
#first_place_chosen = first_place[first_place['winner']]
#first_place_not_chosen = first_place[~first_place['winner']]
#not_first_place_chosen = not_first_place[not_first_place['winner']]
#print(not_first_place_chosen.shape[0]) #1948
#print(first_place_chosen.shape[0]) #5716
#print(first_place_not_chosen.shape[0]) #26406
#print(not_first_place.shape[0]) #118695
#print(first_place_chosen.loc[1000:1500, ['headline', 'click_rate']])
#print(first_place_not_chosen.loc[1000:1500, ['headline', 'click_rate']])


#not_first_place = packages[~packages['first_place']]
#print(not_first_place['winner'].mean()) #Out of not first places, 1.6% chosen by editors.
'''
plt.Figure()
plt.hist(first_place['click_rate'], 30, (0, .1))
plt.title("Click rate distribution for first place")
plt.savefig('first_place_click_rate.png')
plt.show()
plt.Figure()
plt.title("Click rate distribution for winners")
plt.hist(chosen['click_rate'], 30, (0, .1))
plt.savefig('winners_click_rate.png')
plt.show()
'''

#a = pd.merge(grouped_df, highest_clicks)
#print(a.head())
#In general winners have higher click count than first places
'''
clicks = packages.groupby('test_week').sum()
plt.Figure()
plt.plot(clicks['clicks']/clicks['impressions'])
plt.title("Click rate over time")
plt.savefig('clicks.png')
print(p)
'''
