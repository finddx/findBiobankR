# WARNING - Generated by {fusen} from dev/biobank_reports.Rmd: do not edit by hand

# Test if the function throws an error when the file doesn't exist
test_that("Error is thrown when file doesn't exist", {
    expect_error(read_multiple_sheets("non_existent_file.xlsx"), 
                 "The file provided doesn't exists, Check path")
})

# Test if the function throws an error when the file extension is not xlsx

test_that("Error is thrown when file extension is not xlsx", {
    
    iris_df_path <- system.file("extdata", "iris.csv",
                           package = "findBiobankR")
    
    expect_error(read_multiple_sheets(iris_df_path), 
                 "The extension of the file is not an excel file")
    
    
})


# Test if the function returns a list of data frames when a valid xlsx file is provided and 
test_that("Returns a list of data frames for a valid xlsx file", {
    iris_species <- system.file("extdata", "iris_species.xlsx",
                          package = "findBiobankR")

    iris_list <- read_multiple_sheets(file_path  = iris_species )
    
  
    expect_true(is.list(iris_list))
    expect_true(all(sapply(iris_list, is.data.frame)))
    
    expect_equal(names(iris_list),c("setosa", "versicolor", "virginica"))
})




