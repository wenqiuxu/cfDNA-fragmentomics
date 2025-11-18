library(grid)
library(gridExtra)
library(plyr)
library(ggplot2) 
library(openxlsx) 
##EPE 12-26w
data=read.xlsx("/data/Figure 5/performance.xlsx",sheet = 1)
data$Features=factor(data$Features, levels=c('MFs','cfDNA fragmentomics','combined'))
datasets <- unique(data$Dataset)
plotlist=list()
for(i in 1:length(datasets)){
  dat <- subset(data, Dataset==datasets[i])
  p1 <- ggplot(data = dat, aes(x = Features, y = Sensitivity, fill=Features)) +
    geom_bar(stat="identity", color="black", position=position_dodge()) +
    #scale_fill_brewer(palette="Reds")+
    scale_fill_manual(values=c("#7c9d97", "#9cb0c3","#e9b383")) +
    theme_bw()+
    theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_blank(),axis.title=element_text(size=6))+
    theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5), legend.position="right", legend.title = element_blank())
  plotlist[[i]]=p1
}
pdf("/results/Figure 5/model_performance.Sensitivity.12_26.EPE.pdf", width=6.6, height=1.4)
grid.arrange(grobs=plotlist,  ncol=3)
dev.off()


###LPE 12-26w
data=read.xlsx("/data/Figure 5/performance.xlsx",sheet = 2)
data$Features=factor(data$Features, levels=c('MFs','cfDNA fragmentomics','combined'))
datasets <- unique(data$Dataset)
plotlist=list()
for(i in 1:length(datasets)){
  dat <- subset(data, Dataset==datasets[i])
  p1 <- ggplot(data = dat, aes(x = Features, y = Sensitivity, fill=Features)) +
    geom_bar(stat="identity", color="black", position=position_dodge()) +
    #scale_fill_brewer(palette="Reds")+
    scale_fill_manual(values=c("#7c9d97", "#9cb0c3","#e9b383")) +
    theme_bw()+
    theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_blank(),axis.title=element_text(size=6))+
    theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5), legend.position="right", legend.title = element_blank())
  plotlist[[i]]=p1
}
pdf("/results/Figure 5/model_performance.Sensitivity.12_26.LPE.pdf", width=6.6, height=1.4)
grid.arrange(grobs=plotlist,  ncol=3)
dev.off()


