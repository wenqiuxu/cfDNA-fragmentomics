library("ggplot2")
library("ggSankeyGrad")
##tss coverage EPE
df <- read.csv("/data/Extended Data Fig 5/tss_coverage.features_annotation_database.EPE.txt", header = T, sep = '\t',stringsAsFactors=FALSE)
pdf("/results/Extended Data Fig 5/tss_coverage.features_annotation_database.EPE.pdf", width=4.6, height=3)
with(df, ggSankeyGrad(c1 = TSS, c2 = database, values = n, col1=col1, col2=col2, label = FALSE, padding=0))
dev.off()
##tss score EPE
df <- read.csv("/data/Extended Data Fig 5/tss_score.features_annotation_database.EPE.txt", header = T, sep = '\t',stringsAsFactors=FALSE)
pdf("/results/Extended Data Fig 5/tss_score.features_annotation_database.EPE.pdf", width=4.6, height=1.5)
with(df, ggSankeyGrad(c1 = TSS, c2 = database, values = n, col1=col1, col2=col2, label = FALSE, padding=0))
dev.off()
##gini EPE
df <- read.csv("/data/Extended Data Fig 5/gini.features_annotation_database.EPE.txt", header = T, sep = '\t',stringsAsFactors=FALSE)
pdf("/results/Extended Data Fig 5/gini.features_annotation_database.EPE.pdf", width=4.6, height=5)
with(df, ggSankeyGrad(c1 = TSS, c2 = database, values = n, col1=col1, col2=col2, label = FALSE, padding=0))
dev.off()

##tss coverage LPE
df <- read.csv("/data/Extended Data Fig 5/tss_coverage.features_annotation_database.LPE.txt", header = T, sep = '\t',stringsAsFactors=FALSE)
pdf("/results/Extended Data Fig 5/tss_coverage.features_annotation_database.LPE.pdf", width=4.6, height=3)
with(df, ggSankeyGrad(c1 = TSS, c2 = database, values = n, col1=col1, col2=col2, label = FALSE, padding=0))
dev.off()
##tss score LPE
df <- read.csv("/data/Extended Data Fig 5/tss_score.features_annotation_database.LPE.txt", header = T, sep = '\t',stringsAsFactors=FALSE)
pdf("/results/Extended Data Fig 5/tss_score.features_annotation_database.LPE.pdf", width=4.6, height=1.5)
with(df, ggSankeyGrad(c1 = TSS, c2 = database, values = n, col1=col1, col2=col2, label = FALSE, padding=0))
dev.off()
##gini LPE
df <- read.csv("/data/Extended Data Fig 5/gini.features_annotation_database.LPE.txt", header = T, sep = '\t',stringsAsFactors=FALSE)
pdf("/results/Extended Data Fig 5/gini.features_annotation_database.LPE.pdf", width=4.6, height=5)
with(df, ggSankeyGrad(c1 = TSS, c2 = database, values = n, col1=col1, col2=col2, label = FALSE, padding=0))
dev.off()
