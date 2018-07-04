

#' Initialise a document for use with engraver
#'
#' @param rdocx 
#'
#' @return Nothing returned. The .rels and Content_Types files are updated.
initialize_docx <- function(rdocx){
  
  #add to the rels file
  rels <- read_xml(x=file.path(rdocx$package_dir,"_rels",".rels"))
  xml_add_child(rels,
                .value="Relationship",
                Id="rId4",
                Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/custom-properties",
                Target="docProps/custom.xml")
  
  
  write_xml(rels,
            file = file.path(rdocx$package_dir,"_rels",".rels"),
            options="")

  # #add to the contents file  
  # content <- read_xml(x=file.path(rdocx$package_dir,"[Content_Types].xml"))
  # 
  # xml_add_child(content,
  #               .value="Override",
  #               PartName="/docProps/custom.xml",
  #               ContentType="application/vnd.openxmlformats-officedocument.custom-properties+xml")
  # 
  # write_xml(content,
  #           file = file.path(rdocx$package_dir,"[Content_Types].xml"),
  #           options="")
  
  mydoc$content_type$add_override(
    setNames("application/vnd.openxmlformats-officedocument.custom-properties+xml",
             "/docProps/custom.xml"))
  
  
  
}


