require(maftools)
library(dplyr)
# set wd as DataPreprocessing/
somatic = read.maf(maf = './data/somatic.maf.gz', removeDuplicatedVariants = FALSE, isTCGA = TRUE)
gene_patt = somatic@data[, c('Hugo_Symbol', 'Matched_Norm_Sample_Barcode')]
gene_patt %>% mutate_if(is.factor, as.character) -> gene_patt
genes = unique(gene_patt[, 1])
patsize = length(unique(gene_patt[, 2]))
result = list()

## useful if patient info is not continuous
# for (i in 1:(dim(patt)[1])) {
#   nrow = c()
#   nrow = paste(nrow, patt[i], sep = ' ')
#   # nrow = c(nrow, patt[i])
#   print(patt[i])
#   for (j in 1:(dim(gene_patt)[1])){
#     if (gene_patt[j,2] == patt[i]){
#       nrow = paste(nrow, gene_patt[j,1], sep = ' ')
#       # nrow = c(nrow, gene_patt[j,1])
#     }
#   }
#   result[[i]] = nrow
# }

nrow = c()
cnt = 1
patnam = gene_patt[cnt,2]
nrow = paste(nrow, patnam, sep = '')
for (i in 1:(dim(gene_patt)[1])){
  if (gene_patt[i,2] == patnam){
    nrow = paste(nrow, gene_patt[i,1], sep = '\t')
  }
  else {
    result[[cnt]] = nrow
    nrow = c()
    cnt = cnt + 1
    if (cnt <= patsize ){
      patnam = gene_patt[i,2]
      nrow = paste(nrow, patnam, sep = '\n')
      nrow = paste(nrow, gene_patt[i,1], sep = '\t')      
    }
  }
}
result[[cnt]] = nrow

write.table(result,"./results/DentrixInput/data_Dentrix.txt",sep="", col.names = FALSE, row.names=FALSE, quote = FALSE)
write.table(genes, "./results/DentrixInput/analyzed_genes.txt",sep="\n", col.names = FALSE, row.names=FALSE, quote = FALSE)

