#' Map mechanism ids & agencies onto partner names
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
  
  #identify which partner work with which agencies
    cdc <- c("Aurum Health Research", "Health Systems Trust", "TB/HIV Care")
    usaid <- c("ANOVA", "BRHC", "FPD", "KI", "MatCH", "RTC", "Wits RHI")
  
  #add mechanism id and funding agency
  df <- df %>% 
    dplyr::mutate(mechanismid = dplyr::case_when(
                    partner == "ANOVA"                  ~ "17020",
                    partner == "BRHC"                   ~ "17023",
                    partner == "FPD"                    ~ "17036",
                    partner == "KI"                     ~ "17046",
                    partner == "MatCH"                  ~ "17038",
                    partner == "RTC"                    ~ "17021",
                    partner == "Wits RHI"               ~ "17037",
                    partner == "Aurum Health Research"  ~ "18484",
                    partner == "Health Systems Trust"   ~ "18481",
                    partner == "TB/HIV Care"            ~ "18482"
                  ),
                  fundingagency = dplyr::case_when(
                    partner %in% cdc ~ "CDC",
                    partner %in% usaid ~ "USAID"
                  )
                )
    
}
