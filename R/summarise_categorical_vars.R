# WARNING - Generated by {fusen} from dev/biobank_reports.Rmd: do not edit by hand

#' Summarise categorical variables 
#' 
#' Useful for for folks who work with a lot of data summaries. Produces a nice frequency table
#' 
#' @param  df data frame 
#' @param by_vec The group by columns/variable 
#' @param names_from_var dcast variable 
#' @param setordr_col column to order 
#' @param names_from_sort A vectors to sort columns created by pivot_wider
#' @param return_wide Logical vector whether to return a wide data.frame where names_from_var categories are column
#' @param add_totals_where where to add column sum totals check janitor::adorn_totals where argument
#' @importFrom janitor adorn_totals
#' @importFrom tidyr pivot_wider
#' @importFrom rlang sym
#' @return a data.frame 
#' 
#' @export
#' @examples
#' data("tb_data", package = "findBiobankR")
#' summarise_categorical_vars(df = tb_data,
#'                            by_vec = c("tb_group", "country"),
#'                            names_from_var ="country",
#'                            setordr_col = "tb_group",
#'                            names_from_sort =NULL ,
#'                            return_wide = TRUE,
#'                            add_totals_where = c("row", "col"))
summarise_categorical_vars <- function(df,
                                       by_vec,
                                       names_from_var =NULL,
                                       setordr_col = NULL,
                                       names_from_sort = NULL,
                                       return_wide = TRUE,
                                       add_totals_where = c("row", "col")){
  
  if(is.null(names_from_sort) & isTRUE(return_wide)){
    stopifnot("Please provide names_from_var argument to get a wide data frame as summary" =  !is.null(names_from_var) )
    names_from_sort <- df[, levels(factor(get(names_from_var)))] %>% 
      unique()
    
  }else if(return_wide){
    stopifnot("Check if names_from_var argument is not missing" = !is.null(names_from_var))
    unique_v <- df[, unique(get(names_from_var))]
    
    #stopifnot("length of vector names_from_sort are not of the same length with unique values in the names_from_var"= length(unique_v) == length(names_from_var))
    
  }
  
  tab_study_long <- df[, list(freq = .N), by = by_vec]
  
  if(!is.null(names_from_var) & isTRUE(return_wide)){
    
    tab_study <- tab_study_long %>%
      pivot_wider(names_from = !!sym(names_from_var), 
                  values_from = "freq", values_fill = 0)
    
    setDT(tab_study)
    nms2 = c(by_vec, names_from_sort)
    nms = names(tab_study)
    nms2 = nms2[!nms2 %in% names_from_var]
    tab_study = tab_study[, ..nms2]
    
    if(!is.null(setordr_col)){
      stopifnot("column to order rows should not be the column used to convert data frame to wide"= setordr_col != names_from_var )
      setorderv(tab_study, setordr_col)
    }
  }
  
  
  if(!is.null(add_totals_where)){
    
    where_cols = c("row", "col")
    invalid_cols <- add_totals_where[!add_totals_where %in% where_cols]
    
    if(length(invalid_cols) > 0){
      
      invalid_cols_nms = paste0(invalid_cols, collapse = " , ")
      
      msg = sprintf("The where argument of janitor::adorn_totals function  takes only either  elements of 'c('row', 'col')' or both. This ")
      
      stop(msg)
    }
    
    tab_study <- tab_study %>%
      janitor::adorn_totals(where = add_totals_where )
    
  }
  
  
  if (isTRUE(return_wide)) {
    
    stopifnot("Check if names_from_var argument is not missing" = exists("tab_study"))
    
    return_df = tab_study
    
  }else {
    
    return_df = tab_study_long
  }
  
  return_df
}

