library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)
library(openxlsx)

data=read.xlsx("/data/Extended Data Fig 1/Extended_data_Figure1.xlsx",sheet=8)
data=na.omit(data)

colourCount = length(unique(data$TPM)) 
getPalette = colorRampPalette(brewer.pal(11, "RdBu"))
#df2_count <- summarySE(data, measurevar="coverage",groupvars=c("relative_pos","TPM"))

p1 <- ggplot(data=data,aes(x=insert_size, y=4^coverage,color=factor(TPM)))+
geom_point(size=0.1)+
geom_line(size=0.5)+
theme_bw()+
scale_color_manual(values=getPalette(colourCount))+
ylab("4^read count")+
xlab("fragment length")+
theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
theme(strip.text=element_text(size=6))+
theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
theme(legend.text=element_text(size=6),legend.key.size=unit(0.3,"cm"))+
#stat_compare_means(label = "p.format",  method="t.test", size=2, tip.length=0.03, label.y=1.8)+
labs(color="TPM in placenta")+
theme(legend.position = 'bottom')+
 coord_cartesian(xlim =c(120,230))

pdf("/results/Extended Data Fig 1/Extended_data_Figure1i.pdf", height=1.9, width=1.7)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()




