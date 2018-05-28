require(maftools)
library(dplyr)
# set wd as DataPreprocessing/
somatic = read.maf(maf = './data/somatic.maf.gz', removeDuplicatedVariants = FALSE, isTCGA = TRUE)
gene_patt = somatic@data[, c('Hugo_Symbol', 'Matched_Norm_Sample_Barcode')]
gene_patt %>% mutate_if(is.factor, as.character) -> gene_patt
genes = unique(gene_patt[, 1])
patients = unique(gene_patt[, 2])
gensize = length(genes)
patsize = length(patients)
recnum = dim(gene_patt)[1]

results = matrix('0', nrow = gensize, ncol = patsize)
for (i in 1 : gensize){
  for (j in 1 : 5){
    results[i, j] = 1
  }
}


rownames(results) = genes
colnames(results) = patients
results = as.table(results)


write.table(as.list(c("ID", patients)), "./results/MutexInput/data_test_Mutex.txt",sep="\t", col.names = FALSE, row.names=FALSE, quote = FALSE)
write.table(results, "./results/MutexInput/data_test_Mutex.txt", append = TRUE, sep="\t", col.names = FALSE, row.names=TRUE, quote = FALSE)



