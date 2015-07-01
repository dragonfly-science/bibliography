source('functions.r')

bib <- readLines('../mfish.bib')
reflist <- parse_bib(bib)

save(reflist, file = 'reflist.rdata')

cat('\n=== Unique items:\n')
print(data.frame(n = sort(table(unlist(sapply(reflist, names))), decreasing = T)))
