
#' saveProperties
#'
#' @param file A .docx file to save the data to
#' @param properties The list to save
#' @param sourcefile A file to copy from and overwrite with the properties (Optional)
#'
#' @return A .docx file with the custom properties.
#'
# saveProperties <- function(file, properties, sourcefile = file){
# 
#   tempfile()
# 
#   list(properites = 1)
# }


save_to_rdocx <- function(rdocx, xml){
  xml2::write_xml(xml, file=paste0(rdocx$package_dir,"\\docProps\\custom.xml"))
}