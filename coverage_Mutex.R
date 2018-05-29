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

mutation = matrix(0L, nrow = gensize, ncol = patsize)
rownames(mutation) = genes
colnames(mutation) = patients
mutation = as.table(mutation)
for (i in 1:recnum){
  mutation[gene_patt[i,1], gene_patt[i,2]] = 1
}

interactive()
threshold = as.numeric(readline("coverage threshold: "))

con = file("./data/ranked-groups.txt", "r")
line = readLines(con, n = 1)
coverage = matrix(0L, nrow = 1, ncol = patsize)
visited = c()
count = 1
while (TRUE) {
  line = readLines(con, n = 1)
  ratio = sum(coverage) / length(coverage)
  if (length(line) == 0 || ratio >= threshold)
    break
  count = count + 1
  fields = strsplit(line, '\t')[[1]]
  
  for (i in 2:length(fields)){
    if (!(fields[i] %in% visited)){
      visited = c(vector, fields[i])
      coverage = 1 * (coverage | mutation[fields[i], ])
    }
  }
  
}
print(paste("the coverage is ", ratio))
print(paste("the last read line is ", count))
close(con)