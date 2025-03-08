for chr_name in {1..22}
do

  ####3.1 GRCh38 RNA Calculate mapped reads number##################
  total_mapping_reads_cfDNA_1=`cat /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr[0-9]*/chr*.filter_flags.flagstat.txt|grep 'total'|awk '{total_cfDNA_1+=$1} END {print total_cfDNA_1}'`
  ####3.2 GRCh38 RNA calculate TSS coverage############################
  bedtools intersect -a /home/cfDNA_1/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.sorted.bed -b /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.sorted.bed -wa -wb -sorted|cut -f 1-5|sort|uniq -c|awk -v mapped_reads_number_cfDNA_1=$total_mapping_reads_cfDNA_1 '{len=($4-$3-1); FPKM_cfDNA_1=($1*1000000000)/(len*mapped_reads_number_cfDNA_1); print $2":"$3":"$4":"$5":"$6"\t"$1"\t"FPKM_cfDNA_1}'|msort|filter -k s -c -d 0 -A 1,A,M -B 1,E,M /home/cfDNA_1/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.msort - |grep '^chr'$chr_name':'|cut -f 1,3- > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.GRCh38_RNA.tss_rpkm
  ####3.3 Calculate TSS score###############################
  cat /home/cfDNA_1/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.sorted.bin_100bp|awk -v chromosome=$chr_name '$1=="chr"chromosome'|bedtools coverage -a - -b /home/cfDNA_1/hospital1/align_result/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.sorted.bed -sorted|sort -k7,7 -k4,4|perl /home/cfDNA_1/script/wgs/tss_score/calculate_TSS_score.pl|awk -v mapped_reads_number_cfDNA_1=$total_mapping_reads_cfDNA_1 '{FPKM_cfDNA_1=($2*1000000000)/(100*mapped_reads_number_cfDNA_1); print $0"\t"FPKM_cfDNA_1}'> /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.GRCh38_RNA.tss_score

  ####3.4 GRCh38 RNA Calculate DELFI################################
  ####3.4.1 Calculate mapped reads number and mappability per bin##########
  bedtools coverage -a /home/cfDNA_1/reference/GRCh38/windows/split_chr/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb.chr$chr_name.sorted.bed -b /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.TLEN.sorted.txt -sorted > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.5MB_bin_mapped_result.txt
  ####3.4.2 Calculate 100-150bp mapped reads number per bin##############
  cat /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.TLEN.sorted.txt|awk '$4>=100 && $4<=150'|bedtools coverage -a /home/cfDNA_1/reference/GRCh38/windows/split_chr/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb.chr$chr_name.sorted.bed -b - -sorted > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.5MB_bin_mapped_result.100_150bp.txt
  cat /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.TLEN.sorted.txt|awk '$4>=151 && $4<=220'|bedtools coverage -a /home/cfDNA_1/reference/GRCh38/windows/split_chr/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb.chr$chr_name.sorted.bed -b - -sorted > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.5MB_bin_mapped_result.151_220bp.txt

  ####3.5  GRCh38 RNA Build insert length from 100 to 300 matrix############
  bedtools intersect -a /home/cfDNA_1/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.sorted.bed -b /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.TLEN.sorted.txt -wa -wb -sorted|awk '$7>=$2 && $8<=$3'|awk '{print $1":"$2":"$3":"$4":"$5"\t"$9}'|perl /home/cfDNA_1/script/wgs/build_matrix.len_100_300.pl > /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/cfDNA_1.chr$chr_name.GRCh38_RNA.insert_length.100_300.matrix.txt

  ####3.6 GRCh38 RNA Calculate Gini#################################
  Rscript /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
done
