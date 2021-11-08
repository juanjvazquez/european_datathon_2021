import pandas as pd
from scipy import stats


packages = pd.read_csv("PackagesData.csv")
packages['created_at'] = pd.to_datetime(packages['created_at'])
packages['clickrate'] = packages['clicks'] / packages['impressions']
packagescompact= packages.drop(['test_week', 'excerpt','lede','slug','share_text','share_image'], axis=1)

testTypes = packagescompact.groupby(by=['test_id']).agg(
    headlinetest = ('headline', lambda x : not(x.eq(x.iloc[0]).all())),
    imagetest = ('image_id', lambda x : not(x.eq(x.iloc[0]).all())),
    )

testTypes.set_index(testTypes.columns[0])
testTypes['TestType'] = testTypes.apply(lambda row : "C" if ((row.headlinetest == True) & (row.imagetest == True)) else ("H" if row.headlinetest == True else ("I" if row.imagetest==True else "N")), axis=1)

packagescompact['headlinetest'] = packagescompact['test_id'].apply(lambda x : testTypes.loc[x,'headlinetest'])
packagescompact['imagetest']    = packagescompact['test_id'].apply(lambda x : testTypes.loc[x,'imagetest'])
packagescompact['TestType']     = packagescompact.apply(lambda row : "C" if ((row.headlinetest == True) & (row.imagetest == True)) else ("H" if row.headlinetest == True else ("I" if row.imagetest==True else "N")), axis=1)


sortedwinners = (packagescompact[packagescompact['winner'] == True].copy()).sort_values(by=['created_at'])


postedtimeseries = sortedwinners.groupby(by=['created_at']).agg(
     NofWinners = ('test_id', 'count'),
     WinnerHTests = ('TestType', lambda df : df[df == "H"].shape[0]),
     WinnerITests = ('TestType', lambda df : df[df == "I"].shape[0]),
     WinnerCTests = ('TestType', lambda df : df[df == "C"].shape[0]),
     meanclicks = ('clickrate', 'mean'),
     maximalclicks = ('clickrate', 'max'),
     )


postedtimeseries['NofTests'] = packagescompact.groupby(['created_at'])['test_id'].nunique()

DayIDTT = packagescompact.groupby(['created_at','test_id']).agg(
    TT = ('TestType', lambda x : x.iloc[0]))

postedtimeseries['NHTests']  = DayIDTT.groupby(['created_at']).agg((lambda df : df[df == "H"].shape[0]))
postedtimeseries['NITests']  = DayIDTT.groupby(['created_at']).agg((lambda df : df[df == "I"].shape[0]))
postedtimeseries['NCTests']  = DayIDTT.groupby(['created_at']).agg((lambda df : df[df == "C"].shape[0]))

postedtimeseries.to_csv('timeseriesoftests.csv')
     


