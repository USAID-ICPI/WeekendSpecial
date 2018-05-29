#' Map mechanism ids onto partner names
#'
#' @param df which df to map onto?
#'
#' @importFrom dplyr %>%
#' @export
#'
#' @examples
#' \dontrun{
#'   df_weekly <- wpm_addmechid(df_weekly_full)}

wpm_addmechid <- function(df){
  df <- df %>% 
  dplyr::mutate(mechanismid = dplyr::case_when(
    partner == "ANOVA"                  ~ "11111",
    partner == "BRHC"                   ~ "11111",
    partner == "FDP"                    ~ "11111",
    partner == "KI"                     ~ "11111",
    partner == "MatCH"                  ~ "11111",
    partner == "RTC"                    ~ "11111",
    partner == "WRHI"                   ~ "11111",
    partner == "Aurum Health Research"  ~ "18484",
    partner == "Health Systems Trust"   ~ "18481",
    partner == "TB/HIV Care"            ~ "18482")
  )
}
