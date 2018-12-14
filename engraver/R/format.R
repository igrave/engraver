

#' engraveR format for rmarkdown
#'
#' @param ... options to pass through to rmarkdown's Word format
#' @param rda File to be load()ed, converted to xml and embedded in the docx.
#'
#' @return Writes the docx to disk
engraved_Docx <- function(rda,...){
  file <- rmarkdown::word_document(...)
  
  
  #open the document
  mydoc <- officer::read_docx(file)
  myenv <- new.env()
  load(file=rda, envir=myenv)
  myxml <- environment_to_xml(myenv)
  save_to_rdocx(rdocx=mydoc, xml=myxml)
  
  
  # officer:::print.rdocx(x=mydoc, target=file)
  print(x=mydoc, target=file)
  
}