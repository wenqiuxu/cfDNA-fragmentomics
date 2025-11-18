library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggplot2)
library(ggpubr)
library(Rmisc)
library(openxlsx)
cols = c("#EAA96D","#5A769E","#73979B")
##10x
data=read.xlsx("/data/Extended Data Fig 7/predownsampled_depth.xlsx",sheet=1)
p1 <- ggplot(data=data,aes(x=group, y=downsampled_depth, fill=group))+
  geom_boxplot(alpha=0.5) +  
  theme_bw()+
  scale_fill_manual(values=cols)+
  theme(plot.title = element_text(hjust = 0.5, size=6))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.position="None")+
  coord_cartesian(ylim =c(10,10.5))
pdf("/results/Extended Data Fig 7/depth_10x.boxplot.pdf", height=1.2, width=1.5)
grid.arrange(p1,  ncol=1)
dev.off()

##10_30x
data=read.xlsx("/data/Extended Data Fig 7/predownsampled_depth.xlsx",sheet=2)
p1 <- ggplot(data=data,aes(x=group, y=predownsampled_depth, fill=group))+
  geom_boxplot(alpha=0.5, outlier.shape = 16, outlier.size = 1) +  
  theme_bw()+
  scale_fill_manual(values=cols)+
  theme(plot.title = element_text(hjust = 0.5, size=6))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.position="None")+
  coord_cartesian(ylim =c(10,31))
pdf("/results/Extended Data Fig 7/depth_10_30x.boxplot.pdf.boxplot.pdf", height=1.2, width=1.5)
grid.arrange(p1,  ncol=1)
dev.off()

##>30x
data=read.xlsx("/data/Extended Data Fig 7/predownsampled_depth.xlsx",sheet=3)
p1 <- ggplot(data=data,aes(x=group, y=predownsampled_depth, fill=group))+
  geom_boxplot(alpha=0.5, outlier.shape = 16, outlier.size = 1) +  
  theme_bw()+
  scale_fill_manual(values=cols)+
  theme(plot.title = element_text(hjust = 0.5, size=6))+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.position="None")+
  coord_cartesian(ylim =c(30,55))

pdf("/results/Extended Data Fig 7/depth_30x.boxplot.pdf.boxplot.pdf", height=1.2, width=1.5)
grid.arrange(p1,  ncol=1)
dev.off()
