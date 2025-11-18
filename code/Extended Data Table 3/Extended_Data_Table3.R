library(Rmisc)
library(openxlsx)
##test1 set
CTRL=read.xlsx("/data/Extended Data Table 3/Extended_Data_Table3.xlsx",sheet=1,rowNames = T)
nrow(CTRL)
LPE=read.xlsx("/data/Extended Data Table 3/Extended_Data_Table3.xlsx",sheet=2,rowNames = T)
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

median(na.omit(CTRL$GA_delivery))
sd(na.omit(CTRL$GA_delivery))
median(na.omit(LPE$GA_delivery))
sd(na.omit(LPE$GA_delivery))

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

data=matrix(c(197,135,88,84),nrow=2)
fisher.test(data)
data=matrix(c(197,135,29,44),nrow=2)
fisher.test(data)

data=matrix(c(197,135,68,34),nrow=2)
fisher.test(data)
data=matrix(c(197,135,2,5),nrow=2)
fisher.test(data)

data=matrix(c(197,135,2,2),nrow=2)
fisher.test(data)

data=matrix(c(197,135,3,23),nrow=2)
fisher.test(data)
data=matrix(c(197,135,194,112),nrow=2)
fisher.test(data)



##Test2 set
CTRL=read.xlsx("Extended_Data_Table3.xlsx",sheet=3,rowNames = T)
nrow(CTRL)
LPE=read.xlsx("Extended_Data_Table3.xlsx",sheet=4,rowNames = T)
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

median(na.omit(CTRL$GA_delivery))
sd(na.omit(CTRL$GA_delivery))
median(na.omit(LPE$GA_delivery))
sd(na.omit(LPE$GA_delivery))

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

data=matrix(c(124,91,52,35),nrow=2)
fisher.test(data)
data=matrix(c(124,91,19,15),nrow=2)
fisher.test(data)

data=matrix(c(124,91,26,13),nrow=2)
fisher.test(data)
data=matrix(c(124,91,2,1),nrow=2)
fisher.test(data)

data=matrix(c(124,91,0,7),nrow=2)
fisher.test(data)

data=matrix(c(124,91,13,6),nrow=2)
fisher.test(data)
data=matrix(c(124,91,111,85),nrow=2)
fisher.test(data)
