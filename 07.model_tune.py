print("______________________________________________________________________________________")
import os
import sys
import numpy as np
import pandas as pd
import warnings
warnings.filterwarnings('ignore')

####################################01 input data ##############################################

here_list = sys.argv


#input feature
gene_list_file = pd.read_table("/data/Figure 4/RF.gini.features.txt", index_col=0, header = None)
gene_list = gene_list_file.index.tolist()

#input matrix
train_disease = pd.read_table("/data/model_matrix_EPE/RF.H1.early_PE.txt", index_col=0).dropna()
val_disease = pd.read_table("/data/model_matrix_EPE/RF.H2.early_PE.txt", index_col=0).dropna()

train_control = pd.read_table("/data/model_matrix_EPE/RF.H1.control.txt", index_col=0).dropna()
val_control = pd.read_table("/data/model_matrix_EPE/RF.H2.control.txt", index_col=0).dropna()



####################################02 organize data ##############################################
dataframe = pd.concat([train_disease , train_control], axis=1)
dataframe = dataframe.loc[gene_list]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_train = np.array(dataframe)
X_train = X_train.transpose()
y_train = [1]*train_disease.shape[1] + [0]*train_control.shape[1]

dataframe = pd.concat([val1_disease , val1_control], axis=1)
dataframe = dataframe.loc[gene_list]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_val1 = np.array(dataframe)
X_val1 = X_val1.transpose()
y_val1 = [1]*val1_disease.shape[1] + [0]*val1_control.shape[1]


####################################03 model function ##############################################

from sklearn import metrics
from sklearn.model_selection import cross_val_score
from sklearn.feature_selection import RFE

def print_model_result(model, X_train, y_train, X_val1, y_val1, cv = 3):
  ''' This function runs 10 times with the model, and calculate mean and std for each dataset
  '''
  train_list = []
  val1_list = []

  ###model res
  for i in range(10):
    model.fit(X_train, y_train)
    if 'PassiveAggressive' in str(model) or 'SGD' in str(model):
        predict_y = model._predict_proba_lr(X_train)[:,1]
        roc_auc_train = metrics.roc_auc_score(y_train, predict_y)*100
        predict_y = model._predict_proba_lr(X_val1)[:,1]
        roc_auc_val1 = metrics.roc_auc_score(y_val1, predict_y)*100
    else:
        predict_y = model.predict_proba(X_train)[:,1]
        roc_auc_train = metrics.roc_auc_score(y_train, predict_y)*100
        predict_y = model.predict_proba(X_val1)[:,1]
        roc_auc_val1 = metrics.roc_auc_score(y_val1, predict_y)*100
    train_list.append(roc_auc_train)
    val1_list.append(roc_auc_val1)
  cv_cross_score = cross_val_score(model,  X_train,  y_train,  cv= cv, scoring = "roc_auc")*100
  cv_cross_mean = cv_cross_score.mean()
  cv_cross_std = cv_cross_score.std()
  print("model result:", model)
  print("cross cv: %.2f±%.2f\ttrain set: %.2f±%.2f\tval1 set: %.2f±%.2f\n" % (
        cv_cross_mean,cv_cross_std, np.mean(train_list),np.std(train_list),np.mean(val1_list),np.std(val1_list)))
  f.write("cross cv: %.2f±%.2f\ttrain set: %.2f±%.2f\tval1 set: %.2f±%.2f\n" % (
        cv_cross_mean,cv_cross_std, np.mean(train_list),np.std(train_list),np.mean(val1_list),np.std(val1_list)))


####################################04 modeling ##############################################
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import StratifiedKFold

"""SVM"""
print("————SVM—————")
from sklearn.svm import SVC
#optimize parameters
tuned_parameters = [{'kernel': ['rbf','linear'], 'gamma': ['scale','auto', 0.01, 0.001], 'C': [0.01, 0.1, 1],'class_weight':['balanced']}]
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid  = GridSearchCV(SVC(), tuned_parameters,  scoring = "roc_auc", cv=stratified_kfold)
grid.fit(X_cross, y_cross) #get the best parameters based on training set
print("The best parameters are %s with a score of %0.5f" % (grid.best_params_,grid.best_score_))
best_model = SVC(**grid.best_params_,probability=True)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)


"""passive aggressive"""
print("————PA—————")
from sklearn.linear_model import PassiveAggressiveClassifier
#optimize parameters
tuned_parameters =  [{'C': [.1, .2, .3, .4, .5, .6, .7, .8, .9, 1.0, 1.5, 2.0, 3.0],
                      'fit_intercept': [True, False],'max_iter':[500,1000,2000,3000],'early_stopping':[True,False]}]
# GridSearchCV
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)                
grid = GridSearchCV(PassiveAggressiveClassifier(), tuned_parameters,  scoring = "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross) #get the best parameters based on training set
print("The best parameters are %s with a score of %0.5f" % (grid.best_params_,grid.best_score_))
best_model = PassiveAggressiveClassifier(**grid.best_params_)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)


"""SGD"""
print("————SGD—————")
from sklearn.linear_model import SGDClassifier
#optimize parameters
tuned_parameters = [{'loss':['hinge','log','modified_huber','squared_hinge','perceptron','squared_error','huber','epsilon_insensitive',
                     'squared_epsilon_insensitive'],'penalty':['l2','l1','elasticnet'],
                     'alpha':[0.0001,0.001,0.01],'fit_intercept':[True, False]}]
# GridSearchCV
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid = GridSearchCV(SGDClassifier(), tuned_parameters, scoring= "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross)
print("The best parameters are %s with a score of %f" % (grid.best_params_,grid.best_score_))
best_model = SGDClassifier(**grid.best_params_)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)


"""knn"""
print("————knn—————")
from sklearn.neighbors import KNeighborsClassifier
#optimize parameters
tuned_parameters = [{'n_neighbors': list(range(1,10,1)),
                     'weights':['uniform','distance'],
                     'algorithm' : ['auto', 'ball_tree', 'kd_tree', 'brute'],
                     'metric' : ["euclidean", "manhattan", "chebyshev", "minkowski", "mahalanobis"]}]
# GridSearchCV
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid = GridSearchCV(KNeighborsClassifier(),tuned_parameters, scoring= "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross)
print("The best parameters are %s with a score of %f" % (grid.best_params_,grid.best_score_))
best_model = KNeighborsClassifier(**grid.best_params_)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)


"""Gaussian"""
print("————NB—————")
from sklearn.naive_bayes import GaussianNB
tuned_parameters = [{'var_smoothing': np.logspace(2,-9, num=100)}]
# GridSearchCV
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid=GridSearchCV(GaussianNB(), tuned_parameters, scoring= "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross)
print("The best parameters are %s with a score of %f" % (grid.best_params_,grid.best_score_))
best_model = GaussianNB(**grid.best_params_)#actually var_smoothing value can be more, but auc can't be improved anymore
print_model_result(best_model, X_train, y_train, X_val1, y_val1)


"""LR"""
print("————LR—————")
from sklearn.linear_model import LogisticRegression
tuned_parameters = [{'penalty':['l1', 'l2', 'elasticnet', 'none'],'C': [0.01, 0.1, 1],
                     "solver":['liblinear', 'newton-cg', 'lbfgs', 'sag' , 'saga']}]
# GridSearchCV
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid = GridSearchCV(LogisticRegression(random_state=420), tuned_parameters, scoring= "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross)
print("The best parameters are %s with a score of %f" % (grid.best_params_,grid.best_score_))
best_model = LogisticRegression(**grid.best_params_)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)


"""neural network"""
print("————NW—————")
from sklearn.neural_network import MLPClassifier
tuned_parameters = {'alpha': 10.0 ** -np.arange(1, 10), 'hidden_layer_sizes':np.arange(10, 15),
                   #'hidden_layer_sizes':[(10,),(15,),(20,),(5,5)],\
                    'activation':['identity', 'logistic', 'tanh', 'relu'],
                    'solver':['lbfgs','sgd', 'adam'],
                    'learning_rate':['constant', 'invscaling', 'adaptive'],
                    'random_state':np.arange(1, 10), 'max_iter': [200]
                   #'alpha':[0.001, 0.01, 0.1, 0.2, 0.4, 1, 10]
                    } 
#  GridSearchCV 
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid = GridSearchCV(MLPClassifier(max_iter=100), tuned_parameters, scoring= "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross)
print("The best parameters are %s with a score of %f" % (grid.best_params_,grid.best_score_))
best_model = MLPClassifier(**grid.best_params_)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)

"""random forest"""
print("————RF—————")
from sklearn.ensemble import RandomForestClassifier
tuned_parameters = [{'n_estimators': [50, 100, 150],'max_depth': [5,7,9,11,13,15,17,19,21], 'min_samples_leaf': [5, 10, 15],'criterion': ['gini','entropy']}]
# GridSearchCV 
stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
grid = GridSearchCV(RandomForestClassifier(), tuned_parameters, scoring= "roc_auc", cv = stratified_kfold)
grid.fit(X_cross, y_cross)
print("The best parameters are %s with a score of %f" % (grid.best_params_,grid.best_score_))
best_model = RandomForestClassifier(**grid.best_params_)
print_model_result(best_model, X_train, y_train, X_val1, y_val1)

f.close()
