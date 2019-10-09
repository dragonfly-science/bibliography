# Bibliography

This project contains Bibtex bibliographies that are used
by Dragonfly Science. The citations
are formatted so the they work with Ministry of Primary Industries
styles, especially Aquatic Environment and Biodiversity Reports.


## Cleaning

On ubuntu, you can run `./clean.sh` to tidy up the bibliography, and
make sure that all the citations are formatted correctly. This 
script depends on the `bibtool` and `bibclean` packages.

## Adding as a sub-module

Within the project repository:

`git submodule add git@github.com:dragonfly-science/bibliography.git`

`git submodule init`

`git submodule add`

`git submodule update`

`git checkout master`


Verify that the sub-module was initiated properly:

  - switch to `bibliography`
  - `git remote show origin`
  
