load('reflist.rdata', verb=T)

options('useFancyQuotes'=F)

upper1st <- function(x) {
    x1 <- strsplit(x, '')
    x <- sapply(x1, function(x) {
                   x[1] <- toupper(x[1]) 
                   return(paste(x, collapse=''))
               })
    return(x)
}

items <- sapply(reflist, names)
reflist[!grepl('author', sapply(reflist, names))]

authors <- sapply(reflist, '[[', 'author')
allauthors <- unlist(authors)

## regexp expression to search for authors
dfly_authors <- list(chris   = 'C.*Knox',
                    edward  = 'E.*Abraham',
                    finlay  = 'F.*Thompson',
                    katrin  = 'K.*Berkenbusch',    
                    phil    = 'P.*Neubauer',
                    richard = 'R.*Mansfield',
                    yvan    = 'Y.*Richard'
                    )

## Various names for each author
dfly_authors_variants <- sapply(dfly_authors, function(a) {
                                   return( sort(table(grep(a, allauthors, ignore.case=T, val=T)),
                                                decreasing = T) )
                               }, simplify=F)
print(dfly_authors_variants)


## Get references for each author
v=dfly_authors_variants[[2]]
a=names(v)[1]
authors_refs <- sapply(dfly_authors_variants, function(v) {
           refs <- sapply(names(v), function(a) {
                             reflist[grep(a, authors)]
                         }, simplify=F, USE.NAMES=F)
           refs <- unlist(refs, recursive=F)
           ## Sort by decreasing years, and by title
           years <- as.numeric(sapply(refs, '[[', 'year'))
           titles <- gsub('^[^0-9a-zA-Z]+', '', gsub('[{}]+', '', sapply(refs, '[[', 'title')))
           refs <- refs[order(-years, titles)]
           return(refs)
       }, simplify=F)


## Output a bibtex file for each author
bibize <- function(r) {
    if ('author' %in% names(r[[1]]))
        r[[1]]$author <- paste(r[[1]]$author, collapse = ' and ')
    r1 <- r[[1]][names(r[[1]]) != 'class']
    return(sprintf('@%s{\t%s,\n%s\n}\n',
                   upper1st(r[[1]]$class), names(r),
                   paste( paste0('  ', names(r1), ' = ', dQuote(r1)), collapse = ',\n')))
}
i=2
bibrefs <- sapply(1:length(authors_refs), function(i) {
                     auth <- names(authors_refs)[i]
                     bib <- paste( sapply(1:length(authors_refs[[i]]), function(j) {
                                             bibize( authors_refs[[i]][j] )
                                         }, simplify=F), collapse = '\n')
                     cat(bib, file = sprintf('dragonfly-references_%s.bib', auth))
                     return(bib)
                 }, simplify=F)



## Output a bibtex file for all dragonfly-related references
dflyrefs <- reflist[unique(unlist(sapply(authors_refs, names)))]
years <- as.numeric(sapply(dflyrefs, '[[', 'year'))
titles <- gsub('^[^0-9a-zA-Z]+', '', gsub('[{}]+', '', sapply(dflyrefs, '[[', 'title')))
dflyrefs <- dflyrefs[order(-years, titles)]
dflybib <- sapply(1:length(dflyrefs), function(i) {
                     bibize(dflyrefs[i])
       }, simplify=T)
writeLines(dflybib, 'dragonfly-references.bib', sep = '\n')
