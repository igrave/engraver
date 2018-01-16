

#' engraveR format for rmarkdown
#'
#' @param ... options to pass through to rmarkdown's Word format
#'
#' @return 
engraved_Docx <- function(rda,...){
  file <- rmarkdown::word_document(...)
  
  
  #open the document
  mydoc <- officer::read_docx(file)
  myenv <- new.env()
  load(file=rda, envir=myenv)
  myxml <- environment_to_xml(myenv)
  save_to_rdocx(docx =  mydoc,xml = myxml)
  
  
  officer::print(x=mydoc, target=file)
  
}