#####2.1 align pair end#########################################
bwa mem -t 8 /home/reference/GRCh38/GRCh38_bwa/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna /home/cfDNA_1/hospital1/cleandata/CTRL/cfDNA_1/cfDNA_1.clean.read1.fq.gz /home/cfDNA_1/hospital1/cleandata/CTRL/cfDNA_1/cfDNA_1.clean.read2.fq.gz > /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/cfDNA_1.sam
samtools view -@ 8 -o /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/cfDNA_1.bam /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/cfDNA_1.sam
