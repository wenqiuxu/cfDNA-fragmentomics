
## -*- coding: utf-8 -*-
import numpy as np
import sys
import os
import pandas as pd
import scipy
import matplotlib.pyplot as plt
from sklearn.feature_selection import RFE
from sklearn import metrics
import warnings
warnings.filterwarnings('ignore')

here_list = sys.argv

#input feature
gene_list_file = pd.read_table("/data/Extended Data Fig 8/RF.bmi.features.txt", index_col=0, header = None)
gene_list = gene_list_file.index.tolist()

#input matrix
train_disease = pd.read_table("/data/Extended Data Fig 8/clinic.H1.early_PE.txt", index_col=0).dropna()
val_disease = pd.read_table("/data/Extended Data Fig 8/clinic.H2.early_PE.txt", index_col=0).dropna()
test1_disease = pd.read_table("/data/Extended Data Fig 8/clinic.H3.early_PE.txt", index_col=0).dropna()
test2_disease = pd.read_table("/data/Extended Data Fig 8/clinic.H4.early_PE.txt", index_col=0).dropna()

train_control = pd.read_table("/data/Extended Data Fig 8/clinic.H1.control.txt", index_col=0).dropna()
val_control = pd.read_table("/data/Extended Data Fig 8/clinic.H2.control.txt", index_col=0).dropna()
test1_control = pd.read_table("/data/Extended Data Fig 8/clinic.H3.control.txt", index_col=0).dropna()
test2_control = pd.read_table("/data/Extended Data Fig 8/clinic.H4.control.txt", index_col=0).dropna()


#train
dataframe = pd.concat([train_disease , train_control], axis=1)
dataframe = dataframe.loc[gene_list]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_train = np.array(dataframe)
X_train = np.around(X_train, decimals=6)
X_train = X_train.transpose()
y_train = [1]*train_disease.shape[1] + [0]*train_control.shape[1]

#val
dataframe = pd.concat([val_disease , val_control], axis=1)
dataframe = dataframe.loc[gene_list]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_val = np.array(dataframe)
X_val = np.around(X_val, decimals=6)
X_val = X_val.transpose()
y_val = [1]*val_disease.shape[1] + [0]*val_control.shape[1]

# test1
dataframe = pd.concat([test1_disease , test1_control], axis=1)
dataframe = dataframe.loc[gene_list]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test1 = np.array(dataframe)
X_test1 = np.around(X_test1, decimals=6)
X_test1 = X_test1.transpose()
y_test1 = [1]*test1_disease.shape[1] + [0]*test1_control.shape[1]

# test2
dataframe = pd.concat([test2_disease , test2_control], axis=1)
dataframe = dataframe.loc[gene_list]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test2 = np.array(dataframe)
X_test2 = np.around(X_test2, decimals=6)
X_test2 = X_test2.transpose()
y_test2 = [1]*test2_disease.shape[1] + [0]*test2_control.shape[1]


"""RF"""
from sklearn.ensemble import RandomForestClassifier
final_predit = {'criterion': 'gini', 'max_depth': 9, 'min_samples_leaf': 20, 'n_estimators': 200}
clf = RandomForestClassifier(**final_predit)


from sklearn.metrics import auc,roc_curve
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score
from sklearn.feature_selection import RFE
import pickle
from sklearn.metrics import confusion_matrix


clf.fit(X_train, y_train)
f = open ('/results/Extended Data Fig 8/model_bmi.EPE.dat','wb')
pickle.dump(clf,f)
f.close()

###plot AUC
filename1='/results/Extended Data Fig 8/AUC_bmi.EPE.pdf'
#画图
plt.figure()
lw = 2
plt.figure(figsize=(5,5))

###############train
fpr,tpr,threshold = roc_curve(y_train,clf.predict_proba(X_train)[:,1],drop_intermediate=False)
roc_auc_train_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='green', lw=lw, label='Training Set(AUC = %0.2f)' % roc_auc_train_plot) ###假正率为横坐标，真正率为纵坐标做曲线
############vali
fpr,tpr,threshold = roc_curve(y_val,clf.predict_proba(X_val)[:,1],drop_intermediate=False)
roc_auc_vali_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='blue',lw=lw, label='Validation Set(AUC = %0.2f)' % roc_auc_vali_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#################test
fpr,tpr,threshold = roc_curve(y_test1,clf.predict_proba(X_test1)[:,1],drop_intermediate=False)
roc_auc_test1_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='red',lw=lw, label='Test Set1(AUC = %0.2f)' % roc_auc_test1_plot)

#################test
fpr,tpr,threshold = roc_curve(y_test2,clf.predict_proba(X_test2)[:,1],drop_intermediate=False)
roc_auc_test2_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='purple',lw=lw, label='Test Set2(AUC = %0.2f)' % roc_auc_test2_plot)


plt.plot([0, 1], [0, 1], color='grey', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('BMI')
plt.legend(loc="lower right")
#plt.show()
plt.savefig(filename1)
plt.close()
