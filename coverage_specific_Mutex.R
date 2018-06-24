interactive()
filename = readline("matrix file: ")
conname = readline("ranked-groups file: ")

rawdata = read.table(paste0('./data/', filename), as.is = TRUE)

rownum = dim(rawdata)[1]
colnum = dim(rawdata)[2]
mutation = as.matrix(rawdata[2:rownum,2:colnum])
mutation = apply(mutation,2, FUN = as.numeric)
rownames(mutation) = rawdata[2:rownum,1]
colnames(mutation) = rawdata[1,2:colnum]
mutation = as.table(mutation)

linenum = as.numeric(readline("line number of pathway in ranked-groups file(>1): "))
while (linenum > 1){
  coverage = matrix(0L, nrow = 1, ncol = colnum-1)
  con = file(paste0("./data/", conname), "r")
  for (i in 1:linenum){
    line = readLines(con, n = 1)
  }
  print(paste("the line is: ", line))
  fields = strsplit(line, '\t')[[1]]
  
  for (i in 2:length(fields)){
    coverage = 1 * (coverage | mutation[fields[i], ])
  }
  ratio = sum(coverage) / length(coverage)
  
  print(paste("the coverage is ", ratio))
  
  linenum = as.numeric(readline("line number of pathway in ranked-groups file: "))
}
close(con)