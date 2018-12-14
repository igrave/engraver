

R_wml_table <- function(x,#DataFrame 
                        style_id,#std::string 
                        first_row = TRUE,#int 
                        last_row = FALSE,#int 
                        first_column = FALSE,#int 
                        last_column = FALSE,#int 
                        no_hband = FALSE,#int 
                        no_vband = FALSE,#int 
                        header = FALSE#int
) {
  nrow <- nrow(x)
  ncol <- ncol(x)
  
  os <- '<w:tbl xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" xmlns:wp=\"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" xmlns:w14=\"http://schemas.microsoft.com/office/word/2010/wordml\">'
  
  os <- paste0(os, '<w:tblPr>')
  os  <- paste0(os, '<w:tblStyle w:val=\"',style_id,'\"/>',
                '<w:tblLook w:firstRow=\"', as.numeric(first_row), 
                '\" w:lastRow=\"', as.numeric(last_row),
                '\" w:firstColumn=\"', as.numeric(first_column),
                '\" w:lastColumn=\"', as.numeric(last_column),
                '\" w:noHBand=\"', as.numeric(no_hband),
                '\" w:noVBand=\"', as.numeric(no_vband), '\"/>',
                '</w:tblPr>')
  
  if(header){
    os <- paste0(os, "<w:tr><w:trPr><w:tblHeader/></w:trPr>")
    names <- colnames(x)
    headernames <- paste0("<w:tc><w:trPr/><w:p><w:r><w:t>",
                          names,
                          "</w:t></w:r></w:p></w:tc>", collapse = "")
    os <- paste(os, headernames, "</w:tr>")
    
  }
  body <- paste("<w:tr>",
                apply(x, 1,
                      function(s) paste0("<w:tc><w:trPr/><w:p><w:r><w:t>",s,"</w:t></w:r></w:p></w:tc>", collapse="")),
                "</w:tr>", collapse = "")
  os <- paste0(os, body, "</w:tbl>")
  
  os
}
