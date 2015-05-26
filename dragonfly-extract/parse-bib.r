bib <- readLines('../mfish.bib')

## Remove empty lines
bib <- bib[!grepl('^[[:blank:]]*$', bib)]

## Remove un-necessary blanks
bib <- gsub('^[[:blank:]]+|[[:blank:]]+$', '', bib)
bib <- gsub('[[:blank:]]+=[[:blank:]]+', ' = ', bib)
bib <- gsub('\\{[[:blank:]]+', '{', bib)

writeLines(bib, 'tmp.bib')

## Get start and end positions of references
isrefstart <- grepl('^[[:blank:]]*@', bib)
refstarts <- which(isrefstart)
refends <- grep('^[[:blank:]]*\\}[[:blank:]]*$', bib)
if (length(refstarts) != length(refends))
    stop('Problem parsing start and end positions of references')


## Split
reflist0 <- sapply(1:length(refstarts), function(i) {
                      bib[refstarts[i]:refends[i]]
                  }, simplify=F)

## Get labels
labs <- gsub('^[[:blank:]]*@.*\\{[[:blank:]]*(.*),.*', '\\1', bib[refstarts])
if (length(labs) != length(reflist0))
    stop('Number of labels does not match length of reference list')
names(reflist0) <- labs

## Concatenate multi-line items
reflist1 <- sapply(reflist0, function(r) {
           conts <- which(!grepl('[^\\]=', r))
           conts <- setdiff(conts, c(1, length(r)))
           if (length(conts)) {
               for (i in rev(conts)) {
                   r[i-1] <- paste0(r[i-1], ' ', r[i])
               }
               r <- r[-conts]
           }
           return(r)
       }, simplify=F)
if (length(reflist0) != length(reflist1))
    stop('Problems occurred while contatenating multi-line items')

## Parse items
reflist <- sapply(reflist1, function(r) {
                      class <- list(class = tolower(sub('^@(.*)\\{.*', '\\1', r[1])))
                      itl <- strsplit(r[2:(length(r)-1)], '[[:blank:]]*=[[:blank:]]*')
                      its <- sapply(itl, '[', 2)
                      its <- gsub(',$', '', its)
                      c <- grepl('^[[:blank:]]*"', its) & grepl('"[[:blank:]]*$', its)
                      its[c] <- gsub('^[[:blank:]]*"|"[[:blank:]]*$', '', its[c])
                      its <- as.list(its)
                      names(its) <- sapply(itl, '[', 1)
                      return(c(class, its))
                  }, simplify=F)

## Split authors
reflist <- sapply(reflist, function(r) {
           if ('author' %in% names(r)) {
               r$author <- gsub(',$', '', unlist(strsplit(r$author, '[[:blank:]]+and[[:blank:]]+')))
           }
           return(r)
       }, simplify=F)

save(reflist, file = 'reflist.rdata')

cat('\n=== Unique items:\n')
print(data.frame(n = sort(table(unlist(sapply(reflist, names))), decreasing = T)))
