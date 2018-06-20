cnv = read.table('./data/CNV_UCEC.txt', as.is = TRUE)
cnv[2:3] <- list(NULL)
cnv[1,] = strtrim(cnv[1,], 12)
cnvrow = dim(cnv)[1]
cnvcol = dim(cnv)[2]

snv = read.table('./data/SNV_UCEC.txt', as.is = TRUE)
snv[1,] = strtrim(snv[1,], 12)
snvrow = dim(snv)[1]
snvcol = dim(snv)[2]

patients = intersect(cnv[1, 2:cnvcol], snv[1, 2:snvcol])
genes = union(cnv[2:cnvrow, 1], snv[2:snvrow, 1])
gensize = length(genes)
patsize = length(patients)

results = matrix(0L, nrow = gensize, ncol = patsize)
rownames(results) = genes
colnames(results) = patients
results = as.table(results)

for (i in 2:cnvrow){
  for (j in 2:cnvcol){
    if (cnv[i,j] != 0 && cnv[1,j] %in% patients){
      
      results[cnv[i,1], cnv[1,j]] = 1
    }
  }
}

for (i in 2:snvrow){
  for (j in 2:snvcol){
    if (snv[i,j] != 0 && snv[1,j] %in% patients){
      
      results[snv[i,1], snv[1,j]] = 1
    }
  } 
}

write.table(as.list(c("ID", patients)), "./results/MutexInput/data_UCEC.txt",sep="\t", col.names = FALSE, row.names=FALSE, quote = FALSE)
write.table(results, "./results/MutexInput/data_UCEC.txt", append = TRUE, sep="\t", col.names = FALSE, row.names=TRUE, quote = FALSE)

