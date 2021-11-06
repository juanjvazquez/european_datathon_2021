# -*- coding: utf-8 -*-
"""
Created on Sat Nov  6 20:01:47 2021

@author: AY
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

pd.set_option('display.max_rows', 100)

df = pd.read_csv('categories_0.csv')
df.drop('Unnamed: 0', axis=1, inplace=True)
df['click_rate'] = df['clicks'] / df['impressions']



#Look at distribution of categories
counts = df['cat'].value_counts()
counts = counts[counts.values < 150]
df.replace(counts.index, 'OTHER', inplace=True)
counts['OTHER'] = 10000 - np.sum(counts.values)

'''
labels = counts.index
sizes = counts.values
fig1, ax1 = plt.subplots()
ax1.pie(sizes, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90)
ax1.axis('equal')
plt.savefig('cat_dist.png')
'''

#Look at mean
mean_stats = df.groupby('cat').mean()
#mean_stats.to_csv('cat_stats.csv')

#Summary statistics
#print(np.mean(mean_stats, axis = 0))
#print(np.std(mean_stats, axis = 0))

#Women
women = df[df['cat'] == 'WOMEN']
p_w = women[women['winner']].shape[0] / women.shape[0]
n_w = women.shape[0]
queer = df[df['cat'] == 'QUEER VOICES']
p_q = queer[queer['winner']].shape[0] / queer.shape[0]
n_q = queer.shape[0]
p = (women[women['winner']].shape[0] + queer[queer['winner']].shape[0]) / (women.shape[0] + queer.shape[0])
q = 1 - p
#print(p_w, n_w, p_q, n_q, p, q)
z = (p_w - p_q) / ((p*q*(1/n_w + 1/n_q))**0.5)
print(z)