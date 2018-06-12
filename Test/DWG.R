
library(engraver)

#read the document with officer
mydoc <- officer::read_docx("Test/DWG AbstraktNU.docx")

myxmlroot <- engraver::create_custom_xml_root()
save_to_rdocx(mydoc, myxmlroot)
# load the docproperties from custom.xml 
myxml <- read_from_rdocx(mydoc)

#see what is already there
get_names(myxml)
get_values(myxml)

#update a value
set_value(myxml, "Age", 30)

#add a new property
add_new_property(myxml, name = "Street", value = "Dienerstrasse 51")

#check that it worked
get_names(myxml)
get_values(myxml)

#save it to the document
save_to_rdocx(mydoc, myxml)

#use officer to add a new paragraph
officer::body_add_par(mydoc, "I live at ")

#insert the variable into the text
slip_in_docprop_field("Street",myxml, mydoc)

#finish the sentence
officer::slip_in_text(mydoc, ".")

#save the document!
print(mydoc, target="Test/DWG.docx")


#Now open the document and update fields:
# select all then press F9
# 


#read the document with officer
mydoc <- officer::read_docx("Test/DWG.docx")
# load the docproperties from custom.xml 
myxml <- read_from_rdocx(mydoc)
