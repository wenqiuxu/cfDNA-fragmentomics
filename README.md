#1、operation environment
Linux


#2、Usage instructions
##1.1 Build script for calculate cfDNA fragmentomics: cfDNA coverage, cfDNA score and Gini coefficients
bash generate scripts.sh sample.info.txt  ##once it runs successfully, the analysis script will be generated in the corresponding folder.

####1.2 Run the corresponding scripts sequentially. In this shell script, use the qsub method to submit the scripts to be run.
bash extract cfDNA features.sh sample.info.txt
##If your system does not support qsub, you can run the following scripts sequentially.
bash pre_processing.sh #the script in cleandata directory
bash align.sh  #the script in align_result directory
bash bam_by_chr.sh #the script in align_result directory
bash rm_unassemble.sh #the script in align_result directory
bash bam_filter.sh #the script in align_result directory
bash bam2bed.sh #the script in align_result directory
bash cfDNA_features.sh #the script in cfDNA_features directory
bash merge_gini.GRCh38_RNA.sh #the script in cfDNA_features directory
bash merge_tss_score.GRCh38_RNA.sh #the script in cfDNA_features directory
bash merge_tss_rpkm.GRCh38_RNA.sh #the script in cfDNA_features directory


#3、download human genome reference
##GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna:
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.39_GRCh38.p13/GRCh38_major_release_seqs_for_alignment_pipelines/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz

#4、software download and install
##4.1 bwa
download: wget http://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
tar -jxvf bwa-0.7.17.tar.bz2
#First, you need to install three packages: make, build-essential, and zlib1g-dev. Otherwise, an error will occur.
#sudo apt-get install make sudo apt-get install build-essential sudo apt-get install zlib1g-dev
cd bwa-0.7.17/
make
vi ~/.bashrc
export PATH=$PATH:/home/software/bwa-0.7.17
source ~/.bashrc

##4.2 samtools-1.15.1
download: https://github.com/samtools/samtools
./configure
make
make install
vi ~/.bashrc
export PATH=/home/samtools-1.15.1/htslib-1.15.1/bin:/home/software/samtools-1.15.1/bi:$PATH
export LD_LIBRARY_PATH=/home/software/samtools-1.15.1/htslib-1.15.1/lib:/home/software/samtools-1.15.1/htslib-1.15.1:$LD_LIBRARY_PATH
source ~/.bashrc

##4.3 BamDeal
download: https://github.com/BGI-shenzhen/BamDeal
tar -zxvf  BamDeal-XXX.tar.gz
cd BamDeal-XXX
chmod 755  configure  
./configure
make
vi ~/.bashrc
export PATH=/home/software/BamDeal-0.27:$PATH
source ~/.bashrc

##4.4 bedtools
download: wget https://github.com/arq5x/bedtools2/releases/download/v2.29.1/bedtools-2.29.1.tar.gz
tar -zxvf bedtools-2.29.1.tar.gz
cd bedtools2
make
vi ~/.bashrc
export PATH=/home/software/bedtools2-2.29.2/bin:$PATH
source ~/.bashrc

##4.5 SOAPnuke
require: gcc: 4.7 or higher
         zlib: 1.2.3.5 or higher
         htslib: 1.9 or higher
         pthread library
         
git clone https://github.com/BGI-flexlab/SOAPnuke.git
cd SOAPnuke
make
vi ~/.bashrc
export PATH=/home/software/SOAPnuke-SOAPnuke2.1.7:$PATH
source ~/.bashrc
