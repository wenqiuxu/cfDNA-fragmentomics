library(grid)
library(gridExtra)
library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2) 
library(openxlsx) 
library(psych)

data=read.table("/data/Figure 5/features.EPE.all.txt",header=TRUE,row.names = 1,check.names = F)
data_t=t(data)
data_t=as.data.frame(data_t)
data_filter=data_t[data_t$GA_sampling>=11 & data_t$GA_sampling<=21,]
data_filter=as.data.frame(data_filter)
data_filter$features=as.numeric(data_filter$features)
data_filter$GA_sampling=as.numeric(data_filter$GA_sampling)
breaks <-c (11,12,13,14,15,16,17,18,19,20,21)
df_summary <-data_filter%>% mutate(GA_sampling_breaks =cut(GA_sampling,breaks =breaks))%>%group_by(group,gene, features_type,GA_sampling_breaks) %>% summarise(median_GA_sampling=median(GA_sampling),median_features=median(features))
df_summary <-na.omit(df_summary)
##correlation
df_corr <-df_summary %>%group_by(group, gene, features_type)%>%summarise(correlation =corr.test(median_GA_sampling,median_features)$r,p_value =corr.test(median_GA_sampling,median_features)$p)
write.table(df_corr, file="/results/Figure 5/features.EPE.corr.txt",quote=F,row.names=F)

p1 <- ggplot(data = df_summary, aes(x = median_GA_sampling, y = median_features, group=interaction(group, gene))) +
  geom_smooth(data =subset(df_summary,(gene!="CHD9") & (gene!="TFDP2")),method ="lm",size =0.5,color ="grey",se = F)+
  geom_smooth(data =subset(df_summary,(gene=="CHD9")| (gene=="TFDP2")),method ="lm",size =0.5,aes(color =gene),se = F)+
  theme_bw()+
  labs(x="GA sampling (weeks)",y="MoM",title="") +
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5), legend.position="right", legend.title = element_blank())+
  coord_cartesian(ylim = c(0.8,1.3)) 
pdf("/results/Figure 5/features.EPE.GA.pdf", width=2.3, height=1.6)
grid.arrange(p1 ,ncol=1, nrow=1)
dev.off()


##LPE
data=read.table("/data/Figure 5/features.LPE.all.txt",header=TRUE,row.names = 1,check.names = F)
data_t=t(data)
data_t=as.data.frame(data_t)
data_filter=data_t[data_t$GA_sampling>=11 & data_t$GA_sampling<=21,]
data_filter=as.data.frame(data_filter)
data_filter$features=as.numeric(data_filter$features)
data_filter$GA_sampling=as.numeric(data_filter$GA_sampling)
breaks <-c (11,12,13,14,15,16,17,18,19,20,21)
df_summary <-data_filter%>% mutate(GA_sampling_breaks =cut(GA_sampling,breaks =breaks))%>%group_by(group,gene, features_type,GA_sampling_breaks) %>% summarise(median_GA_sampling=median(GA_sampling),median_features=median(features))
df_summary <-na.omit(df_summary)
##correlation
df_corr <-df_summary %>%group_by(group, gene, features_type)%>%summarise(correlation =corr.test(median_GA_sampling,median_features)$r,p_value =corr.test(median_GA_sampling,median_features)$p)
write.table(df_corr, file="/results/Figure 5/features.LPE.corr.txt",quote=F,row.names=F)

p1 <- ggplot(data = df_summary, aes(x = median_GA_sampling, y = median_features, group=interaction(group, gene))) +
  geom_smooth(data =subset(df_summary,(gene!="CHD9") & (gene!="LRP1B")),method ="lm",size =0.5,color ="grey",se = F)+
  geom_smooth(data =subset(df_summary,(gene=="CHD9")| (gene=="LRP1B")),method ="lm",size =0.5,aes(color =gene),se = F)+
  theme_bw()+
  labs(x="GA sampling (weeks)",y="MoM",title="") +
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(margin=margin(5,5,-1,5),size=6),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6), plot.title = element_text(hjust = 0.5), legend.position="right", legend.title = element_blank())+
  coord_cartesian(ylim = c(0.85,1.15)) 
pdf("/results/Figure 5/features.LPE.GA.pdf", width=2.3, height=1.6)
grid.arrange(p1 ,ncol=1, nrow=1)
dev.off()