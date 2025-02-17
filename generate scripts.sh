##########first step: to generate scripts##############################
cat $1|while read sample_info
do
  IFS_OLD=$IFS
  IFS=$'\t'
  arr=($sample_info)
  barcode_info=${arr[0]}
  sample_name=${arr[1]}
  disease=${arr[2]}
  hospital=${arr[3]}
  bam_dir=${arr[4]}
  dir_name=${arr[5]}

  #####1. extract bam file##########################################
  IFS=$';'
  barcodes=(${arr[0]})
  barcode_num=${#barcodes[@]}
  bam_file=""
  for ((i=0; i<barcode_num; i++)){
    if [ -z $bam_file ]; then
      bam_file="$bam_dir/${barcodes[$i]}/result_alignment/${barcodes[$i]}.bam"
    else
      bam_file="$bam_file $bam_dir/${barcodes[$i]}/result_alignment/${barcodes[$i]}.bam"
    fi
  }
  echo $bam_file

  #####1. split chromosome########################################
  mkdir -p $dir_name/
  mkdir -p $dir_name/$hospital
  mkdir -p $dir_name/$hospital/align_result
  mkdir -p $dir_name/$hospital/align_result/$disease
  mkdir -p $dir_name/$hospital/align_result/$disease/$sample_name
  mkdir -p $dir_name/$hospital/align_result/$disease/$sample_name/split_chr

  mkdir -p $dir_name/$hospital/cfDNA_features
  mkdir -p $dir_name/$hospital/cfDNA_features/$disease
  mkdir -p $dir_name/$hospital/cfDNA_features/$disease/$sample_name
  mkdir -p $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr


  echo "#####1. split chromosome###################################" > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_by_chr.sh
  echo "ulimit -n 4096" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_by_chr.sh
  echo "BamDeal modify bamSplit -i $bam_file -o $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_by_chr.sh

  echo "#####2. remove unassemble genome###########################" > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/rm_unassemble.sh
  echo "rm chr[0-9XY]*_*_random.bam chrUn_*.bam" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/rm_unassemble.sh
  echo "mkdir -p tmp/" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/rm_unassemble.sh
  echo "mv chrY.bam UnMap.bam chrM.bam chrEBV.bam tmp/" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/rm_unassemble.sh

  echo "#####2.1. bam filter#######################################" > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "for chr_name in {1..22} X" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "do" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "  mkdir -p $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh 
  echo "  mv $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name.bam $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "  samtools view -@ 8 -h $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.bam|awk -F \"\t\" '{if(\$1~/^@/) print \$0; else if((\$2==81 || \$2==83 || \$2==97 || \$2==99 || \$2==145 || \$2==147 || \$2==161 || \$2==163) && \$7==\"=\") print \$0}'|samtools view -@ 8 -b -S -o $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "  samtools index -@ 8 $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "  samtools flagstat -@ 8 $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.flagstat.txt" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "  rm $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.bam" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh
  echo "done" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.sh

  echo "for chr_name in {1..22}" > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "do" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  ####3.1 bam2bed#########################################" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  bedtools bamtobed -i $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam|sort -k1,1 -k2,2n > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.sorted.bed" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  while [ \$? -ne 0 ]" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  do" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "    bedtools bamtobed -i $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam|sort -k1,1 -k2,2n > $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.sorted.bed" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  done" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  ####3.2 extract insert length##################################" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  samtools view $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam|awk -F \"\t\" 'function abs(x) {return ((x<0.0) ? -x:x)} {start_$sample_name=\$4-1; end_$sample_name=\$4+abs(\$9); if(\$9>0) print \$3\"\t\"start_$sample_name\"\t\"end_$sample_name\"\t\"abs(\$9)\"\t\"\$1}'|sort -k1,1 -k2,2n > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.TLEN.sorted.txt" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  while [ \$? -ne 0 ]" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  do" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "    samtools view $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.filter_flags.bam|awk -F \"\t\" 'function abs(x) {return ((x<0.0) ? -x:x)} {start_$sample_name=\$4-1; end_$sample_name=\$4+abs(\$9); if(\$9>0) print \$3\"\t\"start_$sample_name\"\t\"end_$sample_name\"\t\"abs(\$9)\"\t\"\$1}'|sort -k1,1 -k2,2n > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.TLEN.sorted.txt" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "  done" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh
  echo "done" >> $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.sh

  ####3. Extract cfDNA features#####################################
  echo "####3. Extract cfDNA features################################" > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "for chr_name in {1..22}" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "do" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  ####3.1 GRCh38 RNA Calculate mapped reads number##################" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  total_mapping_reads_$sample_name=\`cat $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr[0-9]*/chr*.filter_flags.flagstat.txt|grep 'total'|awk '{total_$sample_name+=\$1} END {print total_$sample_name}'\`" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh

  echo "  ####3.2 GRCh38 RNA calculate TSS coverage############################" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  bedtools intersect -a /home/xuwenqiu/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.sorted.bed -b $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.sorted.bed -wa -wb -sorted|cut -f 1-5|sort|uniq -c|awk -v mapped_reads_number_$sample_name=\$total_mapping_reads_$sample_name '{len=(\$4-\$3-1); FPKM_$sample_name=(\$1*1000000000)/(len*mapped_reads_number_$sample_name); print \$2\":\"\$3\":\"\$4\":\"\$5\":\"\$6\"\t\"\$1\"\t\"FPKM_$sample_name}'|msort|filter -k s -c -d 0 -A 1,A,M -B 1,E,M /home/xuwenqiu/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.msort - |grep '^chr'\$chr_name':'|cut -f 1,3- > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.GRCh38_RNA.tss_rpkm" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh

  echo "  ####3.3 Calculate TSS score###############################" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  cat /home/xuwenqiu/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.sorted.bin_100bp|awk -v chromosome=\$chr_name '\$1==\"chr\"chromosome'|bedtools coverage -a - -b $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.sorted.bed -sorted|sort -k7,7 -k4,4|perl /home/xuwenqiu/script/wgs/tss_score/calculate_TSS_score.pl|awk -v mapped_reads_number_$sample_name=\$total_mapping_reads_$sample_name '{FPKM_$sample_name=(\$2*1000000000)/(100*mapped_reads_number_$sample_name); print \$0\"\t\"FPKM_$sample_name}'> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.GRCh38_RNA.tss_score" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh

  echo "  ####3.4 GRCh38 RNA Calculate DELFI################################" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  ####3.4.1 Calculate mapped reads number and mappability per bin##########" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  bedtools coverage -a /home/xuwenqiu/reference/GRCh38/windows/split_chr/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb.chr\$chr_name.sorted.bed -b $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.TLEN.sorted.txt -sorted > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.5MB_bin_mapped_result.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  ####3.4.2 Calculate 100-150bp mapped reads number per bin##############" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.TLEN.sorted.txt|awk '\$4>=100 && \$4<=150'|bedtools coverage -a /home/xuwenqiu/reference/GRCh38/windows/split_chr/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb.chr\$chr_name.sorted.bed -b - -sorted > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.5MB_bin_mapped_result.100_150bp.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.TLEN.sorted.txt|awk '\$4>=151 && \$4<=220'|bedtools coverage -a /home/xuwenqiu/reference/GRCh38/windows/split_chr/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb.chr\$chr_name.sorted.bed -b - -sorted > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.5MB_bin_mapped_result.151_220bp.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh

  echo "  ####3.5  GRCh38 RNA Build insert length from 100 to 300 matrix############" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "  bedtools intersect -a /home/xuwenqiu/reference/GRCh38/annotation/features_2kb/TSS/TSS_2kb.GCA_000001405.15_GRCh38.refseq_annotation.RNA.sorted.bed -b $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.TLEN.sorted.txt -wa -wb -sorted|awk '\$7>=\$2 && \$8<=\$3'|awk '{print \$1\":\"\$2\":\"\$3\":\"\$4\":\"\$5\"\t\"\$9}'|perl /home/xuwenqiu/script/wgs/build_matrix.len_100_300.pl > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/$sample_name.chr\$chr_name.GRCh38_RNA.insert_length.100_300.matrix.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh

  echo "  ####3.6 GRCh38 RNA Calculate Gini#################################" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  for chr_name in {1..22}
  do
    mkdir -p $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name
    echo "library(\"DescTools\")" > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "gini_index <- function(x,range=seq(100,300)){" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "xx=Gini(range,weights=x)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "return(xx)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "}" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "chr${chr_name}_${sample_name}<-read.table(\"$dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/$sample_name.chr$chr_name.GRCh38_RNA.insert_length.100_300.matrix.txt\", header=TRUE, row.names=\"TSS_ID\")" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "chr${chr_name}_${sample_name}_filter<-chr${chr_name}_${sample_name}[which(rowSums(chr${chr_name}_${sample_name}) > 0),]" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "chr${chr_name}_${sample_name}_filter\$gini<-apply(chr${chr_name}_${sample_name}_filter,1,gini_index)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
    echo "write.table(data.frame(TSS_ID=rownames(chr${chr_name}_${sample_name}_filter),chr${chr_name}_${sample_name}_filter\$gini),\"$dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/${sample_name}_chr${chr_name}.GRCh38_RNA.gini.txt\",sep=\"\t\",row.names=F,quote=FALSE)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr$chr_name/chr$chr_name.GRCh38_RNA.Gini.R
  done

  echo "  Rscript $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr\$chr_name/chr\$chr_name.GRCh38_RNA.Gini.R" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh
  echo "" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.sh

  ####4. merge cfDNA features#########################################
  mkdir -p $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output
  cd $dir_name/$hospital/cfDNA_features/$disease/$sample_name

  ####4.1 GRCh38 RNA merge TSS coverage##################################
  echo "for chr_name in {1..22}" > merge_tss_rpkm.GRCh38_RNA.sh
  echo "do" >> merge_tss_rpkm.GRCh38_RNA.sh
  echo "cat split_chr/chr\$chr_name/$sample_name.chr\$chr_name.GRCh38_RNA.tss_rpkm >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.tss_rpkm" >> merge_tss_rpkm.GRCh38_RNA.sh
  echo "done" >> merge_tss_rpkm.GRCh38_RNA.sh
  echo "cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.tss_rpkm|cut -f 1-3|perl ~/script/wgs/cfDNA_features.nor_med.pl|awk 'BEGIN {print \"ID\tcount\ttss_rpkm\ttss_rpkm_nor_med\"} {print \$0}' > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.tss_rpkm.nor_med.txt" >> merge_tss_rpkm.GRCh38_RNA.sh
  

  ####4.2 GRCh38 RNA merge mapped reads number per bin ##################
  mkdir -p $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI
  echo "cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr*/$sample_name.chr*.5MB_bin_mapped_result.100_150bp.txt|msort -k4,4|filter -k s -c -d 0 -A 2,A,M -B 4,E,M /home/xuwenqiu/reference/GRCh38/windows/DELFI_reference/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb_GC.msort -|awk '{print \$1\"\t\"\$2\"\t\"\$3\"\t\"\$8}' > $sample_name.5MB_bin_mapped_result.100_150bp.raw.txt" > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  echo "cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/chr*/$sample_name.chr*.5MB_bin_mapped_result.151_220bp.txt|msort -k4,4|filter -k s -c -d 0 -A 2,A,M -B 4,E,M /home/xuwenqiu/reference/GRCh38/windows/DELFI_reference/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.5mb_GC.msort -|awk '{print \$1\"\t\"\$2\"\t\"\$3\"\t\"\$8}' > $sample_name.5MB_bin_mapped_result.151_220bp.raw.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  
  echo "####4.3 GC bias #################################################" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  echo "data1=read.table(\"$sample_name.5MB_bin_mapped_result.100_150bp.raw.txt\",sep='\t',header=F)" > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "names(data1)=c(\"Chromosome\",\"Bin\",\"GC\",\"ReadsNumber\")" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "model=loess(ReadsNumber~GC,data=data1)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data1\$Fit <- model\$fit" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "Median1 <- median(data1\$ReadsNumber)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data1\$WeightValue <- (Median1/data1\$Fit)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data1\$loessReads <- data1\$ReadsNumber * data1\$WeightValue" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "write.table(data1,\"$sample_name.5MB_bin_mapped_result.100_150bp.GC_correct.txt\",sep=\"\t\",row.names=F,quote=FALSE)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data2=read.table(\"$sample_name.5MB_bin_mapped_result.151_220bp.raw.txt\",sep='\t',header=F)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "names(data2)=c(\"Chromosome\",\"Bin\",\"GC\",\"ReadsNumber\")" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "model=loess(ReadsNumber~GC,data=data2)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data2\$Fit <- model\$fit" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "Median2 <- median(data2\$ReadsNumber)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data2\$WeightValue <- (Median2/data2\$Fit)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "data2\$loessReads <- data2\$ReadsNumber * data2\$WeightValue" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R
  echo "write.table(data2,\"$sample_name.5MB_bin_mapped_result.151_220bp.GC_correct.txt\",sep=\"\t\",row.names=F,quote=FALSE)" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R

  echo "Rscript $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/correct_GC_bias.R" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  echo "cat $sample_name.5MB_bin_mapped_result.151_220bp.GC_correct.txt|grep -v 'Chromosome'|cut -f 1,2,7|msort > $sample_name.5MB_bin_mapped_result.151_220bp.GC_correct.msort" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  echo "cat $sample_name.5MB_bin_mapped_result.100_150bp.GC_correct.txt|grep -v 'Chromosome'|cut -f 1,2,7|msort > $sample_name.5MB_bin_mapped_result.100_150bp.GC_correct.msort" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  echo "filter -k s -c -d 0 -A 1,A,M -B 1,E,M $sample_name.5MB_bin_mapped_result.100_150bp.GC_correct.msort $sample_name.5MB_bin_mapped_result.151_220bp.GC_correct.msort|perl /home/xuwenqiu/script/wgs/DELFI/normalized_ratio.pl > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.DELFI.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh
  echo "cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.DELFI.txt|grep -vw '^ID'|cut -f 1-3|perl ~/script/wgs/cfDNA_features.nor_med.pl|awk 'BEGIN {print \"ID\tDELFI\tbins\tDELFI_nor_med\"} {print \$0}' > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.DELFI.nor_med.txt" >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/DELFI/merge_DELFI.sh

  ####4.3 GRCh38 RNA merge gini #####################################
  echo "for chr_name in {1..22}" > merge_gini.GRCh38_RNA.sh
  echo "do" >> merge_gini.GRCh38_RNA.sh
  echo "cat split_chr/chr\$chr_name/${sample_name}_chr\$chr_name.GRCh38_RNA.gini.txt|grep -v '^TSS_ID' >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.gini.txt" >> merge_gini.GRCh38_RNA.sh
  echo "done" >> merge_gini.GRCh38_RNA.sh
  echo "cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.gini.txt|cut -f 1-2|perl ~/script/wgs/cfDNA_features.nor_med.pl|awk 'BEGIN {print \"ID\tgini\tgini_nor_med\"} {print \$0}' > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.gini.nor_med.txt" >> merge_gini.GRCh38_RNA.sh

 
  ####4.4 GRCh38 RNA merge tss score##################################
  echo "for chr_name in {1..22}" > merge_tss_score.GRCh38_RNA.sh
  echo "do" >> merge_tss_score.GRCh38_RNA.sh
  echo "cat split_chr/chr\$chr_name/${sample_name}.chr\$chr_name.GRCh38_RNA.tss_score|grep -v '^TSS_ID' >> $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.tss_score.txt" >> merge_tss_score.GRCh38_RNA.sh
  echo "done" >> merge_tss_score.GRCh38_RNA.sh
  echo "cat $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.tss_score.txt|cut -f 1-2|perl ~/script/wgs/cfDNA_features.nor_med.pl|awk 'BEGIN {print \"ID\ttss_score\ttss_score_nor_med\"} {print \$0}' > $dir_name/$hospital/cfDNA_features/$disease/$sample_name/output/$sample_name.GRCh38_RNA.tss_score.nor_med.txt" >> merge_tss_score.GRCh38_RNA.sh
  
done
