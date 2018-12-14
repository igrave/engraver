#' Initialise a document for use with engraver
#'
#' @param rdocx An rdocx created by Officer's read_docx
#'
#' @return Nothing returned. The .rels and Content_Types files are updated.
initialize_docx <- function(rdocx){
  
  #Adding to the _rels/.rels XML file ---------------------------------------------
  
  rels <- read_xml(x=file.path(rdocx$package_dir,"_rels",".rels"))
  
  # Do any of the children have custom.xml?
  if(!any(unlist(xml_attrs(xml_children(rels)))=="docProps/custom.xml")){
    Ids <- sapply(xml_attrs(xml_children(rels)),`[`,"Id")
    max_Id_num <- max(as.numeric(substr(sapply(xml_attrs(xml_children(rels)),`[`,"Id"), start = 4,stop=6)))
    next_id <- paste0('rId',max_Id_num+1)
    
    xml_add_child(rels,
                  .value="Relationship",
                  Id=next_id,
                  Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/custom-properties",
                  Target="docProps/custom.xml")
    
    
    write_xml(rels,
              file = file.path(rdocx$package_dir,"_rels",".rels"),
              options="")
    
  }
  
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
  
  # Is it already in the Content_Types xml?
  if(!any(unlist(xml_attrs(xml_children(read_xml(x=file.path(rdocx$package_dir,"[Content_Types].xml")))))
          == "/docProps/custom.xml")){
    rdocx$content_type$add_override(value = setNames("application/vnd.openxmlformats-officedocument.custom-properties+xml",
             "/docProps/custom.xml"))
    # rdocx$content_type$save()
  }

  
  rdocx
}
