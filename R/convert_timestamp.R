# WARNING - Generated by {fusen} from dev/OpenSpecimenAPI.Rmd: do not edit by hand

#' Convert Timestamp to Date
#'
#' This function can handle numeric or character inputs to convert timestamps to date time objects, 
#' and can also process specified timestamp columns in a data frame.
#' @param x The numeric timestamp, character timestamp string, or a data frame.
#' @param return_numeric (Optional) Return the converted date as numeric. Default is FALSE.
#' @return The converted date as a date time object or a data frame with converted columns.
#' @importFrom lubridate as_datetime
#' @importFrom data.table setDT
#' @export
#' @examples
#'
#' timestamps <- c("1625068800000", "1625068801000", "1625068802000")
#' converted_timestamps <- timestamp_to_date(timestamps)
#' converted_timestamps
#'
#' timestamps_numeric <- c(1625068800000, 1625068801000, 1625068802000)
#' converted_timestamps_numeric <- timestamp_to_date(timestamps_numeric)
#' converted_timestamps_numeric
#' timestamps_with_specials <- c("1625068800000", "2021-07-01 00:00:00", "1625068800/1000")
#' timestamps_with_specials <- c("1625068800000", "2021-07-01 00:00:00", "1625068800/1000")
#' timestamps_with_specials
#' # Example 2: Convert timestamp columns in a data frame
#' df <- data.table::data.table(id = c(1, 2, 3),
#'                  event_date_num = c(1637892323000, 1637892423000, 1637892523000),
#'                  event_date_char = c("1637892323000", "1637892423000", "1637892523000")
#'                  )
#'
#'
#' df = timestamp_to_date(df, return_numeric = FALSE)
#'
#' df
#'
#'
#' date_time_strings <-c("2017-03-22 12:34:56", "2017.03.22 12:34", "2017/03/22 12", 
#'                       "2017-03-22", "22.03.2017 12:34:56", "22/03/2017 12:34", "22-03-2017 12", 
#'                       "22.03.2017", "03/22/2017 12:34:56", "03-22-2017 12:34", "03.22.2017 12", 
#'                       "03/22/2017")
#'
#' timestamp_to_date(date_time_strings)
#'
#'

convert_timestamp <- function(x, return_numeric = FALSE) {
  if (!is.numeric(x)) {
    warning("Input must be numeric.")
    return(x)
  }
  
  # Convert if x is in milliseconds
  x <- data.table::fifelse(nchar(as.character(x)) > 10, x / 1000, x)
  
  if (return_numeric) {
    return(x)
  } else {
    return(lubridate::as_datetime(x))
  }
}

#' Convert Timestamp to Date
#' This function converts a timestamp to a date time object
#' @param timestamp The timestamp to convert.
#' @param date_cols (Optional) The columns in the data frame to convert.
#' @param ... Additional arguments to be passed to convert_timestamp function
#' @seealso \code{\link{convert_timestamp}}
#' @return The converted date as a date time object.
#' @export

timestamp_to_date <- function(timestamp,
                              date_cols = NULL,
                                ...) {
  
  UseMethod("timestamp_to_date")
}


# Method for numeric class
#' Convert Timestamp to Date
#' This function converts a timestamp to a date time object
#' @param timestamp The timestamp to convert.
#' @param date_cols (Optional) The columns in the data frame to convert.
#' @param ... Additional arguments to be passed to the method.
#' @return The converted date as a date time object.
#' @export
timestamp_to_date.numeric <- function(timestamp,  
                                      date_cols = NULL, 
                                      ...) {
  
  return(convert_timestamp(timestamp, ...))
}

## return NA for logical columns

# Method for Logical class
#' Convert Timestamp to Date
#' This function converts a timestamp to a date time object
#' @param timestamp The timestamp to convert.
#' @param date_cols (Optional) The columns in the data frame to convert.
#' @param ... Additional arguments to be passed to the method.
#' @return The converted date as a date time object.
#' @export
timestamp_to_date.logical <- function(timestamp, date_cols = NULL, ...) {
  return(NA)
}

# Method for character class
#' Convert Timestamp to Date
#' This function converts a timestamp to a date time object
#' @param timestamp The timestamp to convert.
#' @param date_cols (Optional) The columns in the data frame to convert.
#' @param ... Additional arguments to be passed to the method.
#' @return The converted date as a date time object.
#' @export
timestamp_to_date.character <- function(timestamp,date_cols, ...) {
  
  has_special_characters <- function(input) {
    input <- input[!is.na(input)]
    # Includes dash, slash, period, space, and comma as special characters
    any(grepl("[-/\\. ,]", input))
  }
  
  is_all_digits <- function(input) {
    input <- input[!is.na(input)]
    all(grepl("^\\d+$", input))
  }
  
  if (!has_special_characters(timestamp)) {
    timestamp <- as.numeric(timestamp)
    return(convert_timestamp(timestamp, ...))
    
  }else if(!is_all_digits(timestamp)){
    
    # Define the vector of formats
    formats <- c("ymd_HMS", "ymd_HM", "ymd_H", "ymd",
                 "dmy_HMS", "dmy_HM", "dmy_H", "dmy",
                 "mdy_HMS", "mdy_HM", "mdy_H", "mdy")
    
    timestamp <- lubridate::parse_date_time(timestamp,  formats) %>%
      as.numeric()
    
    return(convert_timestamp(timestamp, ...))
    
    
    
  } else {  #(is.character(timestamp) & any(sapply(timestamp, has_special_characters)))
    
    warning("Input timestamp is not numeric or contains special characters. Skipping conversion.")
    
    return(timestamp)
  }
  
  
}


#' Convert Timestamp Columns in a Data Frame to Date
#'
#' This method converts timestamp columns in a data frame to date columns.
#'
#' @param timestamp Data frame with timestamp columns.
#' @param date_cols Names of the timestamp columns to convert.
#' @param ... (Optional) Return the converted date as numeric. Default is FALSE.
#'
#' @return A modified data frame with converted timestamp columns.
#'
#' @export
timestamp_to_date.data.frame <- function(timestamp, date_cols = NULL, ...){
  
  
  if(is.null(date_cols)){
    
    nms <- names(timestamp)
    
    date_cols <- nms[grepl("date", nms, ignore.case = TRUE)]
  }
  
  data.table::setDT(timestamp)
  
  leng <- length(date_cols)
  if(leng != 0){
    
    timestamp[, (date_cols) := lapply(.SD, timestamp_to_date, ...), .SDcols = date_cols]
    #df[, (date_cols) := lapply(.SD, timestamp_to_date.character, return_numeric), .SDcols = date_cols]
  }
  
  return(timestamp)

  
  
}

