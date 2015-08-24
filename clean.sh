#!/bin/bash
trap exit ERR
bibclean mfish.bib >  .clean.bib
bibtool -s -d .clean.bib > .tool.bib
mv mfish.bib .mfish.bak.bib
mv .tool.bib mfish.bib
rm .clean.bib

