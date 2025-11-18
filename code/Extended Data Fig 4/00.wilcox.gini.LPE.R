#!/usr/bin/env Rscript
args = commandArgs(trailingOnly = TRUE)
disease=read.table("/data/GRCh38_RNA.gini.late_PE.train_valid.txt",header=T,sep="\t")
control=read.table("/data/GRCh38_RNA.gini.control.train_valid.txt",header=T,sep="\t")


DE_TSSs <- function(disease,control){
  library("ggplot2")
  # detect differentially expressed TSSs using wilcoxon sum rank test
  results=mean_disease=mean_control=logfoldchange=abslogfoldchange=pvalue=BH=name=i=n=m=d=train_dis=test_dis=train_cont=test_cont=numeric()
  disease=aggregate(disease[,2:ncol(disease)], by=list(disease[,1]), FUN=mean,na.rm=T)
  control=aggregate(control[,2:ncol(control)], by=list(control[,1]), FUN=mean,na.rm=T)
  names=unlist(disease[,1])
  print(names[1])
  
  ##sampling
  index_dis <- sample(2:ncol(disease), ncol(disease)*0.9)
  train_dis=disease[,index_dis]
  index_cont <- sample(2:ncol(control), ncol(control)*0.9)
  train_cont=control[,index_cont]
  
  ncols_dis=ncol(train_dis)
  ncols_cont=ncol(train_cont)
  for(i in 1:nrow(disease)){
      n=rowSums(!is.na(train_dis[i,]))
      m=rowSums(!is.na(train_cont[i,]))
      if(n == ncols_dis && m == ncols_cont){ 
        k=mean(unlist(train_dis[i,]),na.rm=T) 
        mean_disease=c(mean_disease,k)
        q=mean(unlist(train_cont[i,]),na.rm=T) 
        mean_control=c(mean_control,q)
        logfoldchange=c(logfoldchange,log(k/q)) 
        abslogfoldchange=c(abslogfoldchange,abs(log(k/q)))
        d=wilcox.test(unlist(train_dis[i,]),unlist(train_cont[i,])) # use wilcox.test to analyze the expression difference of TSSs
        pvalue=c(pvalue,d$p.value)
        name=c(name,as.vector(names[i]))
        #print(name)
      }
    }
    BH=p.adjust(pvalue, method = "BH", n = length(pvalue)) # adjust the p values with BH
    deg_results=data.frame(v1=name,v2=mean_disease,v3=mean_control,v4=logfoldchange,v5=abslogfoldchange,v6=pvalue,v7=BH)
    colnames(deg_results)=c("ID","Mean_disease","Mean_control","logfoldchange","abs(logfoldchange)","Pvalue","FDR")
    results=list("DEG"=deg_results,"Disease"=disease,"Control"=control)
    return(results)
  }

  for (j in 1:1000){
    d=DE_TSSs(disease,control)
    name_dis <- as.character(strsplit(args[1],".txt"))
    name_cont <- as.character(strsplit(args[2],".txt"))
    deg=d$DEG
    write.table(d$DEG,file=paste("/results/Extended Data Fig 4/LPE/GRCh38_RNA.gini_DEG",j,"txt",sep="."),col.names=T,row.names=F,quote=F,sep="\t")
  }
