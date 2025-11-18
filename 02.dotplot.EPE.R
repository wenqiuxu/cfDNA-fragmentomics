library('ggplot2')
library('ggrepel')
library('RColorBrewer')
library(grid)
library(gridExtra)
library(openxlsx)
##tss score
EPE_GO=read.xlsx("/data/Extended Data Fig 3/enrichment_EPE.xlsx",sheet=1)
EPE_GO_filter=head(EPE_GO,n=15)
GO_p=ggplot(data=EPE_GO_filter, aes(y=Description,x=`%InGO`))+
  geom_point(aes(y=reorder(Description,`#GeneInGOAndHitList`), color=LogP, size=`%InGO`))+
  scale_size_area(max_size = 3)+
  theme_bw()+
  scale_color_gradient(low="#d90424",high="#374a89")+
  xlab("Gene ratio (%)")+
  ylab("Description")+
  theme(axis.text.x=element_text(color="black",size=6),axis.text.y=element_text(color="black",size=6),axis.title=element_text(size=6))
pdf(file = '/results/Extended Data Fig 3/tss_score.EPE.GO.pdf',width = 4,height = 1.5)
grid.arrange(GO_p,ncol=1, nrow=1)
dev.off()

##gini
EPE_GO=read.xlsx("/data/Extended Data Fig 3/enrichment_EPE.xlsx",sheet=3)
EPE_GO_filter=head(EPE_GO,n=15)
GO_p=ggplot(data=EPE_GO_filter, aes(y=Description,x=`%InGO`))+
  geom_point(aes(y=reorder(Description,`#GeneInGOAndHitList`), color=LogP, size=`%InGO`))+
  scale_size_area(max_size = 3)+
  theme_bw()+
  scale_color_gradient(low="#d90424",high="#374a89")+
  xlab("Gene ratio (%)")+
  ylab("Description")+
  theme(axis.text.x=element_text(color="black",size=6),axis.text.y=element_text(color="black",size=6),axis.title=element_text(size=6))
pdf(file = '/results/Extended Data Fig 3/gini.EPE.GO.pdf',width = 3.8,height = 1.5)
grid.arrange(GO_p,ncol=1, nrow=1)
dev.off()


