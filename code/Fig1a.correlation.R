library("openxlsx")
library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)

data=read.xlsx("/data/Figure 1/Figure1.xlsx",sheet=1)
cols = c("steelblue4","#1B9E77","red3")

p1 <- ggplot(data=data, aes(x=reads_number, y=correlation, color=cfDNA_features))+
geom_point(size=0.6) +
theme_bw()+
#scale_fill_manual(values=getPalette(colourCount))+
scale_color_manual(values=cols)+
ylab("the correlation coefficient")+
xlab("depth")+
geom_vline(xintercept =600000000, linetype="dashed")+
theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
theme(strip.text=element_text(size=6))+
theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))
pdf("/result/Figure 1/Figure1a_whole_blood.pdf", height=1.225, width=2.5)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()

library("openxlsx")
library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)

data=read.xlsx("/data/Figure 1/Figure1.xlsx",sheet=2)
cols = c("steelblue4","#1B9E77","red3")

p1 <- ggplot(data=data, aes(x=reads_number, y=correlation, color=cfDNA_features))+
geom_point(size=0.6) +
theme_bw()+
#scale_fill_manual(values=getPalette(colourCount))+
scale_color_manual(values=cols)+
ylab("the correlation coefficient")+
xlab("depth")+
geom_vline(xintercept =600000000, linetype="dashed")+
theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
theme(strip.text=element_text(size=6))+
theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))

pdf("/result/Figure 1/Figure1a_placenta.pdf", height=1.225, width=2.5)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()
