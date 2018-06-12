


#' Read custom.xml from rdocx object 
#'
#' @param rdocx object
#'
#' @return xml object
read_from_rdocx <- function(rdocx){
  read_xml(x=file.path(rdocx$package_dir,"docProps","custom.xml"))
}