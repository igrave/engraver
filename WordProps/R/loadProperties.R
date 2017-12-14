
#' loadProperties
#'
#' @param file A .docx file to read the data from
#'
#' @return A list of nodes
#' @export
#'
loadProperties <- function(file){




  if (!is.null(path) && !file.exists(path))
    stop("could not find file ", shQuote(path), call. = FALSE)
  if (is.null(path))
    path <- system.file(package = "officer", "template/template.docx")
  package_dir <- tempfile()
  unpack_folder(file = path, folder = package_dir)



}
