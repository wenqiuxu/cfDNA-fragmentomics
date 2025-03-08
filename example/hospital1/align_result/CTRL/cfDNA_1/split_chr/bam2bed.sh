for chr_name in {1..22}
do
  ####3.1 bam2bed#########################################
  bedtools bamtobed -i /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam|sort -k1,1 -k2,2n > /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.sorted.bed
  while [ $? -ne 0 ]
  do
    bedtools bamtobed -i /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam|sort -k1,1 -k2,2n > /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.sorted.bed
  done

  ####3.2 extract insert length##################################
  samtools view /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam|awk -F "\t" 'function abs(x) {return ((x<0.0) ? -x:x)} {start_cfDNA_1=$4-1; end_cfDNA_1=$4+abs($9); if($9>0) print $3"\t"start_cfDNA_1"\t"end_cfDNA_1"\t"abs($9)"\t"$1}'|sort -k1,1 -k2,2n > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.TLEN.sorted.txt
  while [ $? -ne 0 ]
  do
    samtools view /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam|awk -F "\t" 'function abs(x) {return ((x<0.0) ? -x:x)} {start_cfDNA_1=$4-1; end_cfDNA_1=$4+abs($9); if($9>0) print $3"\t"start_cfDNA_1"\t"end_cfDNA_1"\t"abs($9)"\t"$1}'|sort -k1,1 -k2,2n > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.TLEN.sorted.txt
  done
done
