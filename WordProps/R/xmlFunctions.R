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

create_custom_xml_root <- function(){
  xml_new_root("Properties",
               xmlns = "http://schemas.openxmlformats.org/officeDocument/2006/custom-properties",
               "xmlns:vt" = "http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes")
}



# create_property_xml <- function(name, value, pid=xml_length(xml)+2, xml) read_xml(paste0(
#   '<property fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}" pid="',pid,'" name="', name,
#   '"><lpwstr>', value,'</lpwstr></property>'))



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



#Get the names of the document properties
get_names <- function(xml) {
  sapply(seq_len(xml_length(xml)), function(i) xml_attr(xml_child(xml,i),"name"))
}

#set the names of the document properties
set_names <- function(xml, values) {
  sapply(seq_len(xml_length(xml)), function(i) xml_set_attr(xml_child(xml,i),"name",values[i]))
}


#set pids correctly
set_pids <- function(xml) {
  sapply(seq_len(xml_length(xml)), function(i) xml_set_attr(xml_child(xml,i),"pid",as.character(i+1)))
}


#Get the types of the document properties
get_types <- function(xml) {
  a <- sapply(seq_len(xml_length(xml)), function(i) xml_name(xml_child(xml_child(xml,i))))
  factor(a, levels = c("i4", "lpwstr","filetime", "bool"), labels = c("numeric","character","date","logical"))
}



#Get the values of the document properties
get_values <- function(xml) {
  sapply(seq_len(xml_length(xml)), function(i) xml_text(xml_child(xml_child(xml,i))))
}


#xml to environment
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

# environment to xml
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
        property$lpwstr <- as.character(x[[i]])
      }
      
      property
    })
  
  attr(items_xml,"xmlns") <-  "http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
  attr(items_xml,"xmlns:vt") <- "http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
  
  doc <- as_xml_document(list(xml = items_xml))
  
}




