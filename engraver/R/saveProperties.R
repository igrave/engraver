


#' Save xml object to rdocx object
#'
#' @param rdocx object
#' @param xml object
#'
#' @return nothing
save_to_rdocx <- function(rdocx, xml){
  write_xml(xml, file.path(rdocx$package_dir,"docProps","custom.xml"))
}