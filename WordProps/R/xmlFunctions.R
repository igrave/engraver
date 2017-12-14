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

create_xml <- function(name, value, pid=xml_length(xml)+2, xml) read_xml(paste0(
  '<property fmtid="{D5CDD505-2E9C-101B-9397-08002B2CF9AE}" pid="',pid,'" name="', name,
  '"><vt:lpwstr>', value,'</vt:lpwstr></property>'))



add_new_property <- function(name, value, xml) {
  if(name %in% get_names(xml)) stop("Property exists with this name.")
  if(!is.character(name)) stop("name is not of type character")
  if(!is.character(value)) stop("value is not of type character")
  xml_add_child(create_xml(name,value,xml=xml),xml)
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

# list to xml
list_to_xml <- function(list){
  
  #save logical
  
  #save numeric
  
  #save characters
  
  #convert the rest to character and save
  
}




