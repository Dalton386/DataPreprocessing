interactive()
filename = readline("matrix file: ")
conname = readline("ranked-groups file: ")

rawdata = read.table(paste0('./data/', filename), as.is = TRUE)
con = file(paste0("./data/", conname), "r")

rownum = dim(rawdata)[1]
colnum = dim(rawdata)[2]
mutation = as.matrix(rawdata[2:rownum,2:colnum])
mutation = apply(mutation,2, FUN = as.numeric)
rownames(mutation) = rawdata[2:rownum,1]
colnames(mutation) = rawdata[1,2:colnum]
mutation = as.table(mutation)

threshold = as.numeric(readline("coverage threshold: "))

line = readLines(con, n = 1)
coverage = matrix(0L, nrow = 1, ncol = colnum-1)
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