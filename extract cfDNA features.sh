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
  qsub -cwd -l vf=30G -q all.q -pe smp 1 pre_processing.sh o>pre_processing.jid

  #####2. align########################################
  cd $dir_name/$hospital/align_result/$disease/$sample_name/
  pre_processing_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/cleandata/$disease/$sample_name/pre_processing.jid`
  qsub -cwd -l vf=10G -q all.q -pe smp 1 -hold_jid $pre_processing_id align.sh o> align.jid
  
  ####3. split chromosome########################################
  cd $dir_name/$hospital/align_result/$disease/$sample_name/split_chr
  align_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/align_result/$disease/$sample_name/align.jid`
  qsub -cwd -l vf=10G -q all.q -pe smp 1 -hold_jid align.jid bam_by_chr.sh o>bam_by_chr.jid

  #####4. remove unassemble#######################################
  bam_by_chr_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_by_chr.jid`
  qsub -cwd -l vf=1G -q all.q -pe smp 1 -hold_jid $bam_by_chr_id rm_unassemble.sh o>rm_unassemble.jid

  #####5. bam filter##############################################
  rm_unassemble_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/rm_unassemble.jid`
  qsub -cwd -l vf=20G -q all.q -pe smp 8 -hold_jid $rm_unassemble_id bam_filter.sh o>bam_filter.jid

  #####6. bam2bed#################################################
  bam_filter_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam_filter.jid`
  qsub -cwd -l vf=50G -q all.q -pe smp 1 -hold_jid $bam_filter_id bam2bed.sh o>bam2bed.jid

  #####7. Extract cfDNA features####################################
  cd $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr
  bam2bed_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/align_result/$disease/$sample_name/split_chr/bam2bed.jid`
  qsub -cwd -l vf=10G -q all.q -pe smp 1 -hold_jid $bam2bed_id cfDNA_features.sh o>cfDNA_features.jid

  #####8.merge cfDNA features#######################################
  cd $dir_name/$hospital/cfDNA_features/$disease/$sample_name/
  cfDNA_feature_id=`perl -n -e '/(\d+)/ && print $1' $dir_name/$hospital/cfDNA_features/$disease/$sample_name/split_chr/cfDNA_features.jid`
  qsub -cwd -l vf=2G -q all.q -pe smp 1 -hold_jid $cfDNA_feature_id merge_gini.GRCh38_RNA.sh
  qsub -cwd -l vf=2G -q all.q -pe smp 1 -hold_jid $cfDNA_feature_id merge_tss_rpkm.GRCh38_RNA.sh
  qsub -cwd -l vf=2G -q all.q -pe smp 1 -hold_jid $cfDNA_feature_id merge_tss_score.GRCh38_RNA.sh

done
