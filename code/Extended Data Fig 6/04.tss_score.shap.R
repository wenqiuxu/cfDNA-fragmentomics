library(randomForest) 
library(iml) 
library(caret) 
library(ggplot2) 
library(dplyr)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(ggpubr)
library(Rmisc)
library(shapviz) 
library(shapr)
library(reshape2)

##gini
disease=read.table("/data/Extended Data Fig 6/shap.tss_score.late_PE.train_valid.txt",header=T,sep="\t",check.names=F,row.names=1)
control=read.table("/data/Extended Data Fig 6/shap.tss_score.control.train_valid.txt",header=T,sep="\t",check.names=F,row.names=1)
data=merge(control,disease,by="row.names",all=TRUE)
rownames(data)=data[,1]
data=data[,-1]
data_t=t(data)
group <- factor(c(rep("CTRL",ncol(control)),rep("PE",ncol(disease))))
data_merge=cbind(group,data_t)
data_merge=as.data.frame(data_merge)
data_merge$group=as.factor(data_merge$group)
#cross validation
cv_folds <- createFolds(data_merge$group, k = 10)
shap_values <- NULL
feature_names <- colnames(data_merge[, -1])

for (fold in seq_along(cv_folds)) {
  train_indices <- setdiff(seq_len(nrow(data_merge)), cv_folds[[fold]])
  test_indices <- cv_folds[[fold]]
  train_data <- data_merge[train_indices, ]
  test_data <- data_merge[test_indices, ]
  
  rf_model <- randomForest(group ~ ., data = train_data)
  shap_fold <- fastshap::explain(rf_model, 
                                 X = train_data[, -1],
                                 newdata = test_data[, -1],
                                 pred_wrapper = function(object, newdata) {
                                   as.numeric(predict(object, newdata, type = "prob")[, 2])
                                 },
                                 nsim = 10
  )  
  shap_df <- as.data.frame(shap_fold)
  shap_df$index <- test_indices  
  shap_df$fold <- fold
  
  shap_values <- rbind(shap_values, shap_df)
}

shap_long <- melt(
  shap_values, 
  id.vars = c("index", "fold"), 
  variable.name = "feature", 
  value.name = "shap_value"
)

p1 <- ggplot(shap_long, aes(x = reorder(feature, abs(shap_value), FUN = mean), y = shap_value, color = shap_value)) +
  geom_jitter(size = 0.2, width = 0.2, height=0.0, alpha=0.4) +
  geom_violin(alpha=0.01,color="#304E7E",linewidth=0.3)+
  #scale_color_viridis(option = "plasma") + 
  scale_color_gradient(low = "#CC7977", high = "#304E66") +
  coord_flip() +
  theme_minimal() +
  ylab("Mean SHAP Value")+
  xlab("gene ID")+
  theme_bw()+
  theme(strip.background=element_blank(),  panel.border=element_rect(colour="black"))+
  theme(strip.text=element_text(size=6))+
  theme(axis.ticks = element_blank(),axis.text.y=element_text(size=6),axis.text.x=element_text(size=6),axis.title=element_text(size=6))+
  theme(legend.text=element_text(size=6),legend.title=element_text(size=6),legend.key.size=unit(0.3,"cm"))
#coord_cartesian(ylim =c(0.94,1.0))

pdf("/results/Extended Data Fig 6/04.shap.tss_score.LPE.rf.pdf", height=1.5, width=2.5)
grid.arrange(p1, nrow=1, ncol=1)
dev.off()


