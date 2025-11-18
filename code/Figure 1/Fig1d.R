library(ggplot2)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)
library(openxlsx)

data=read.xlsx("/data/Figure 1/Figure1.xlsx",sheet=3)
data=na.omit(data)
data1=data[data$tss_score>0.01,]
colourCount = length(unique(data1$reads_number)) 
#getPalette = colorRampPalette(brewer.pal(9, "Blues"))
getPalette = rep("#36648b",colourCount )

df2_count <- summarySE(data1, measurevar="tss_score",groupvars=c("reads_number","TPM"))
p_tss_score<-compare_means(tss_score~ TPM, data = data1, group.by = "reads_number",method="kruskal.test")

p1 <- ggplot(df2_count)+
geom_boxplot(aes(x=factor(reads_number),y=ci, group=factor(reads_number),fill=factor(reads_number)), outlier.shape = NA, width=0.7, lwd=0.3) + 
geom_point(aes(x=factor(reads_number),y=ci, group=factor(reads_number)), size=0.01) + 
scale_fill_manual(values=getPalette)+
geom_vline(xintercept =16, linetype="dashed")+
#scale_color_manual(values=getPalette(colourCount))+
theme_bw()+
#ylab("pTSS score")+
#xlab("")+
theme(plot.title = element_text(hjust = 0.5, size=6, face="bold"))+
theme(strip.background=element_blank(),    panel.border=element_rect(colour="black"))+
theme(strip.text=element_text(size=6))+
theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
theme(legend.position='none')+
#theme(legend.text=element_text(size=6),legend.title=element_blank(),legend.key.size=unit(0.3,"cm"))+
coord_cartesian(ylim =c(0,0.26))+
scale_y_continuous(sec.axis = sec_axis(~.*400, name = '-log10(p.adjust)'))+
geom_point(data = p_tss_score, aes(x=factor(reads_number),y=-log10(p.adj)/400), colour="#Cd0000",size=0.5)+
geom_line(data =  p_tss_score, aes(x=factor(reads_number),y=-log10(p.adj)/400,group =1),colour="#Cd0000",cex=0.7)

pdf("/results/Figure 1/Figure1d.pdf", height=1.21, width=2)
grid.arrange(p1)
dev.off()
