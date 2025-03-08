####6. bam2bed#########################################
bedtools bamtobed -i /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam|sort -k1,1 -k2,2n > /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.sorted.bed
while [ $? -ne 0 ]
do
  bedtools bamtobed -i /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam|sort -k1,1 -k2,2n > /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.sorted.bed
done

####7. extract insert length###########################
samtools view /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam|awk -F "\t" 'function abs(x) {return ((x<0.0) ? -x:x)} {start_20P6252302_1=$4-1; end_20P6252302_1=$4+abs($9); if($9>0) print $3"\t"start_20P6252302_1"\t"end_20P6252302_1"\t"abs($9)"\t"$1}'|sort -k1,1 -k2,2n > /home/xuwenqiu/cfDNA/saturation/jiangmen/cfDNA_features/EPE/20P6252302_1/20P6252302_1.TLEN.sorted.txt
while [ $? -ne 0 ]
do
  samtools view /home/xuwenqiu/cfDNA/saturation/jiangmen/align_result/EPE/20P6252302_1/20P6252302_1.filter_flags.bam|awk -F "\t" 'function abs(x) {return ((x<0.0) ? -x:x)} {start_20P6252302_1=$4-1; end_20P6252302_1=$4+abs($9); if($9>0) print $3"\t"start_20P6252302_1"\t"end_20P6252302_1"\t"abs($9)"\t"$1}'|sort -k1,1 -k2,2n > /home/xuwenqiu/cfDNA/saturation/jiangmen/cfDNA_features/EPE/20P6252302_1/20P6252302_1.TLEN.sorted.txt
done
