Bibliographies
==============

Bibliographies are stored in the bibtex files. At the moment there is a single mfish.bib
file that is used to hold all references used in mfish reports. The style of some
of the records has been hand-crafted so that  they work with the idiosyncratic 
Ministry of Fisheries style requirements. 

In the directory there is also a script clean.sh that normalises and sorts entries. It
also issues warnings when it finds missing fields or other errors.

Working with bibtex bibliographies
----------------------------------

1) checkout the bibliography files into your working directory
    cd ~/dragonfly
    git clone gitosis@code.dragonfly.co.nz:bibliography.git

2) When you start a project copy the mfish.bib file into your project
   directory and edit it as you wish. When you have made edits to the
   project files consider copying the changes back to the
   ~/dragonfly/bibliography/mfish.bib file
    
3) If you add edit the mfish.bib file, then when you have finished
   making the changes run
      ./clean.sh
    from the ~/dragonfly/bibliography directory. Once you have fixed any errors identified
    during the cleaning then commit your changes so they are available to other people.

Formating tips
---------------

* When adding references remove any extraneous fields (abstracts, issn numbers, etc.) that
don't appear in the references. 

* If importing from other sources make sure that you have removed any unicode characters

* Convert the keys to the standard format that we use. This is made from the first
author surname, the first significant word from the title, and the year in YYYY format, all
in lower case, with any apostrophes removed, and joined with underscores.

Example entries
---------------

Aquatic Environment and Biodiversity Report:

@Article{	  abraham_evaluating_2008,
  title		= "Evaluating methods for estimating the incidental capture
		  of {N}ew {Z}ealand sealions",
  journal	= "New Zealand Aquatic Environment and Biodiversity Report
		  No. 15",
  author	= "E. R. Abraham",
  year		= "2008",
  note		= "25~p"
}
   

Final research report:

@Unpublished{	  hartill_recreational_2006,
  title		= "Recreational marine harvest estimates of snapper and
		  kahawai in the {H}auraki {G}ulf in 2003--04",
  note		= "Final Research Report (Unpublished report held by Ministry
		  of Fisheries, Wellington)",
  author	= "B. Hartill and T. Watson and M. Cryer and H. Armiger",
  year		= "2006"
}

Unpublished report:


@Unpublished{	  abraham_summary_2007,
  title		= "Summary of data collected during the southern
		  squid-fishery mincing trial",
  author	= "E. R. Abraham",
  year		= "2007",
  note		= "Unpublished report prepared for the Department of
		  Conservation, Wellington, New Zealand. Available from
		  www.doc.govt.nz, http://tinyurl.com/abrsquidmince, January
		  2009"
}

Something with a URL:

@Unpublished{	  henningsen_eye_2005,
  title		= "{Eye to eye. A filmmaker's journey to discover the fate of
		  one of the world's rarest and most beautiful dolphins}",
  author	= "E. Henningsen",
  year		= "2005",
  url		= "http://www.ocean.com/film.asp?resourceid=3524\&catid=48\&locationid=3"
		  ,
  lastchecked	= "27 June 2007"
}

@Book{		  reeves_dolphins_2003,
  title		= "Dolphins, Whales, and Porpoises: 2002-2010 Conservation
		  Action Plan for the World's Cetaceans",
  author	= "R. R. Reeves",
  year		= "2003",
  publisher	= "IUCN",
  address	= "Gland, Switzerland"
}
