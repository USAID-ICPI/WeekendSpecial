#' Remove old files and replace with new
#'
#' @param filepath_zipped what is the full filepath to the zipped file?
#' @param folderpath_reports what folder are all the partner reports stored in?
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  wpm_fileupdate("~/Downloads/drive-download-20180502T170410Z-001.zip", "~/Week_23/reports")}

wpm_filerefresh <- function(filepath_zipped, folderpath_reports){
  
  #unzip Google Sheets to reports folder
   unzip(filepath_zipped, exdir = folderpath_reports, overwrite = TRUE)
  #remove zipped file
   fs::file_delete(filepath_zipped)
}