library(openxlsx)
library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)

## tss coverage
data=read.xlsx("/data/Figure 4/feature_selection.EPE.xlsx",sheet=1)
# lock in factor level order 
data$ID <- factor(data$ID , levels = data$ID )
data$ranking<-round(data$ranking,4)
p1 <- ggplot(data = data, aes(x=ID, y=ranking, color="#1F4527")) +
  geom_bar(stat="identity", color="black", fill="#1F4527", position=position_dodge(),alpha=0.4)+
  theme_bw()+
  #scale_fill_manual(values=cols)+
  ylab("relative ranking")+
  xlab("gene ID")+
  theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6,angle=90),axis.title=element_text(size=6))+
  labs(colour="group")+
  theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))+
  coord_cartesian(ylim =c(0.84,1.0))
pdf("/results/Figure 4/01.boruta.tss_coverage.barplot.pdf", height=1.5, width=2.5)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()

## tss score
data=read.xlsx("/data/Figure 4/feature_selection.EPE.xlsx",sheet=2)
# lock in factor level order 
data$ID <- factor(data$ID , levels = data$ID )
data$ranking<-round(data$ranking,4)
p1 <- ggplot(data = data, aes(x=ID, y=ranking, color="#1F4527")) +
  geom_bar(stat="identity", color="black", fill="#1F4527", position=position_dodge(),alpha=0.4)+
  theme_bw()+
  #scale_fill_manual(values=cols)+
  ylab("relative ranking")+
  xlab("gene ID")+
  theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6,angle=90),axis.title=element_text(size=6))+
  labs(colour="group")+
  theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))+
  coord_cartesian(ylim =c(0.15,1.0))
pdf("/results/Figure 4/01.boruta.tss_score.barplot.pdf", height=1.55, width=2.5)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()

##gini
data=read.xlsx("/data/Figure 4/feature_selection.EPE.xlsx",sheet=3)
# lock in factor level order 
data$ID <- factor(data$ID , levels = data$ID )
data$ranking<-round(data$ranking,4)
p1 <- ggplot(data = data, aes(x=ID, y=ranking, color="#1F4527")) +
  geom_bar(stat="identity", color="black", fill="#1F4527", position=position_dodge(),alpha=0.4)+
  theme_bw()+
  #scale_fill_manual(values=cols)+
  ylab("relative ranking")+
  xlab("gene ID")+
  theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6,angle=90),axis.title=element_text(size=6))+
  labs(colour="group")+
  theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))+
  coord_cartesian(ylim =c(0.89,1.0))
pdf("/results/Figure 4/01.boruta.gini.barplot.pdf", height=1.5, width=2.5)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()
