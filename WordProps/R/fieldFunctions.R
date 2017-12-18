#' Insert property into Word document
#'
#' @param name Property name
#' @param xml xml object with corresponding property definition
#' @param doc rdocx object
#' @param options field format options. (Default "\\* MERGEFORMAT" to keep formatting)
#' @param ... Other parameters passed to officer::slip_in_seqfield()
#'
#' @return Nothing
slip_in_docprop_field <- function(name, xml, doc, options ="\\* MERGEFORMAT", ...){
  #look at slip in seqfield
  if(!missing(xml) & !(name %in% get_names(xml))) warning("Docproperty name not in xml")
  slip_in_seqfield(doc, str=paste("DOCPROPERTY", name, options), ...)
}
# 
# make_table_with_fields <- function(table){
#   #look at flextables word add to body
# }