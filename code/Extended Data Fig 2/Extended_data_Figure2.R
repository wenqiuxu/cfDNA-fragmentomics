library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)
library(openxlsx)
data=read.xlsx("/data/Extended Data Fig 2/Extended_data_Figure2.xlsx")
##GA sampling
cols = c("#EAA96D","#5A769E","#73979B")
my_comparisons <- list(c("CTRL","EPE"),c("CTRL","LPE"))

datasets <- unique(data$Dataset)
plotlist=list()

for(i in 1:length(datasets)){
  dat <- subset(data, Dataset==datasets[i])
  p1 <- ggplot(data=dat,aes(x=group, y=GA_sampling, fill=group))+
    geom_violin(trim=FALSE, alpha=0.5) +  
    theme_bw()+
    scale_fill_manual(values=cols)+
    theme(plot.title = element_text(hjust = 0.5, size=6))+
    theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
    theme(strip.text=element_text(size=6))+
    theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
    theme(legend.position="None")+
    stat_compare_means(label = "p.format", size=2, tip.length=0.03, comparisons=my_comparisons)
  plotlist[[i]]=p1
}
pdf("/results/Extended Data Fig 2/GA_sampling.boxplot.pdf", height=5, width=1.5)
grid.arrange(grobs=plotlist,  ncol=1)
dev.off()

##downsampled_depth
datasets <- unique(data$Dataset)
plotlist=list()

for(i in 1:length(datasets)){
  dat <- subset(data, Dataset==datasets[i])
  p1 <- ggplot(data=dat,aes(x=group, y=downsampled_depth, fill=group))+
    geom_violin(trim=FALSE, alpha=0.5) +  
    theme_bw()+
    scale_fill_manual(values=cols)+
    theme(plot.title = element_text(hjust = 0.5, size=6))+
    theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
    theme(strip.text=element_text(size=6))+
    theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
    theme(legend.position="None")+
    stat_compare_means(label = "p.format", size=2, tip.length=0.03, label.y=c(10.5,10.7), comparisons=my_comparisons)+
    coord_cartesian(ylim =c(9.5,11))
  plotlist[[i]]=p1
}

pdf("/results/Extended Data Fig 2/downsampled_depth.boxplot.pdf", height=5, width=1.5)
grid.arrange(grobs=plotlist,  ncol=1)
dev.off()
