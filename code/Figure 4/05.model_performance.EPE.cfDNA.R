library(grid)
library(gridExtra)
library(plyr)
library(ggplot2) 
library(openxlsx) 
data=read.xlsx("/data/Figure 4/05.model_performance.EPE.cfDNA.xlsx",sheet=1)
data_summary <- function(data, varname, groupnames){ 
  require(plyr) 
  summary_func <- function(x, col){ 
    c(mean = mean(x[[col]], na.rm=TRUE), 
      sd = sd(x[[col]], na.rm=TRUE)) 
  } 
  data_sum<-ddply(data, groupnames, .fun=summary_func, varname) 
  data_sum <- rename(data_sum, c("mean" = varname)) 
  return(data_sum)
}
###AUC
df1 <- data_summary(data, varname="AUC", groupnames=c("the.number.of.cfDNA.features", "dataset")) 
# Convert dose to a factor variable 
df1$dataset=factor(df1$dataset,levels=c("training set","validation set","test set1","test set2"))
data$dataset <- factor(data$dataset, levels = c("training set", "validation set", "test set1", "test set2"))

p1 <- ggplot() +
  geom_bar(data = df1, aes(x = dataset, y = AUC, fill=the.number.of.cfDNA.features), stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(data = df1, aes(x = dataset, ymin=AUC-sd, ymax=AUC+sd, group=the.number.of.cfDNA.features), width=.4, position=position_dodge(.9))+
  geom_point(data = data, aes(x = dataset, y = AUC, group = the.number.of.cfDNA.features), color="black", position = position_dodge(0.9), size = 0.5) +
  scale_fill_brewer(palette="Blues")+
  theme_bw()+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6,angle=10),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5), legend.position="right", legend.title = element_blank()) +
  coord_cartesian(ylim = c(65, 100))
pdf("05.model_performance.EPE.cfDNA.AUC.pdf", width=2.9, height=1.4)
grid.arrange(p1 ,ncol=1, nrow=1)
dev.off()

###Sensitivity
df1 <- data_summary(data, varname="Sensitivity", 
                    groupnames=c("the.number.of.cfDNA.features", "dataset")) # Convert dose to a factor variable 
df1$dataset=factor(df1$dataset,levels=c("training set","validation set","test set1","test set2")) 
data$dataset <- factor(data$dataset, levels = c("training set", "validation set", "test set1", "test set2"))

p1 <- ggplot() +
  geom_bar(data = df1, aes(x = dataset, y = Sensitivity, fill=the.number.of.cfDNA.features), stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(data = df1, aes(x = dataset, ymin=Sensitivity-sd, ymax=Sensitivity+sd, group=the.number.of.cfDNA.features), width=.4, position=position_dodge(.9))+
  geom_point(data = data, aes(x = dataset, y = Sensitivity, group = the.number.of.cfDNA.features), color="black", position = position_dodge(0.9), size = 0.5) +
  scale_fill_brewer(palette="Reds")+
  theme_bw()+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6,angle=10),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5), legend.position="right", legend.title = element_blank())
pdf("/results/Figure 4/05.model_performance.EPE.cfDNA.Sensitivity.pdf", width=2.9, height=1.4)
grid.arrange(p1 ,ncol=1, nrow=1)
dev.off()
