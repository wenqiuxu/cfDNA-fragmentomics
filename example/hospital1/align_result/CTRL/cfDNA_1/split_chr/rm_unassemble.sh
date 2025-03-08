#####2.3 remove unassemble genome###########################
rm chr[0-9XY]*_*_random.bam chrUn_*.bam
mkdir -p tmp/
mv chrY.bam UnMap.bam chrM.bam chrEBV.bam tmp/
