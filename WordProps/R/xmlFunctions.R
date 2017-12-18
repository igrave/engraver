# testxml

# library(xml2)
# unzip()
# 
# 
# a <- xml2::read_xml("../custom.xml")
# xml2::as_xml_document(b)
# xml2::write_xml(a, file="../custom2.xml")
# 
# 
# str(a)
# node_template <- xml_child(a)
# str(node_template)
# xml2::xml_cdata(a=1)
# xml_add_child(a, fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}", pid="6", name="HEIGHT")
# 

#' Create new xml object root
#'
#' @return Create new xml object
#'
#' @examples
create_custom_xml_root <- function(){
  xml_new_root("Properties",
               xmlns = "http://schemas.openxmlformats.org/officeDocument/2006/custom-properties",
               "xmlns:vt" = "http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes")
}



# create_property_xml <- function(name, value, pid=xml_length(xml)+2, xml) read_xml(paste0(
#   '<property fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}" pid="',pid,'" name="', name,
#   '"><lpwstr>', value,'</lpwstr></property>'))



#' Add a new property to xml object
#'
#' @param xml object
#' @param name new property name
#' @param value value to assign
#' @param type type of property in c("lpwstr","bool","i4","filetime")
#'
#' @return Nothing
#'
add_new_property <- function(xml, name, value, type) {
  
  if(name %in% get_names(xml)) stop("Property exists with this name.")
  if(!is.character(name)) stop("name is not of type character!")
  
  if(missing(type)){
    if(is.numeric(value)) {
      type <- "i4" 
    } else if(is.logical(value)){
      type <- "bool"
    } else type <- "lpwstr"
  }
  
  type <- match.arg(type, choices=c("lpwstr","bool","i4","filetime"))
  # if(!is.character(value)) stop("value is not of type character")
  
  
  
  if(type=="bool") {
    value <- ifelse(as.logical(value),"true","false")
  }
  
  
  xml_add_child(xml, "property", 
                fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}",
                pid=xml_length(xml)+2,
                name=name)
  
  xml_add_child(xml_child(xml, xml_length(xml)),
                paste0("vt:",type), value)
}



#' Get the names of the document properties
#'
#' @param xml object
#'
#' @return A vectors of characters with the names of document properties
#'
get_names <- function(xml) {
  sapply(seq_len(xml_length(xml)), function(i) xml_attr(xml_child(xml,i),"name"))
}

#set the names of the document properties
#' Title
#'
#' @param xml object
#' @param names new names
#'
#' @return Nothing
#'
set_names <- function(xml, names) {
  sapply(seq_len(xml_length(xml)), function(i) xml_set_attr(xml_child(xml,i),"name",names[i]))
}



#' set pids correctly
#'
#' @param xml object
#'
#' @return Nothing
#'
set_pids <- function(xml) {
  sapply(seq_len(xml_length(xml)), function(i) xml_set_attr(xml_child(xml,i),"pid",as.character(i+1)))
}



#' Get the xml types of the document properties
#'
#' @param xml object
#'
#' @return  vector defined by factor(x, levels = c("i4", "lpwstr","filetime", "bool"), labels = c("numeric","character","date","logical") 
#' for types number, string, date and boolean.
#'
get_types <- function(xml) {
  a <- sapply(seq_len(xml_length(xml)), function(i) xml_name(xml_child(xml_child(xml,i))))
  factor(a, levels = c("i4", "lpwstr","filetime", "bool"), labels = c("numeric","character","date","logical"))
}



#' Get the values of the document properties
#'
#' @param xml xml object
#'
#' @return Vector of values of the document properties as characters
#'
get_values <- function(xml) {
  sapply(seq_len(xml_length(xml)), function(i) xml_text(xml_child(xml_child(xml,i))))
}

#
#' set the value of a document property
#'
#' @param xml xml object
#' @param name name of property to change
#' @param value new value
#'
#' @return Nothing
#'
set_value <- function(xml, name, value) {
  i <- match(name, get_names(xml))
  xml_set_text(xml_child(xml_child(xml,i)), value = as.character(value))
}





#' Convert Word custom xml object to an environment
#'
#' @param xml object to convert to environment
#'
#' @return a new environment
#'
xml_to_environment <- function(xml){
  e <- new.env()
  
  names <- get_names(xml)
  values <- get_values(xml)
  types <- get_types(xml)
  
  for(i in seq_along(names)){
    assign(x = names[i], 
           envir = e,
           value = switch(as.character(types[i]),
                          numeric   = as.numeric(values[i]),
                          character = values[i],
                          logical   = values[i]=="true",
                          date      = strptime(values[i], format = "%Y-%m-%d"))
    )
  }
  return(e)
}


#' environment to xml
#'
#' @param env An environment to convert to xml
#'
#' @return xml object for Word
#'
environment_to_xml <- function(env){
  items_xml <- 
    lapply(ls(env), function(i){
      property <- list()
      attr(property,"fmtid") <- "{D5CDD505-2E9C-101B-9397-08002B2CF9AE}"
      attr(property,"pid") <- "0"
      attr(property,"name") <- i
      
      #save logical
      if(is.logical(env[[i]])){
        property$bool <- ifelse(env[[i]],"true","false")
        
        #save numeric
      } else if(is.numeric(env[[i]])){
        property$i4 <- env[[i]]
        
        #save characters
      } else if(is.character(env[[i]])){
        property$lpwstr <- env[[i]]
        
      } else {
        property$lpwstr <- as.character(env[[i]])
      }
      
      property
    })
  
  attr(items_xml,"xmlns") <-  "http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
  attr(items_xml,"xmlns:vt") <- "http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
  
  doc <- as_xml_document(list(xml = items_xml))
  
}




