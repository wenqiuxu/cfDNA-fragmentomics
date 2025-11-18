library('ggplot2')
library('ggrepel')
library('RColorBrewer')
library(grid)
library(gridExtra)
#tss score
data <- read.table("/data/Extended Data Fig 3/tss_score.pvalue_fc.EPE.txt")
p1 <- ggplot(data = data, aes(x = V3, y = -log(V2)/log(10), colour=V4)) +
  geom_point(size=0.3) +
  scale_color_manual(values=c("steelblue4", "grey","red3")) +
  xlim(c(0.5, 1.7)) +
  theme_bw()+
  labs(x="Fold change",y="-log10(adjusted p-value)",title="TSS score") +
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5,size=6), legend.position="right", legend.title = element_blank()) 
pdf("/results/Extended Data Fig 3/tss_score.pvalue_fc.EPE.pdf", width=2.65, height=1.6)
grid.arrange(p1 ,ncol=1, nrow=1)
dev.off()


##gini
data <- read.table("/data/Extended Data Fig 3/gini.pvalue_fc.EPE.txt")
p1 <- ggplot(data = data, aes(x = V3, y = -log(V2)/log(10), colour=V4)) +
  geom_point(size=0.3) +
  scale_color_manual(values=c("steelblue4", "grey","red3")) +
  xlim(c(0.89, 1.043)) +
  theme_bw()+
  labs(x="Fold change",y="-log10(adjusted p-value)",title="gini") +
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5,size=6), legend.position="right", legend.title = element_blank())
pdf("/results/Extended Data Fig 3/gini.pvalue_fc.EPE.pdf", width=2.65, height=1.6)
grid.arrange(p1 ,ncol=1, nrow=1)
dev.off()
