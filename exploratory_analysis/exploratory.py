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
packages = pd.read_csv('packages.csv')


#Preprocessing
packages['test_week'] = pd.to_datetime(packages['test_week'])
packages['click_rate'] = packages['clicks'] / packages['impressions']
first_places = packages[packages['first_place']]
winners = packages[packages['winner']]

#Look at first_place data
tests = packages.groupby('test_id').sum()['first_place']
print(tests.value_counts())
print(tests[tests == 1].shape[0] / tests.shape[0]) #Ratio of tests with 1 first_place
#Look at tests without a first_place
print(tests[tests == 0].head())
print(packages[packages['test_id'] == '55158fe8616664002c240000'])

#See if first_place corresponds to highest click_rate

first_places_click_rate = first_places[['test_id', 'click_rate']].set_index('test_id')
max_click_rate = packages.groupby('test_id')['click_rate'].max()
max_click_rate.rename('click_rate_2', inplace=True)
df = pd.concat([first_places_click_rate, max_click_rate], axis = 1)
df.dropna(axis = 0, inplace=True)
print(np.mean(df['click_rate'] == df['click_rate_2'])) # Look at percentage of first_place having highest click_rate as well
#Look at tests where first_place doesn't correspond to maximum click_rate
print(df[~(df['click_rate'] == df['click_rate_2'])].head())
print(packages[packages['test_id'] == '54737147d289f68ac400001a'])


#Look at winners data
print(packages.groupby('test_id')['winner'].sum().value_counts()) #Winners per test
print(winners['first_place'].mean()) #Proportion of winners that were first_place

#Look at winners that are not first_place
print(winners[~winners['first_place']].head())
print(packages[packages['test_id'] == '549443b93732320018260000'])
print(packages[packages['test_id'] == '549481a43062640024340000'])
print(packages[packages['test_id'] == '547278e0ce85339079000038'])


#Click rate distribution for first_place and winner
print(packages['click_rate'].mean())
print(first_places['click_rate'].mean())
print(winners['click_rate'].mean())

plt.Figure()
plt.hist(first_places['click_rate'], 30, (0, .1))
plt.title("Click rate distribution for first place")
#plt.savefig('first_place_click_rate.png')
plt.show()
plt.Figure()
plt.title("Click rate distribution for winners")
plt.hist(winners['click_rate'], 30, (0, .1))
#plt.savefig('winners_click_rate.png')
plt.show()


plt.figure(figsize = (10,5))
plt.title('Proportion of first places chosen by editors over time')
plt.plot(first_places.groupby('test_week')['winner'].mean())
plt.grid()
#plt.savefig('chosen_first_places.png')
plt.show()

print(packages[packages['test_week'] < '2013-04-01'].shape[0])
print(packages[(packages['test_week'] > '2013-04-01') & (packages['test_week'] < '2013-07-01')].shape[0])
