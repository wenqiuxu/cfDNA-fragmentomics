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


gene_list_file_clinic = pd.read_table("/data/Extended Data Fig 8/RF.clinic.features.txt", index_col=0, header = None)
gene_list_clinic = gene_list_file_clinic.index.tolist()
gene_list_file_cfDNA = pd.read_table("/data/Figure 4/RF.tss_coverage_score_gini.features.txt", index_col=0, header = None)
gene_list_cfDNA = gene_list_file_cfDNA.index.tolist()
gene_list_file_combined = pd.read_table("/data/Figure 5/RF_EPE.combined.features.txt", index_col=0, header = None)
gene_list_combined = gene_list_file_combined.index.tolist()

#input matrix
train_disease = pd.read_table("/data/model_matrix_EPE/RF.H1.early_PE.txt", index_col=0).dropna()
val_disease = pd.read_table("/data/model_matrix_EPE/RF.H2.early_PE.txt", index_col=0).dropna()
test1_disease = pd.read_table("/data/model_matrix_EPE/RF.H3.early_PE.txt", index_col=0).dropna()
test2_disease = pd.read_table("/data/model_matrix_EPE/RF.H4.early_PE.txt", index_col=0).dropna()

train_control = pd.read_table("/data/model_matrix_EPE/RF.H1.control.txt", index_col=0).dropna()
val_control = pd.read_table("/data/model_matrix_EPE/RF.H2.control.txt", index_col=0).dropna()
test1_control = pd.read_table("/data/model_matrix_EPE/RF.H3.control.txt", index_col=0).dropna()
test2_control = pd.read_table("/data/model_matrix_EPE/RF.H4.control.txt", index_col=0).dropna()


#train clinic
dataframe = pd.concat([train_disease, train_control], axis=1)
dataframe = dataframe.loc[gene_list_clinic]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_train_clinic = np.array(dataframe)
X_train_clinic = np.around(X_train_clinic, decimals=6)
X_train_clinic = X_train_clinic.transpose()
y_train_clinic = [1]*train_disease.shape[1] + [0]*train_control.shape[1]
#train cfDNA
dataframe = pd.concat([train_disease, train_control], axis=1)
dataframe = dataframe.loc[gene_list_cfDNA]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_train_cfDNA = np.array(dataframe)
X_train_cfDNA = np.around(X_train_cfDNA, decimals=6)
X_train_cfDNA = X_train_cfDNA.transpose()
y_train_cfDNA = [1]*train_disease.shape[1] + [0]*train_control.shape[1]
#train combined
dataframe = pd.concat([train_disease, train_control], axis=1)
dataframe = dataframe.loc[gene_list_combined]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_train_combined = np.array(dataframe)
X_train_combined = np.around(X_train_combined, decimals=6)
X_train_combined = X_train_combined.transpose()
y_train_combined = [1]*train_disease.shape[1] + [0]*train_control.shape[1]


# test1 clinic
dataframe = pd.concat([test1_disease, test1_control], axis=1)
dataframe = dataframe.loc[gene_list_clinic]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test1_clinic = np.array(dataframe)
X_test1_clinic = np.around(X_test1_clinic, decimals=6)
X_test1_clinic = X_test1_clinic.transpose()
y_test1_clinic = [1]*test1_disease.shape[1] + [0]*test1_control.shape[1]
# test1 cfDNA
dataframe = pd.concat([test1_disease, test1_control], axis=1)
dataframe = dataframe.loc[gene_list_cfDNA]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test1_cfDNA = np.array(dataframe)
X_test1_cfDNA = np.around(X_test1_cfDNA, decimals=6)
X_test1_cfDNA = X_test1_cfDNA.transpose()
y_test1_cfDNA = [1]*test1_disease.shape[1] + [0]*test1_control.shape[1]
# test1 combined
dataframe = pd.concat([test1_disease, test1_control], axis=1)
dataframe = dataframe.loc[gene_list_combined]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test1_combined = np.array(dataframe)
X_test1_combined = np.around(X_test1_combined, decimals=6)
X_test1_combined = X_test1_combined.transpose()
y_test1_combined = [1]*test1_disease.shape[1] + [0]*test1_control.shape[1]


#val clinic
dataframe = pd.concat([val_disease, val_control], axis=1)
dataframe = dataframe.loc[gene_list_clinic]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_val_clinic = np.array(dataframe)
X_val_clinic = np.around(X_val_clinic, decimals=6)
X_val_clinic = X_val_clinic.transpose()
y_val_clinic = [1]*val_disease.shape[1] + [0]*val_control.shape[1]
#val cfDNA
dataframe = pd.concat([val_disease, val_control], axis=1)
dataframe = dataframe.loc[gene_list_cfDNA]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_val_cfDNA = np.array(dataframe)
X_val_cfDNA = np.around(X_val_cfDNA, decimals=6)
X_val_cfDNA = X_val_cfDNA.transpose()
y_val_cfDNA = [1]*val_disease.shape[1] + [0]*val_control.shape[1]
#val combined
dataframe = pd.concat([val_disease, val_control], axis=1)
dataframe = dataframe.loc[gene_list_combined]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_val_combined = np.array(dataframe)
X_val_combined = np.around(X_val_combined, decimals=6)
X_val_combined = X_val_combined.transpose()
y_val_combined = [1]*val_disease.shape[1] + [0]*val_control.shape[1]


#test2 clinic
dataframe = pd.concat([test2_disease, test2_control], axis=1)
dataframe = dataframe.loc[gene_list_clinic]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test2_clinic = np.array(dataframe)
X_test2_clinic = np.around(X_test2_clinic, decimals=6)
X_test2_clinic = X_test2_clinic.transpose()
y_test2_clinic = [1]*test2_disease.shape[1] + [0]*test2_control.shape[1]
#test2 cfDNA
dataframe = pd.concat([test2_disease, test2_control], axis=1)
dataframe = dataframe.loc[gene_list_cfDNA]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test2_cfDNA = np.array(dataframe)
X_test2_cfDNA = np.around(X_test2_cfDNA, decimals=6)
X_test2_cfDNA = X_test2_cfDNA.transpose()
y_test2_cfDNA = [1]*test2_disease.shape[1] + [0]*test2_control.shape[1]
#test2 combined
dataframe = pd.concat([test2_disease, test2_control], axis=1)
dataframe = dataframe.loc[gene_list_combined]
samplenames = np.array(dataframe.columns)
featurenames = np.array(dataframe.index)
X_test2_combined = np.array(dataframe)
X_test2_combined = np.around(X_test2_combined, decimals=6)
X_test2_combined = X_test2_combined.transpose()
y_test2_combined = [1]*test2_disease.shape[1] + [0]*test2_control.shape[1]



from sklearn.metrics import auc,roc_curve
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score
from sklearn.feature_selection import RFE
import pickle
from sklearn.metrics import confusion_matrix


##三个模型
res1 = open('/data/model_EPE/model_clinic.EPE.dat','rb')
s1=res1.read()
clf_clinic=pickle.loads(s1)

res2 = open('/data/model_EPE/tss_coverage_score_gini.dat','rb')
s2=res2.read()
clf_cfDNA=pickle.loads(s2)

res3 = open('/data/model_EPE/combined_EPE.dat','rb')
s3=res3.read()
clf_combined=pickle.loads(s3)

###plot AUC
filename1='/results/Figure 5/AUC_EPE.valid.pdf'
#画图
plt.figure()
lw = 2
plt.figure(figsize=(5,5))


############vali
#clf clinic
fpr,tpr,threshold = roc_curve(y_val_clinic,clf_clinic.predict_proba(X_val_clinic)[:,1],drop_intermediate=False)
roc_auc_vali_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='green',lw=lw, label='MF(AUC = %0.2f)' % roc_auc_vali_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#clf cfDNA
fpr,tpr,threshold = roc_curve(y_val_cfDNA,clf_cfDNA.predict_proba(X_val_cfDNA)[:,1],drop_intermediate=False)
roc_auc_vali_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='blue',lw=lw, label='cfDNA(AUC = %0.2f)' % roc_auc_vali_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#clf combined
fpr,tpr,threshold = roc_curve(y_val_combined,clf_combined.predict_proba(X_val_combined)[:,1],drop_intermediate=False)
roc_auc_vali_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='red',lw=lw, label='combined(AUC = %0.2f)' % roc_auc_vali_plot) ###假正率为横坐标，真正率为纵坐标做曲线


plt.plot([0, 1], [0, 1], color='grey', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('the validation set')
plt.legend(loc="lower right")
#plt.show()
plt.savefig(filename1)
plt.close()




###plot AUC
filename2='/results/Figure 5/AUC_EPE.test1.pdf'
#画图
plt.figure()
lw = 2
plt.figure(figsize=(5,5))

############test
#clf clinic
fpr,tpr,threshold = roc_curve(y_test1_clinic,clf_clinic.predict_proba(X_test1_clinic)[:,1],drop_intermediate=False)
roc_auc_test1_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='green',lw=lw, label='MF(AUC = %0.2f)' % roc_auc_test1_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#clf cfDNA
fpr,tpr,threshold = roc_curve(y_test1_cfDNA,clf_cfDNA.predict_proba(X_test1_cfDNA)[:,1],drop_intermediate=False)
roc_auc_test1_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='blue',lw=lw, label='cfDNA(AUC = %0.2f)' % roc_auc_test1_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#clf combined
fpr,tpr,threshold = roc_curve(y_test1_combined,clf_combined.predict_proba(X_test1_combined)[:,1],drop_intermediate=False)
roc_auc_test1_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='red',lw=lw, label='combined(AUC = %0.2f)' % roc_auc_test1_plot) ###假正率为横坐标，真正率为纵坐标做曲线


plt.plot([0, 1], [0, 1], color='grey', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('the test set')
plt.legend(loc="lower right")
#plt.show()
plt.savefig(filename2)
plt.close()


###plot AUC
filename2='/results/Figure 5/AUC_EPE.test2.pdf'
#画图
plt.figure()
lw = 2
plt.figure(figsize=(5,5))


############test2
#clf clinic
fpr,tpr,threshold = roc_curve(y_test2_clinic,clf_clinic.predict_proba(X_test2_clinic)[:,1],drop_intermediate=False)
roc_auc_test2_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='green',lw=lw, label='MF(AUC = %0.2f)' % roc_auc_test2_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#clf cfDNA
fpr,tpr,threshold = roc_curve(y_test2_cfDNA,clf_cfDNA.predict_proba(X_test2_cfDNA)[:,1],drop_intermediate=False)
roc_auc_test2_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='blue',lw=lw, label='cfDNA(AUC = %0.2f)' % roc_auc_test2_plot) ###假正率为横坐标，真正率为纵坐标做曲线
#clf combined
fpr,tpr,threshold = roc_curve(y_test2_combined,clf_combined.predict_proba(X_test2_combined)[:,1],drop_intermediate=False)
roc_auc_test2_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='red',lw=lw, label='combined(AUC = %0.2f)' % roc_auc_test2_plot) ###假正率为横坐标，真正率为纵坐标做曲线


plt.plot([0, 1], [0, 1], color='grey', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('the test2 set')
plt.legend(loc="lower right")
#plt.show()
plt.savefig(filename2)
plt.close()
