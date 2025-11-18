library('ggplot2')
library('ggrepel')
library('RColorBrewer')
library(grid)
library(gridExtra)
library(openxlsx)
##tss score
LPE_dis=read.xlsx("/data/Extended Data Fig 4/enrichment_LPE.xlsx",sheet=2)
LPE_dis_filter=head(LPE_dis,n=5)
GO_p=ggplot(data=LPE_dis_filter, aes(x=reorder(Description,-LogP),y= -LogP))+
  geom_bar(stat='identity',fill="#D5E1D6",color="black")+
  coord_flip()+
  #scale_size_area(max_size = 3)+
  theme_bw()+
  scale_color_gradient(low="#d90424",high="#374a89")+
  ylab("-Log10(P-value)")+
  xlab("")+
  theme(axis.text.x=element_text(color="black",size=6),axis.text.y=element_text(color="black",size=6),axis.title=element_text(size=6))
pdf(file = '/results/Extended Data Fig 4/tss_score.LPE.DisGeNET.pdf',width = 2.6,height = 0.8)
grid.arrange(GO_p,ncol=1, nrow=1)
dev.off()


##gini
LPE_dis=read.xlsx("/data/Extended Data Fig 4/enrichment_LPE.xlsx",sheet=4)
LPE_dis_filter=head(LPE_dis,n=5)
GO_p=ggplot(data=LPE_dis_filter, aes(x=reorder(Description,-LogP),y= -LogP))+
  geom_bar(stat='identity',fill="#D5E1D6",color="black")+
  coord_flip()+
  #scale_size_area(max_size = 3)+
  theme_bw()+
  scale_color_gradient(low="#d90424",high="#374a89")+
  ylab("-Log10(P-value)")+
  xlab("")+
  theme(axis.text.x=element_text(color="black",size=6),axis.text.y=element_text(color="black",size=6),axis.title=element_text(size=6))
pdf(file = '/results/Extended Data Fig 4/gini.LPE.DisGeNET.pdf',width = 2.6,height = 0.8)
grid.arrange(GO_p,ncol=1, nrow=1)
dev.off()

