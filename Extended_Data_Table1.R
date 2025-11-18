library(Rmisc)
library(openxlsx)
##test1 set
CTRL=read.xlsx("/data/Extended Data Table 1/Extended_Data_Table1.xlsx",sheet=1,rowNames = T)
nrow(CTRL)
EPE=read.xlsx("/data/Extended Data Table 1/Extended_Data_Table1.xlsx",sheet=2,rowNames = T)
nrow(EPE)
CTRL=as.data.frame(CTRL)
EPE=as.data.frame(EPE)

median(CTRL$Age)
sd(CTRL$Age)
median(EPE$Age)
sd(EPE$Age)

median(CTRL$GA_sampling)
sd(CTRL$GA_sampling)
median(EPE$GA_sampling)
sd(EPE$GA_sampling)

median(na.omit(CTRL$GA_delivery))
sd(na.omit(CTRL$GA_delivery))
median(na.omit(EPE$GA_delivery))
sd(na.omit(EPE$GA_delivery))

median(EPE$GA_diagnosis)
sd(EPE$GA_diagnosis)

median(CTRL$Height)
sd(CTRL$Height)
median(EPE$Height)
sd(EPE$Height)

median(CTRL$Weight)
sd(CTRL$Weight)
median(EPE$Weight)
sd(EPE$Weight)

median(CTRL$BMI)
sd(CTRL$BMI)
median(EPE$BMI)
sd(EPE$BMI)

median(CTRL$MAP)
sd(CTRL$MAP)
median(EPE$MAP)
sd(EPE$MAP)

wilcox.test(unlist(EPE$Age),unlist(CTRL$Age)) 
wilcox.test(unlist(EPE$Height),unlist(CTRL$Height)) 
wilcox.test(unlist(EPE$Weight),unlist(CTRL$Weight)) 
wilcox.test(unlist(EPE$BMI),unlist(CTRL$BMI)) 
wilcox.test(unlist(EPE$MAP),unlist(CTRL$MAP)) 
wilcox.test(unlist(EPE$GA_sampling),unlist(CTRL$GA_sampling)) 
wilcox.test(unlist(EPE$GA_delivery),unlist(CTRL$GA_delivery)) 

data=matrix(c(197,23,88,18),nrow=2)
fisher.test(data)
data=matrix(c(197,23,29,10),nrow=2)
fisher.test(data)

data=matrix(c(197,23,68,11),nrow=2)
fisher.test(data)
data=matrix(c(197,23,2,1),nrow=2)
fisher.test(data)

data=matrix(c(197,23,2,2),nrow=2)
fisher.test(data)

data=matrix(c(197,23,3,2),nrow=2)
fisher.test(data)
data=matrix(c(197,23,194,21),nrow=2)
fisher.test(data)



##Test2 set
CTRL=read.xlsx("Extended_Data_Table1.xlsx",sheet=3,rowNames = T)
nrow(CTRL)
EPE=read.xlsx("Extended_Data_Table1.xlsx",sheet=4,rowNames = T)
nrow(EPE)
CTRL=as.data.frame(CTRL)
EPE=as.data.frame(EPE)

median(CTRL$Age)
sd(CTRL$Age)
median(EPE$Age)
sd(EPE$Age)

median(CTRL$GA_sampling)
sd(CTRL$GA_sampling)
median(EPE$GA_sampling)
sd(EPE$GA_sampling)

median(na.omit(CTRL$GA_delivery))
sd(na.omit(CTRL$GA_delivery))
median(na.omit(EPE$GA_delivery))
sd(na.omit(EPE$GA_delivery))

median(EPE$GA_diagnosis)
sd(EPE$GA_diagnosis)

median(CTRL$Height)
sd(CTRL$Height)
median(EPE$Height)
sd(EPE$Height)

median(CTRL$Weight)
sd(CTRL$Weight)
median(EPE$Weight)
sd(EPE$Weight)

median(CTRL$BMI)
sd(CTRL$BMI)
median(EPE$BMI)
sd(EPE$BMI)

median(CTRL$MAP)
sd(CTRL$MAP)
median(EPE$MAP)
sd(EPE$MAP)

wilcox.test(unlist(EPE$Age),unlist(CTRL$Age)) 
wilcox.test(unlist(EPE$Height),unlist(CTRL$Height)) 
wilcox.test(unlist(EPE$Weight),unlist(CTRL$Weight)) 
wilcox.test(unlist(EPE$BMI),unlist(CTRL$BMI)) 
wilcox.test(unlist(EPE$MAP),unlist(CTRL$MAP)) 
wilcox.test(unlist(EPE$GA_sampling),unlist(CTRL$GA_sampling)) 
wilcox.test(unlist(EPE$GA_delivery),unlist(CTRL$GA_delivery)) 

data=matrix(c(124,36,52,17),nrow=2)
fisher.test(data)
data=matrix(c(124,36,19,7),nrow=2)
fisher.test(data)

data=matrix(c(124,36,26,6),nrow=2)
fisher.test(data)
data=matrix(c(124,36,2,0),nrow=2)
fisher.test(data)

data=matrix(c(124,36,0,2),nrow=2)
fisher.test(data)

data=matrix(c(124,36,13,7),nrow=2)
fisher.test(data)
data=matrix(c(124,36,111,29),nrow=2)
fisher.test(data)