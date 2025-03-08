#####2.4 bam filter#######################################
for chr_name in {1..22} X
do
  mkdir -p /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/
  mv /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name.bam /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/
  samtools view -@ 8 -h /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.bam|awk -F "\t" '{if($1~/^@/) print $0; else if(($2==81 || $2==83 || $2==97 || $2==99 || $2==145 || $2==147 || $2==161 || $2==163) && $7=="=") print $0}'|samtools view -@ 8 -b -S -o /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam
  samtools index -@ 8 /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam
  samtools flagstat -@ 8 /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.bam > /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.filter_flags.flagstat.txt
  rm /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.bam
done
