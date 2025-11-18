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

  #####1. pre-processing########################################
  cd $dir_name/$hospital/cleandata/$disease/$sample_name/
  bash pre_processing.sh

  #####2. align########################################
  cd $dir_name/$hospital/align_result/$disease/$sample_name/
  bash align.sh
  
  ####3. split chromosome########################################
  cd $dir_name/$hospital/align_result/$disease/$sample_name/split_chr
  bash bam_by_chr.sh

  #####4. remove unassemble#######################################
  bash rm_unassemble.sh

  #####5. bam filter##############################################
  bash bam_filter.sh

  #####6. bam2bed#################################################
  bash bam2bed.sh

  #####7. Extract cfDNA features####################################
  cd $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr
  bash cfDNA_features.sh

  #####8.merge cfDNA features#######################################
  cd $dir_name/$hospital/cfDNA_features/$disease/$sample_name/
  bash merge_gini.GRCh38_RNA.sh
  bash merge_tss_rpkm.GRCh38_RNA.sh
  bash merge_tss_score.GRCh38_RNA.sh

done
