

initialize_docx <- function(rdocx){
  
  rels <- read_xml(x=file.path(rdocx$package_dir,"_rels",".rels"))
  
  content <- read_xml(x=file.path(rdocx$package_dir,"[Content_Types].xml"))
}


debug(initialize_docx)

initialize_docx(mydoc)

xml2::xml_add_child(rels,
                    .value="Relationship",
                    Id="rId4",
                    Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/custom-properties" Target="docProps/custom.xml")