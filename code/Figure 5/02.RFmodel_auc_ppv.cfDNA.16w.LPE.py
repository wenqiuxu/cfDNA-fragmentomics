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
gene_list_file = pd.read_table("/data/Figure 5/features.cfDNA.16w.LPE.txt", index_col=0, header = None)
gene_list = gene_list_file.index.tolist()

#input matrix
train_disease = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H1.late_PE.txt", index_col=0).dropna()
val_disease = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H2.late_PE.txt", index_col=0).dropna()
test1_disease = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H3.late_PE.txt", index_col=0).dropna()
test2_disease = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H4.late_PE.txt", index_col=0).dropna()

train_control = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H1.control.txt", index_col=0).dropna()
val_control = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H2.control.txt", index_col=0).dropna()
test1_control = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H3.control.txt", index_col=0).dropna()
test2_control = pd.read_table("/data/model_matrix_LPE/RF_LPE.16w.H4.control.txt", index_col=0).dropna()


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
final_predit = {'criterion': 'gini', 'max_depth': 9, 'min_samples_leaf': 20, 'n_estimators': 300}
clf = RandomForestClassifier(**final_predit)


from sklearn.metrics import auc,roc_curve
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score
from sklearn.feature_selection import RFE
import pickle
from sklearn.metrics import confusion_matrix

##define PPV
from sklearn.metrics import confusion_matrix
def classification_report(y_true, y_pred, cutoff):
  y_pred = np.int64(y_pred  > cutoff)
  tn, fp, fn, tp = confusion_matrix(y_true, y_pred).ravel()
  acc = (tp+tn)/(tp+tn+fp+fn)
  sen = (tp)/(tp+fn)
  sp = (tn)/(tn+fp)
  ppv = (tp)/(tp+fp)
  npv = (tn)/(tn+fn)
  f1 = 2*(sen*ppv)/(sen+ppv)
  fpr = (fp)/(fp+tn)
  tpr = (tp)/(tp+fn)
  #res =  {'cutoff':cutoff,'TP': tp, 'FP': fp, 'FN': fn, 'TN': tn,'Accuracy': round(acc, 3),'Sensitivity/Recall': round(sen, 3),'Specificity': round(sp, 3),'PPV/Precision': round(ppv, 3),'NPV': round(npv, 3),'F1-score': round(f1, 3),'FPR': round(fpr, 3),'TPR': round(tpr, 3)}
  res = (cutoff,tp,fp,fn,tn,round(acc, 5),round(sen, 5),round(sp, 5),round(ppv, 5),round(npv, 5),round(f1, 5),round(fpr, 5),round(tpr, 5))
  return(res)

##define bootstrap##
def bootstrap_auc(clf, X_matrix, y_matrix, nsamples=1000):
  auc_values= []
  ppv_values= []
  for b in range(nsamples):
    b_str=str(b)
    ##AUC CI
    idx = np.random.randint(X_matrix.shape[0], size=X_matrix.shape[0])
    X_matrix_sampling=pd.DataFrame(X_matrix)
    y_matrix_sampling=pd.DataFrame(y_matrix)
    predict_y = clf.predict_proba(X_matrix_sampling.iloc[idx])[:,1]
    roc_auc = metrics.roc_auc_score(y_matrix_sampling.iloc[idx], predict_y)*100
    auc_values.append(str(roc_auc)+'\n')
    ##PPV CI
    ppv_values.append('cutoff, TP, FP, FN, TN, Accuracy, Sensitivity/Recall, Specificity, PPV/Precision, NPV, F1-score, FPR, TPR\n')
    for cutoff in np.linspace(0.2,0.6,1001):
      report = classification_report(y_matrix_sampling.iloc[idx], predict_y, cutoff)
      ppv_values.append(str(report)+'\n')
  return auc_values, ppv_values


clf.fit(X_train, y_train)
model_i_str=str(i)
f = open ('/results/Figure 5/LPE_cfDNA_16/model/LPE_cfDNA_16.dat','wb')
pickle.dump(clf,f)
f.close()

###plot AUC
filename1='/results/Figure 5/LPE_cfDNA_16/auc/AUC_1.pdf'
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
#################test1
fpr,tpr,threshold = roc_curve(y_test1,clf.predict_proba(X_test1)[:,1],drop_intermediate=False)
roc_auc_test1_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='red',lw=lw, label='Test Set1(AUC = %0.2f)' % roc_auc_test1_plot)
#################test2
fpr,tpr,threshold = roc_curve(y_test2,clf.predict_proba(X_test2)[:,1],drop_intermediate=False)
roc_auc_test2_plot = auc(fpr,tpr)*100
plt.plot(fpr, tpr, color='purple',lw=lw, label='Test Set2(AUC = %0.2f)' % roc_auc_test2_plot)

plt.plot([0, 1], [0, 1], color='grey', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('cfDNA')
plt.legend(loc="lower right")
#plt.show()
plt.savefig(filename1)
plt.close()

##train AUC CI
train_auc_ci, train_ppv = bootstrap_auc(clf, X_train, y_train, nsamples=1000)
filename2='/results/Figure 5/LPE_cfDNA_16/ppv/train.PPV_CI.csv'
f = open(filename2,'a')
f.write(str(train_ppv)+'\n')
f.close()

filename3='/results/Figure 5/LPE_cfDNA_16/auc/train.AUC_CI.txt'
f = open(filename3,'a')
f.write(str(train_auc_ci)+'\n')
f.close()


##val AUC CI
val_auc_ci, val_ppv = bootstrap_auc(clf, X_val, y_val, nsamples=1000)
filename4='/results/Figure 5/LPE_cfDNA_16/ppv/val.PPV_CI.csv'
f = open(filename4,'a')
f.write(str(val_ppv)+'\n')
f.close()

filename5='/results/Figure 5/LPE_cfDNA_16/auc/val.AUC_CI.txt'
f = open(filename5,'a')
f.write(str(val_auc_ci)+'\n')
f.close()

##test AUC CI
test1_auc_ci, test1_ppv = bootstrap_auc(clf, X_test1, y_test1, nsamples=1000)
filename6='/results/Figure 5/LPE_cfDNA_16/ppv/test1.PPV_CI.csv'
f = open(filename6,'a')
f.write(str(test1_ppv)+'\n')
f.close()

filename7='/results/Figure 5/LPE_cfDNA_16/auc/test1.AUC_CI.txt'
f = open(filename7,'a')
f.write(str(test1_auc_ci)+'\n')
f.close()

##test2 AUC CI
test2_auc_ci, test2_ppv = bootstrap_auc(clf, X_test2, y_test2, nsamples=1000)
filename8='/results/Figure 5/LPE_cfDNA_16/ppv/test2.PPV_CI.csv'
f = open(filename8,'a')
f.write(str(test2_ppv)+'\n')
f.close()

filename9='/results/Figure 5/LPE_cfDNA_16/auc/test2.AUC_CI.txt'
f = open(filename9,'a')
f.write(str(test2_auc_ci)+'\n')
f.close()
