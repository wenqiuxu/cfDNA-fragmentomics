for chr_name in {1..22}
do
cat split_chr/chr$chr_name/cfDNA_1_chr$chr_name.GRCh38_RNA.gini.txt|grep -v '^TSS_ID' >> /home/cfDNA_1/hospital1/cfDNA_features/CTRL/cfDNA_1/output/cfDNA_1.GRCh38_RNA.gini.txt
done
