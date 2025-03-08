#####5. bam filter#######################################
samtools sort -@ 8 -o /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.bam /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.bam
rm /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.bam
samtools rmdup /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.bam /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.rmdup.bam
samtools flagstat -@ 8 /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.rmdup.bam > /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.rmdup.flagstat.txt
rm /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.bam
samtools view -@ 8 -h /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.rmdup.bam|awk -F "\t" '{if($1~/^@/) print $0; else if(($2==81 || $2==83 || $2==97 || $2==99 || $2==145 || $2==147 || $2==161 || $2==163) && $7=="=") print $0}'|samtools view -@ 8 -b -S -o /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam
rm /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.uniq.sort.rmdup.bam
samtools index -@ 8 /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam
samtools flagstat -@ 8 /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam > /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.flagstat.txt
