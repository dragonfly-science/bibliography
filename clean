#!/bin/bash
trap exit ERR
bibclean dragonfly.bib >  .clean.bib
bibtool -s -d .clean.bib > .tool.bib
mv dragonfly.bib .dragonfly.bak.bib
mv .tool.bib dragonfly.bib
rm .clean.bib

