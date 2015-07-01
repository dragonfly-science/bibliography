
upper1st <- function(x) {
    x1 <- strsplit(x, '')
    x <- sapply(x1, function(x) {
                   x[1] <- toupper(x[1]) 
                   return(paste(x, collapse=''))
               })
    return(x)
}


parse_bib <- function(bib, ignore.items = c('isbn', 'shorttitle', 'urldate', 'file', 'issn', 'keywords',
                                    'doi', 'month', 'language')) {
    
    ## Remove empty lines
    bib <- bib[!grepl('^[[:blank:]]*$', bib)]

    ## Remove un-necessary blanks
    bib <- gsub('^[[:blank:]]+|[[:blank:]]+$', '', bib)
    bib <- gsub('[[:blank:]]+=[[:blank:]]+', ' = ', bib)
    bib <- gsub('\\{[[:blank:]]+', '{', bib)

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
                         its <- its[!(names(its) %in% ignore.items)]
                         return(c(class, its))
                     }, simplify=F)

    ## Split authors
    reflist <- sapply(reflist, function(r) {
                         if ('author' %in% names(r)) {
                             r$author <- gsub('[\\{\\}]', '',
                                             gsub(',$', '',
                                                  unlist(strsplit(r$author, '[[:blank:]]+and[[:blank:]]+'))))
                         }
                         return(r)
                     }, simplify=F)

    return(reflist)

}


extract_dfly_refs <- function(reflist,
                      dfly_authors = list(chris   = 'C.*Knox|Knox, C.*',
                                          edward  = 'E.*Abraham|Abraham, E.*',
                                          finlay  = 'F.*Thompson|Thompson, F.*',
                                          katrin  = 'K.*Berkenbusch|Berkenbusch, K.*',    
                                          phil    = 'P.*Neubauer|Neubauer, P.*',
                                          richard = 'R.*Mansfield|Mansfield, R.*',
                                          yvan    = 'Y.*Richard|Richard, Y.*'
                                          )) {

    op <- options('useFancyQuotes')
    options('useFancyQuotes'=F)

    items <- sapply(reflist, names)
    reflist[!grepl('author', sapply(reflist, names))]

    authors <- sapply(reflist, '[[', 'author')
    allauthors <- gsub('[\\{\\}]', '', unlist(authors))

    ## Various names for each author
    dfly_authors_variants <- sapply(dfly_authors, function(a) {
                                       return( sort(table(grep(a, allauthors, ignore.case=T, val=T)),
                                                    decreasing = T) )
                                   }, simplify=F)
    print(dfly_authors_variants)


    ## Get references for each author
    v=dfly_authors_variants[[7]]
    a=names(v)[1]
    authors_refs <- sapply(dfly_authors_variants, function(v) {
                              refs <- sapply(names(v), function(a) {
                                                reflist[grep(gsub('\\.', '\\\\.', a), authors)]
                                            }, simplify=F, USE.NAMES=F)
                              refs <- unlist(refs, recursive=F)
                              ## Sort by decreasing years, and by title
                              years <- as.numeric(gsub('[\\{\\}]', '', sapply(refs, '[[', 'year')))
                              titles <- gsub('^[^0-9a-zA-Z]+', '', gsub('[{}]+', '', sapply(refs, '[[', 'title')))
                              refs <- refs[order(-years, titles)]
                              return(refs)
                          }, simplify=F)


    ## bibtex file for each author
    bibize <- function(r) {
        if ('author' %in% names(r[[1]]))
            r[[1]]$author <- paste(r[[1]]$author, collapse = ' and ')
        r1 <- r[[1]][names(r[[1]]) != 'class']
        return(sprintf('@%s{\t%s,\n%s\n}\n',
                       upper1st(r[[1]]$class), names(r),
                       paste( paste0('  ', names(r1), ' = ', dQuote(r1)), collapse = ',\n')))
    }
    i=1
    bibrefs <- sapply(1:length(authors_refs), function(i) {
                         auth <- names(authors_refs)[i]
                         bib <- paste( sapply(1:length(authors_refs[[i]]), function(j) {
                                                 bibize( authors_refs[[i]][j] )
                                             }, simplify=F), collapse = '\n')
                         ## cat(bib, file = sprintf('dragonfly-references_%s.bib', auth))
                         return(bib)
                     }, simplify=F)
    names(bibrefs) <- names(authors_refs)

    ## bibtex file for all dragonfly-related references
    dflyrefs <- reflist[unique(unlist(sapply(authors_refs, names)))]
    years <- as.numeric(gsub('[\\{\\}]', '', sapply(dflyrefs, '[[', 'year')))
    titles <- gsub('^[^0-9a-zA-Z]+', '', gsub('[{}]+', '', sapply(dflyrefs, '[[', 'title')))
    dflyrefs <- dflyrefs[order(-years, titles)]
    dflybib <- sapply(1:length(dflyrefs), function(i) {
                         bibize(dflyrefs[i])
                     }, simplify=T)
    dflybib <- paste( dflybib, collapse = '\n')

    bibrefs[['all']] <- dflybib
    options('useFancyQuotes'=op)

    return(bibrefs)
}
