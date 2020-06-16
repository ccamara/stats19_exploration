#' Download data from Google Sheets
#'
#' @description Downloads data from data.gov.uk and stores it in a csv file
#'   within \code{data/raw} folder.
#' @param url A string that identifies the Spread Sheet to be downloaded. It can
#'   be either its url or its id.
#' @param filename A string that will be used to name the outputed filename
#'   (without extension).
#' @return A CSV file with data, named \code{filename} and stored in
#'   \code{data/raw} folder.
#' @examples
#'
rsd_getdata <- function(url, filename = "local.data") {
  df = read.csv(url)

  write.csv(df, file = paste0("data/raw/", filename, ".csv"))

  return(df)

}