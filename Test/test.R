
library(WordProps)

#read the document with officer
mydoc <- officer::read_docx("Test/HelloIsaac.docx")

# load the docproperties from custom.xml 
myxml <- read_from_rdocx(mydoc)

#see what is already there
get_names(myxml)

#add a new property
add_new_property(myxml, name = "Street", value = "Dienerstrasse")

#check that it worked
get_names(myxml)

#save it to the document
save_to_rdocx(mydoc, myxml)

#use officer to add a sentence
officer::body_add_par(mydoc, "I live at ")

#insert the variable into the text
slip_in_docprop_field("Street",myxml, mydoc)

#save the document!
print(mydoc, target="Test/FirstTry.docx")
