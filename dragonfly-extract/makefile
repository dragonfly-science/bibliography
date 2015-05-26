all: dragonfly-references.bib

dragonfly-references.bib: reflist.rdata extract-dfly-references.r
	Rscript extract-dfly-references.r

reflist.rdata: ../mfish.bib parse-bib.r
	Rscript parse-bib.r
