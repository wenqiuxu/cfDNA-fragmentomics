library(leaps)
disease=read.table("/data/Extended Data Fig 6/regsubsets.tss_score.late_PE.train_valid.txt",header=T,sep="\t",check.names=F,row.names=1)
control=read.table("/data/Extended Data Fig 6/regsubsets.tss_score.control.train_valid.txt",header=T,sep="\t",check.names=F,row.names=1)
data=merge(control,disease,by="row.names",all=TRUE)
group <- factor(c(rep("0",ncol(control)),rep("1",ncol(disease))))
rownames(data)=data[,1]
data=data[,-1]
data_t=t(data)
data_merge=cbind(data_t,group)
data_merge=as.data.frame(data_merge)

predict.regsubsets <- function(object, newdata, id, ...){
  form <- as.formula(object$call[[2]])
  mat <- model.matrix(form, newdata)
  coefi <- coef(object, id=id)
  xvars <- names(coefi)
  mat[, xvars] %*% coefi
}

k <- 10
set.seed(1)
folds <- sample(1:k, nrow(data_merge), replace=TRUE)

cv.errors <- matrix(as.numeric(NA), k, 20, dimnames=list(NULL, paste(1:20)))
for(j in 1:k){ # 对
  best.fit <- regsubsets(group ~ ., data=data_merge[folds != j,], nvmax=20,really.big=T)
  for(i in 1:20){
    pred <- predict(best.fit, data_merge[folds==j,], id=i)
    cv.errors[j, i] <- mean((data_merge[folds==j, 'group'] - pred)^2 )
  }
}
head(cv.errors)

mean.cv.errors <- apply(cv.errors, 2, mean)
mean.cv.errors

best.id <- which.min(mean.cv.errors)
plot(mean.cv.errors, type='b')
pdf("/results/Extended Data Fig 6/03.tss_score.regsubsets.LPE.pdf", height=3.4, width=3.6)
plot(mean.cv.errors, type='p',pch=20)
dev.off()

reg.best <- regsubsets(group ~ ., data=data_merge, nvmax=20)
coef(reg.best, id=best.id)
write.table(coef(reg.best, id=best.id),file="/results/Extended Data Fig 6/03.tss_score.regsubsets.LPE.txt",sep="\t")
