## -*- coding: utf-8 -*-
print("______________________________________________________________________________________",flush=True)
import os
import sys
import numpy as np
import pandas as pd
import warnings
warnings.filterwarnings('ignore')

here_list = sys.argv
##input features
gene_list_file = pd.read_table("/data/Figure 4/boruta.tss_score.features.txt", index_col=0, header = None)
gene_list = gene_list_file.index.tolist()

#input matrix
train_disease = pd.read_table("/data/Figure 4/boruta.tss_score.early_PE.train_valid.txt", index_col=0).dropna()
train_control = pd.read_table("/data/Figure 4/boruta.tss_score.control.train_valid.txt", index_col=0).dropna()

dataframe = pd.concat([train_disease, train_control], axis=1)
samplenames = np.array(dataframe.columns)
names = np.array(dataframe.index)

X = np.array(dataframe)
X = X.transpose()
print (len(X))
Y = [1]*train_disease.shape[1] + [0]*train_control.shape[1]
Y = np.array(Y)

"""4. boruta"""
from sklearn.ensemble import RandomForestRegressor
from boruta import BorutaPy

###initialize Boruta
forest = RandomForestRegressor(n_jobs = -1, max_depth = 269, min_samples_split=5, min_samples_leaf=3, n_estimators=200, random_state=42)
boruta = BorutaPy(estimator = forest, n_estimators = 'auto', alpha=0.05, two_step=True, max_iter = 1000) # number of trials to perform
### fit Boruta (it accepts np.array, not pd.DataFrame)
boruta.fit(X, Y)

### print results
green_area = dataframe.index[boruta.support_].to_list()
blue_area = dataframe.index[boruta.support_weak_].to_list()
print('features in the green area:', green_area)
print('features in the blue area:', blue_area)


boruta_ranking = pd.DataFrame(boruta.ranking_)
boruta_ranking.index = dataframe.index
boruta_ranking.columns = ['ranking']
boruta_ranking = boruta_ranking.sort_values(by = 'ranking')

boruta_ranking_fre = boruta_ranking.rank(method='dense', ascending=False)/boruta_ranking.rank(method='dense', ascending=False).max()
boruta_ranking_fre.to_csv('/results/Figure 4/boruta_result.tss_score.EPE.txt', sep='\t')
print(boruta_ranking.rank(method='dense', ascending=False).max(),flush=True)

