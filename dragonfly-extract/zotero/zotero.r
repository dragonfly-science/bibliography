source('../functions.r')

bib <- readLines('Dragonfly output.bib', warn=F)
reflist <- parse_bib(bib)

dflyrefs <- extract_dfly_refs(reflist)

for (i in 1:length(dflyrefs)) {
    fname <- sprintf('zotero-dragonfly-references_%s.bib', names(dflyrefs)[i])
    cat(fname, '\n')
    cat(dflyrefs[[i]], file = fname)
}

