

dataframe_to_docprops <- function(df, name, useRowColNames=FALSE){
  n_i <- nrow(df)
  n_j <- ncol(df)
  
  if(!useRowColNames){
    row_i <- seq.int(n_i)
    col_j <- seq.int(n_j)
    mat <- outer(row_i, col_j, function(x,y) paste0(name, "[",x,",",y,"]"))
  } else {
    row_i <- paste0("'",rownames(df),"'")
    col_j <- paste0("'",colnames(df),"'")
    mat <- outer(row_i, col_j, function(x,y) paste0(name, "[",x,",",y,"]"))
  }  
  
mat
  
}
# a
# rownames(a) <- c('a','b','c')
# 
# dataframe_to_docprops(a, useRowColNames = TRUE, name="ddf")
# dataframe_to_docprops(a, useRowColNames = FALSE, name="ddf")

