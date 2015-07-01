source('functions.r')

load('reflist.rdata', verb=T)

dflyrefs <- extract_dfly_refs(reflist)

for (i in 1:length(dflyrefs)) {
    fname <- sprintf('dragonfly-references_%s.bib', names(dflyrefs)[i])
    cat(fname, '\n')
    cat(dflyrefs[[i]], file = fname)
}

