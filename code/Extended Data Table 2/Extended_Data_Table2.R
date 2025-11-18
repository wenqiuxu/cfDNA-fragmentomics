library(Rmisc)
library(openxlsx)
##training set
CTRL=read.xlsx("/data/Extended Data Table 2/Extended_Data_Table2.xlsx",sheet=1,rowNames = T)
nrow(CTRL)
LPE=read.xlsx("/data/Extended Data Table 2/Extended_Data_Table2.xlsx",sheet=2,rowNames = T)
nrow(LPE)
CTRL=as.data.frame(CTRL)
LPE=as.data.frame(LPE)

median(CTRL$Age)
sd(CTRL$Age)
median(LPE$Age)
sd(LPE$Age)

median(CTRL$GA_sampling)
sd(CTRL$GA_sampling)
median(LPE$GA_sampling)
sd(LPE$GA_sampling)

median(CTRL$GA_delivery)
sd(CTRL$GA_delivery)
median(LPE$GA_delivery)
sd(LPE$GA_delivery)

median(LPE$GA_diagnosis)
sd(LPE$GA_diagnosis)

median(CTRL$Height)
sd(CTRL$Height)
median(LPE$Height)
sd(LPE$Height)

median(CTRL$Weight)
sd(CTRL$Weight)
median(LPE$Weight)
sd(LPE$Weight)

median(CTRL$BMI)
sd(CTRL$BMI)
median(LPE$BMI)
sd(LPE$BMI)

median(CTRL$MAP)
sd(CTRL$MAP)
median(EPE$MAP)
sd(EPE$MAP)

wilcox.test(unlist(LPE$Age),unlist(CTRL$Age)) 
wilcox.test(unlist(LPE$Height),unlist(CTRL$Height)) 
wilcox.test(unlist(LPE$Weight),unlist(CTRL$Weight)) 
wilcox.test(unlist(LPE$BMI),unlist(CTRL$BMI)) 
wilcox.test(unlist(LPE$MAP),unlist(CTRL$MAP)) 
wilcox.test(unlist(LPE$GA_sampling),unlist(CTRL$GA_sampling)) 
wilcox.test(unlist(LPE$GA_delivery),unlist(CTRL$GA_delivery))

data=matrix(c(146,84,78,26),nrow=2)
fisher.test(data)
data=matrix(c(146,84,31,15),nrow=2)
fisher.test(data)

data=matrix(c(146,84,55,17),nrow=2)
fisher.test(data)
data=matrix(c(146,84,3,2),nrow=2)
fisher.test(data)

data=matrix(c(146,84,0,7),nrow=2)
fisher.test(data)

data=matrix(c(146,84,9,21),nrow=2)
fisher.test(data)
data=matrix(c(146,84,137,63),nrow=2)
fisher.test(data)


##Validation set
CTRL=read.xlsx("Extended_Data_Table2.xlsx",sheet=3,rowNames = T)
nrow(CTRL)
LPE=read.xlsx("Extended_Data_Table2.xlsx",sheet=4,rowNames = T)
nrow(LPE)
CTRL=as.data.frame(CTRL)
LPE=as.data.frame(LPE)

median(CTRL$Age)
sd(CTRL$Age)
median(LPE$Age)
sd(LPE$Age)

median(CTRL$GA_sampling)
sd(CTRL$GA_sampling)
median(LPE$GA_sampling)
sd(LPE$GA_sampling)

median(CTRL$GA_delivery)
sd(CTRL$GA_delivery)
median(LPE$GA_delivery)
sd(LPE$GA_delivery)

median(LPE$GA_diagnosis)
sd(LPE$GA_diagnosis)

median(CTRL$Height)
sd(CTRL$Height)
median(LPE$Height)
sd(LPE$Height)

median(CTRL$Weight)
sd(CTRL$Weight)
median(LPE$Weight)
sd(LPE$Weight)

median(CTRL$BMI)
sd(CTRL$BMI)
median(LPE$BMI)
sd(LPE$BMI)

median(CTRL$MAP)
sd(CTRL$MAP)
median(LPE$MAP)
sd(LPE$MAP)

wilcox.test(unlist(LPE$Age),unlist(CTRL$Age)) 
wilcox.test(unlist(LPE$Height),unlist(CTRL$Height)) 
wilcox.test(unlist(LPE$Weight),unlist(CTRL$Weight)) 
wilcox.test(unlist(LPE$BMI),unlist(CTRL$BMI)) 
wilcox.test(unlist(LPE$MAP),unlist(CTRL$MAP)) 
wilcox.test(unlist(LPE$GA_sampling),unlist(CTRL$GA_sampling)) 
wilcox.test(unlist(LPE$GA_delivery),unlist(CTRL$GA_delivery))  

data=matrix(c(84,59,37,27),nrow=2)
fisher.test(data)
data=matrix(c(84,59,14,16),nrow=2)
fisher.test(data)

data=matrix(c(84,59,29,24),nrow=2)
fisher.test(data)
data=matrix(c(84,59,3,5),nrow=2)
fisher.test(data)

data=matrix(c(84,59,0,1),nrow=2)
fisher.test(data)

data=matrix(c(84,59,1,11),nrow=2)
fisher.test(data)
data=matrix(c(84,59,83,48),nrow=2)
fisher.test(data)
