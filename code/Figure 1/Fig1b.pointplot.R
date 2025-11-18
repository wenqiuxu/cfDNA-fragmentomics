library("openxlsx")
library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)

data=read.xlsx("/data/Figure 1/Figure1.xlsx",sheet=1)
dat=data[data$cfDNA_features=="gini",]

p1 <- ggplot(data=dat, aes(x=reads_number, y=depth))+
geom_point(color="steelblue4", size=0.5) +
theme_bw()+
#scale_fill_manual(values=getPalette(colourCount))+
#scale_color_manual(values=cols)+
xlab("the number of sequencing reads")+
ylab("Final depth")+
geom_vline(xintercept =600000000, linetype="dashed")+
geom_hline(yintercept =9.936, linetype="dashed")+
theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
theme(strip.text=element_text(size=6))+
theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))

pdf("/results/Figure 1/Figure1b.pdf", height=1.225, width=1.55)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()
