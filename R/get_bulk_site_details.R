# WARNING - Generated by {fusen} from dev/OpenSpecimenAPI.Rmd: do not edit by hand

#' Get Bulk Site Details
#'
#' Use this function to retrieve details of multiple sites in bulk from the OpenSpecimen application.
#'
#' @param auth_response The authentication response object.
#' @param site_ids A vector of integers representing the IDs of the sites to retrieve details for.
#' @param ... Additional parameters to be passed to the underlying `get_os_site` function.
#'
#' @return A data table containing the details of the requested sites.
#'
#' @export
#' @examples
#' #get_bulk_site_details()
get_bulk_site_details <- function(auth_response, site_ids, ...) {
  
  # Check if site_ids is a vector of integers
  if (isTRUE(any(round(site_ids) != site_ids))) {
    stop("site_ids must be an integer")
  }
  
  # Use tryCatch to handle errors
  
  list_dfs <- vector("list", length(site_ids))
  
  for (i in seq_along(site_ids)) {
    
    list_dfs[[i]] <- tryCatch(
      get_os_site(auth_response, site_id = site_ids[i], ...),
      error = function(e) {
        cli::cli_alert_warning(paste0("Error in site id: ", site_ids[i], " ", e$message))
        return(NULL)
      }
    )
    
    if (i %% 10 == 0) {
      cli::cli_alert_success(
        paste0("Retrieved ", i, " sites",
               " out of ", length(site_ids))
      )
    }
  }
  
  ## Combine the list of data.tables into a single data.table
  dt_final = data.table::rbindlist(list_dfs, fill = TRUE)
  
  cli::cli_alert_success(paste0("Done: Site details retrieved"))
  
  return(dt_final)
  
}

