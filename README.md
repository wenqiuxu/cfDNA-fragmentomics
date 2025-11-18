#1、operation environment

Linux



#2、download human genome reference

##GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna:

https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.39_GRCh38.p13/GRCh38_major_release_seqs_for_alignment_pipelines/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz




#3、software download and install


##3.1 bwa

download: wget http://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2

tar -jxvf bwa-0.7.17.tar.bz2

#First, you need to install three packages: make, build-essential, and zlib1g-dev. Otherwise, an error will occur.

#sudo apt-get install make sudo apt-get install build-essential sudo apt-get install zlib1g-dev

cd bwa-0.7.17/

make

vi ~/.bashrc

export PATH=$PATH:/home/software/bwa-0.7.17

source ~/.bashrc


##3.2 samtools-1.15.1

download: https://github.com/samtools/samtools

./configure

make

make install

vi ~/.bashrc

export PATH=/home/samtools-1.15.1/htslib-1.15.1/bin:/home/software/samtools-1.15.1/bi:$PATH

export LD_LIBRARY_PATH=/home/software/samtools-1.15.1/htslib-1.15.1/lib:/home/software/samtools-1.15.1/htslib-1.15.1:$LD_LIBRARY_PATH

source ~/.bashrc


##3.3 BamDeal

download: https://github.com/BGI-shenzhen/BamDeal

tar -zxvf  BamDeal-XXX.tar.gz

cd BamDeal-XXX

chmod 755  configure  

./configure

make

vi ~/.bashrc

export PATH=/home/software/BamDeal-0.27:$PATH

source ~/.bashrc


##3.4 bedtools

download: wget https://github.com/arq5x/bedtools2/releases/download/v2.29.1/bedtools-2.29.1.tar.gz

tar -zxvf bedtools-2.29.1.tar.gz

cd bedtools2

make

vi ~/.bashrc

export PATH=/home/software/bedtools2-2.29.2/bin:$PATH

source ~/.bashrc


##3.5 SOAPnuke

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


##3.6 R

download: R-4.1.3

./configure --enable-R-shlib --with-readline=yes --with-libpng=yes --with-blas --with-x=no --with-pcre1 --prefix=/software/R-4.1.3

make

make install


if (!require("remotes")) install.packages("remotes")

remotes::install_github("AndriSignorell/DescTools")



##3.7 python3

download: Python 3.8.9

./configure --enable-loadable-sqlite-extensions --enable-shared --enable-optimizations --prefix=/software/Python-3.8.9 --with-openssl=/software/openssl-1.1.1n/build

make 

make test

make install


pip install -U scikit-learn --prefix=/software/Python-3.8.9

python packages: numpy, scipy, pandas, matplotlib, reportlab, biopython, pyfaidx, pysam, pyvcf, sklearn





#4、Usage instructions

##4.1 Build script for calculate cfDNA fragmentomics: cfDNA coverage, cfDNA score and Gini coefficients

bash /code/02.generate_scripts.run.sh 



####4.2 Run the corresponding scripts sequentially. 

bash /code/04.extract_cfDNA_features.run.sh 


##runing scripts including in /code/extract_cfDNA_features.run.sh:

bash pre_processing.sh #the script in /results/hospital/cleandata directory

bash align.sh  #the script in /data/hospital/align_result directory

bash bam_by_chr.sh #the script in /data/hospital/align_result directory

bash rm_unassemble.sh #the script in /data/hospital/align_result directory

bash bam_filter.sh #the script in /data/hospital/align_result directory

bash bam2bed.sh #the script in /data/hospital/align_result directory

bash cfDNA_features.sh #the script in /data/hospital/cfDNA_features directory

bash merge_gini.GRCh38_RNA.sh #the script in /data/hospital/cfDNA_features directory

bash merge_tss_score.GRCh38_RNA.sh #the script in /data/hospital/cfDNA_features directory

bash merge_tss_rpkm.GRCh38_RNA.sh #the script in /data/hospital/cfDNA_features directory



####4.3 Run the script for differential analyses

Rscript 05.wilcox.R 

#This is only an example. Full scripts can be found at the following paths: 

/code/Figure 3/00.wilcox.tss_coverage.EPE.R

/code/Figure 3/00.wilcox.tss_coverage.LPE.R

/code/Extended Data Fig 3/00.wilcox.gini.EPE.R

/code/Extended Data Fig 3/00.wilcox.tss_score.EPE.R

/code/Extended Data Fig 4/00.wilcox.gini.LPE.R

/code/Extended Data Fig 4/00.wilcox.tss_score.LPE.R

#Relevant input files (e.g., "GRCh38_RNA.tss_coverage.control.train_valid.txt", "GRCh38_RNA.tss_coverage.early_PE.train_valid.txt") are located in /data/.



###4.4 Run the script for feature importance

python3 06.boruta_selection.tss_coverage.EPE.py

#This is only an example. Full scripts and input files can be found at the following paths:

/data/Figure sourcedata and code/Figure 4

/data/Figure sourcedata and code/Extended Data Fig 6



###4.5 Run the script for optimal subsets

Rscript 06.tss_coverage.regsubsets.R

#This is only an example. Full scripts and input files can be found at the following paths:

 /data/Figure sourcedata and code/Figure 4
 
 /data/Figure sourcedata and code/Extended Data Fig 6




##5. model performance

python3 07.model_tune.py #This script is for tuning model parameters.

python3 07.model_performance.py #This script is for evaluating models. 

#These are only examples. Full scripts and input files can be found at the following paths:

/data/Figure 4

/data/Figure 5

/data/Extended Data Fig 6

/data/Extended Data Fig 7

/data/Extended Data Fig 8

/data/Extended Data Fig 9

/data/Extended Data Fig 10

/data/model_matrix_EPE

/data/model_matrix_LPE




