library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)
##TSS score
data=read.table("/data/Extended Data Fig 3/boxplot.tss_score.NT5C2.txt",header=TRUE,sep="\t",check.names = F)
cols = c("#9cb0c3","#e9b383")
p1 <- ggplot(data=data,aes(x=group, y=TSS_score, fill=group))+
  geom_boxplot(outlier.shape = NA ) + 
  geom_point(size=0.01) + 
  theme_bw()+
  scale_fill_manual(values=cols)+
  ylab("TSS score")+
  xlab("")+
  ggtitle("NT5C2") +
  theme(plot.title = element_text(hjust = 0.5, size=6))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.position="None")+
  stat_compare_means(label = "p.format", size=2, tip.length=0.03, label.y=c(1.2), label.x=c(1.4))
pdf("/results/Extended Data Fig 3/boxplot.tss_score.NT5C2.pdf", height=1.2, width=1)
grid.arrange(p1,  ncol=1)
dev.off()


##gini NT5C2
data=read.table("/data/Extended Data Fig 3/boxplot.gini.NT5C2.txt",header=TRUE,sep="\t",check.names = F)
cols = c("#9cb0c3","#e9b383")
p1 <- ggplot(data=data,aes(x=group, y=Gini, fill=group))+
  geom_boxplot(outlier.shape = NA ) + 
  geom_point(size=0.01) + 
  theme_bw()+
  scale_fill_manual(values=cols)+
  ylab("Gini")+
  xlab("")+
  ggtitle("NT5C2") +
  theme(plot.title = element_text(hjust = 0.5, size=6))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.position="None")+
  stat_compare_means(label = "p.format", size=2, tip.length=0.03, label.y=c(1.2), label.x=c(1.4))
pdf("/results/Extended Data Fig 3/boxplot.gini.NT5C2.pdf", height=1.2, width=1)
grid.arrange(p1,  ncol=1)
dev.off()
