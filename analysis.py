# -*- coding: utf-8 -*-
"""
Created on Sat Nov  6 20:01:47 2021

@author: AY
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats

pd.set_option('display.max_rows', 100)

df = pd.read_csv('categories_0.csv')
df.drop('Unnamed: 0', axis=1, inplace=True)
df['click_rate'] = df['clicks'] / df['impressions']

#Look at distribution of categories
counts = df['cat'].value_counts()
#Group categories into 'OTHER'
mean_stats = df.groupby('cat').mean()
counts = counts[counts.values < 150]
df.replace(counts.index, 'OTHER', inplace=True)
counts['OTHER'] = 10000 - np.sum(counts.values)


#Plot pie chart for categories
labels = counts.index
sizes = counts.values
fig1, ax1 = plt.subplots()
ax1.pie(sizes, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90)
ax1.axis('equal')
#plt.savefig('cat_dist.png')
plt.show()


#Look at mean for each category
mean_stats = df.groupby('cat').mean()
#print(mean_stats)

#Summary statistics
print(np.mean(mean_stats, axis = 0))
print(np.std(mean_stats, axis = 0))



#Summary bar chart
labels = mean_stats.index
winners = mean_stats['winner'].values
first_places = mean_stats['first_place'].values
click_rates = mean_stats['click_rate'].values
x = np.arange(len(labels))  # the label locations
width = 0.35  # the width of the bars
fig, ax = plt.subplots(figsize=(18,6))
rects1 = ax.bar(x - 2*width/3, winners, 2*width/3, label='winner')
rects2 = ax.bar(x, first_places, 2*width/3, label='first_place')
rects3 = ax.bar(x + 2*width/3, click_rates, 2*width/3, label='click_rate')

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_title('Mean statistics for each category')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

fig.tight_layout()
#plt.savefig('mean_stats.png')
plt.show()


#Testing winner and first_place
def two_proportion_test(catA, catB, field):
    A = df[df['cat'] == catA]
    B = df[df['cat'] == catB]
    n_A = A.shape[0]
    n_B = B.shape[0]
    p_A = A[A[field]].shape[0] / n_A
    p_B = B[B[field]].shape[0] / n_B
    p = (n_A * p_A + n_B * p_B) / (n_A + n_B)
    q = 1 - p
    print('Testing', catA, 'and', catB, 'on', field)
    print(p_A, p_B, n_A, n_B, p, q)
    z = (p_A - p_B) / ((p * q * (1 / n_A + 1 / n_B)) ** 0.5)
    print(z)


two_proportion_test('HEALTHY LIVING', 'WELLNESS', 'winner')
two_proportion_test('HEALTHY LIVING', 'WELLNESS', 'first_place')
two_proportion_test('ENTERTAINMENT', 'COMEDY', 'winner')
two_proportion_test('ENTERTAINMENT', 'COMEDY', 'first_place')
two_proportion_test('PARENTING', 'PARENTS', 'winner')
two_proportion_test('PARENTING', 'PARENTS', 'first_place')


def welch_t_test(catA, catB, field):
    A = df[df['cat'] == catA]
    B = df[df['cat'] == catB]
    A_arr = np.log(A[field].values)
    B_arr = np.log(B[field].values)
    '''
    #Plot to see if approximately normal
    plt.Figure()
    plt.hist(A_arr, bins = 30)
    plt.show()
    plt.Figure()
    plt.hist(B_arr, bins = 30)
    plt.show()
    '''
    stat, p_value = scipy.stats.ttest_ind(a = A_arr, b = B_arr, axis = None, equal_var = False, nan_policy = 'omit')
    print(stat, p_value)


welch_t_test('HEALTHY LIVING', 'WELLNESS', 'click_rate')
welch_t_test('ENTERTAINMENT', 'COMEDY', 'click_rate')
welch_t_test('PARENTING', 'PARENTS', 'click_rate')



#Cursory glance at pairs of topics
print(df[df['cat'] == 'PARENTS']['headline'].head())
print(df[df['cat'] == 'PARENTING']['headline'].head())

print(df[df['cat'] == 'HEALTHY LIVING']['headline'].head())
print(df[df['cat'] == 'WELLNESS']['headline'].head())