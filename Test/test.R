
library(officer)
library(xml2)

mydoc <- read_docx("Test/HelloIsaac.docx")

custom.xml <- xml2::read_xml(x=paste0(mydoc$package_dir,"\\docProps\\custom.xml"))


# write_xml(custom.xml, file="here.xml" )

