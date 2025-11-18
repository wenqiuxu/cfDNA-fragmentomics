library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)
library(openxlsx)

data=read.xlsx("/data/Figure 1/Figure1.xlsx",sheet=6)
data=na.omit(data)
data1=data[data$tss_coverage>0.01,]
#cols = c("steelblue4","red3")
colourCount = length(unique(data1$TPM)) 
getPalette = colorRampPalette(brewer.pal(11, "RdBu"))
p_pos <- max(data1$tss_coverage)-0.1

p1 <- ggplot(data=data1,aes(x=factor(TPM), y=tss_coverage,fill=factor(TPM)))+
geom_boxplot(outlier.shape = NA, lwd=0.3 ) +
theme_bw()+
#scale_fill_manual(values=cols)+
scale_fill_manual(values=getPalette(colourCount))+
ylab("TSS coverage")+
xlab("the abundance of a transcript in blood")+
theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
theme(strip.text=element_text(size=6))+
theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
theme(legend.text=element_text(size=6),legend.key.size=unit(0.3,"cm"))+
stat_compare_means(label = "p.format",  method="kruskal.test", size=2, tip.length=0.03, label.y=0.55)+
labs(fill="TPM in placenta")+
theme(legend.position = 'bottom')+
 coord_cartesian(ylim =c(0,0.6))

pdf("/results/Figure 1/Figure1g.pdf", height=1.85, width=1.7)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()
