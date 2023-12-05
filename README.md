
<!-- README.md is generated from README.Rmd. Please edit that file -->

# findBiobankR

<!-- badges: start -->

[![R-CMD-check](https://github.com/finddx/findBiobankR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/finddx/findBiobankR/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

findBiobankR package is a collection of functions used by FindDx Biobank

## Installation

You can install the development version of findBiobankR from
[GitHub](https://github.com/) with:

``` r

# install.packages("devtools")
devtools::install_github("finddx/findBiobankR")
```

## Convert Open Specimen Data to wide for Selection

- The function below is used to prepare clinical and specimen data sets
  for sample selections

``` r
library(findBiobankR)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(data.table)
#> 
#> Attaching package: 'data.table'
#> The following objects are masked from 'package:dplyr':
#> 
#>     between, first, last
library(knitr)

data("tb_data", package = "findBiobankR")
data("tb_specimen_df", package = "findBiobankR")

# required clinical cols
clinical_cols <- c("tb_group", "hiv_status", "sex", "country") 

clin_specs  <- convert_os_df_to_wide(clinical_df = tb_data,
                                     specimen_df = tb_specimen_df, 
                                     join_by_col = "ppid",
                                     specimen_col ="specimen_type" ,
                                     clinical_vars = clinical_cols ,
                                     specimen_label_col = "specimen_label",
                                     os_aliquot_names = c("Serum", "Plasma")
)

knitr::kable(clin_specs[1:5, ])
```

| ppid        | tb_group | hiv_status | sex    | country | NP_aliqN_serum | NP_labels_serum                                            | NP_aliqN_plasma | NP_labels_plasma                                           |
|:------------|:---------|:-----------|:-------|:--------|---------------:|:-----------------------------------------------------------|----------------:|:-----------------------------------------------------------|
| TB099010001 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 |
| TB099010002 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 |
| TB099010003 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 |
| TB099010004 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 |
| TB099010005 | TB, Neg  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 |

## Select Specimen

- Using the data set above select aliquot

``` r
##
samples_list <- list(c("TB0990100010101001", "TB0990100010101002", "TB0990100010101003"),
                     c("TB0990100020101001", "TB0990100020101002", "TB0990100020101003"), 
                     c("TB0990100030101001", "TB0990100030101002", "TB0990100030101003"),
                     c("TB0990100040101001", "TB0990100040101002", "TB0990100040101003"),
                     c("TB0990100050101001", "TB0990100050101002", "TB0990100050101003"
                     ))
# here aliquot number means index or position of the aliquot 
select_one_aliquot(samples_list,
                   aliquot_number = 1)
#> [1] "TB0990100010101001" "TB0990100020101001" "TB0990100030101001"
#> [4] "TB0990100040101001" "TB0990100050101001"

# You can use the data table method to already append this to the data set
clin_specs[, serum_aliquot_dt := select_one_aliquot(NP_labels_serum)]
# or tidyverse way
clin_specs <- clin_specs %>%
  mutate(serum_aliquot_dp = select_one_aliquot(NP_labels_serum))

knitr::kable(clin_specs[1:5, ])
```

| ppid        | tb_group | hiv_status | sex    | country | NP_aliqN_serum | NP_labels_serum                                            | NP_aliqN_plasma | NP_labels_plasma                                           | serum_aliquot_dt   | serum_aliquot_dp   |
|:------------|:---------|:-----------|:-------|:--------|---------------:|:-----------------------------------------------------------|----------------:|:-----------------------------------------------------------|:-------------------|:-------------------|
| TB099010001 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 | TB0990100010101001 | TB0990100010101001 |
| TB099010002 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 | TB0990100020101001 | TB0990100020101001 |
| TB099010003 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 | TB0990100030101001 | TB0990100030101001 |
| TB099010004 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 | TB0990100040101001 | TB0990100040101001 |
| TB099010005 | TB, Neg  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 | TB0990100050101001 | TB0990100050101001 |

## Select many aliquots at once

- Let’s say a requester wants 2 aliquots per patient. Using the above
  function it’s not convenient

``` r
##
clin_specs  <- convert_os_df_to_wide(clinical_df = tb_data,
                                     specimen_df = tb_specimen_df, 
                                     join_by_col = "ppid",
                                     specimen_col ="specimen_type" ,
                                     clinical_vars = clinical_cols ,
                                     specimen_label_col = "specimen_label",
                                     os_aliquot_names = c("Serum", "Plasma")
)
# here aliquots stands for number of samples per patient
# so this will select firts and second specimen for each participants
select_many_aliquots(samples_list,
                   aliquots = 2)
#> $aliquots1
#> [1] "TB0990100010101001" "TB0990100020101001" "TB0990100030101001"
#> [4] "TB0990100040101001" "TB0990100050101001"
#> 
#> $aliquots2
#> [1] "TB0990100010101002" "TB0990100020101002" "TB0990100030101002"
#> [4] "TB0990100040101002" "TB0990100050101002"

# You can use the data table method to already append this to the data set
col_nms <- paste0("aliquot", 1:2, "_dt")
clin_specs[, (col_nms ) := select_many_aliquots(NP_labels_serum, 
                                                aliquots = 2)]

knitr::kable(head(clin_specs, 5))
```

| ppid        | tb_group | hiv_status | sex    | country | NP_aliqN_serum | NP_labels_serum                                            | NP_aliqN_plasma | NP_labels_plasma                                           | aliquot1_dt        | aliquot2_dt        |
|:------------|:---------|:-----------|:-------|:--------|---------------:|:-----------------------------------------------------------|----------------:|:-----------------------------------------------------------|:-------------------|:-------------------|
| TB099010001 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 | TB0990100010101001 | TB0990100010101002 |
| TB099010002 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 | TB0990100020101001 | TB0990100020101002 |
| TB099010003 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 | TB0990100030101001 | TB0990100030101002 |
| TB099010004 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 | TB0990100040101001 | TB0990100040101002 |
| TB099010005 | TB, Neg  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 | TB0990100050101001 | TB0990100050101002 |

``` r
# unfortunately no easy for now tidyverse implementation but trying this below could work

df <- select_many_aliquots(clin_specs$NP_labels_serum, aliquots = 2) %>% 
  as.data.frame()
# You can then bind cols to the original data
knitr::kable(head(df, 2))
```

| aliquots1          | aliquots2          |
|:-------------------|:-------------------|
| TB0990100010101001 | TB0990100010101002 |
| TB0990100020101001 | TB0990100020101002 |

## Find if a patient has a positive/negative outcome based on several tests

- Find if a participant had any of respiratory symptoms

``` r
data("tb_resp_symptoms")

respirotory_symptoms <- c("COUGH", "EXPECTORATION",
                          "HEMOPTYSIS", "CHEST_PAIN",
                          "DYSPNOE")
kable(head(tb_resp_symptoms, 5))
```

| COUGH | EXPECTORATION | HEMOPTYSIS | CHEST_PAIN | DYSPNOE |  ID |
|:------|:--------------|:-----------|:-----------|:--------|----:|
| No    | Yes           | Yes        | No         | Yes     |   1 |
| Yes   | No            | Yes        | No         | No      |   2 |
| Yes   | Yes           | No         | Yes        | Yes     |   3 |
| Yes   | No            | Yes        | Yes        | No      |   4 |
| No    | No            | No         | Yes        | Yes     |   5 |

``` r
outcome_df  <- any_pos_any_neg(df = tb_resp_symptoms, 
                 test_cols =respirotory_symptoms ,
                 test_type = "resp_symp" ,
                # neg_value ="No",
                 pos_value = "Yes",
                 id_cols ="ID")
kable(head(outcome_df, 5))
```

|  ID | resp_symp_any_pos | resp_symp_pos_no |
|----:|:------------------|-----------------:|
|   1 | TRUE              |                3 |
|   2 | TRUE              |                2 |
|   3 | TRUE              |                4 |
|   4 | TRUE              |                3 |
|   5 | TRUE              |                2 |

## Select number of patients

- From `convert_os_df_to_wide` output select 1 patients tb neg and 2 tb
  pos

``` r
## select 2 patients per group 
patient_groups  <- c("TB, Neg", "TB, Pos")
number_per_group  <- c(1, 2)
sort_cols = "NP_aliqN_serum"
clin_specs_2 <- select_patients_per_group(df = clin_specs, 
                                          patient_group_col = "tb_group",
                                          patient_groups = patient_groups,
                                          number_per_group = number_per_group,
                                          sort_cols = sort_cols)
kable(clin_specs_2)
```

| ppid        | tb_group | hiv_status | sex    | country | NP_aliqN_serum | NP_labels_serum                                            | NP_aliqN_plasma | NP_labels_plasma                                           | aliquot1_dt        | aliquot2_dt        |
|:------------|:---------|:-----------|:-------|:--------|---------------:|:-----------------------------------------------------------|----------------:|:-----------------------------------------------------------|:-------------------|:-------------------|
| TB099010001 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 | TB0990100010101001 | TB0990100010101002 |
| TB099010002 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 | TB0990100020101001 | TB0990100020101002 |
| TB099010004 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 | TB0990100040101001 | TB0990100040101002 |

## Read multiple csv files

- Sometimes you have a folder with a couple of files you want to read

``` r
library(data.table)
iris_split <- split(iris, 
                    f = iris$Species)


path_name <- tempfile(pattern = "read_multipe_files")
#> Warning in normalizePath(path.expand(path), winslash, mustWork):
#> path[1]="C:\Users\MOSES~1.MBU\AppData\Local\Temp\RtmpAPcQpP\read_multipe_files15d0134c973":
#> The system cannot find the file specified

dir.create(path_name)


path_name <- normalizePath(path_name, winslash = "/")

file_names <- paste0(names(iris_split),  ".csv")
# create file name
file_paths <- file.path(path_name, file_names)
lapply(seq_along(file_paths), function(x){
    df = iris_split[[x]]
    fwrite(df, file = file_paths[x])
})
```

\[\[1\]\] NULL

\[\[2\]\] NULL

\[\[3\]\] NULL

``` r
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL

read_multiple_files(folder_path =path_name ,
                    read_function = "fread",
                    pattern = ".csv$",
                    file_names =NULL) %>% 
  lapply( function(x){
    
    kable(head(x, 5))
  })
```

\$setosa

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species |
|-------------:|------------:|-------------:|------------:|:--------|
|          5.1 |         3.5 |          1.4 |         0.2 | setosa  |
|          4.9 |         3.0 |          1.4 |         0.2 | setosa  |
|          4.7 |         3.2 |          1.3 |         0.2 | setosa  |
|          4.6 |         3.1 |          1.5 |         0.2 | setosa  |
|          5.0 |         3.6 |          1.4 |         0.2 | setosa  |

\$versicolor

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species    |
|-------------:|------------:|-------------:|------------:|:-----------|
|          7.0 |         3.2 |          4.7 |         1.4 | versicolor |
|          6.4 |         3.2 |          4.5 |         1.5 | versicolor |
|          6.9 |         3.1 |          4.9 |         1.5 | versicolor |
|          5.5 |         2.3 |          4.0 |         1.3 | versicolor |
|          6.5 |         2.8 |          4.6 |         1.5 | versicolor |

\$virginica

| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species   |
|-------------:|------------:|-------------:|------------:|:----------|
|          6.3 |         3.3 |          6.0 |         2.5 | virginica |
|          5.8 |         2.7 |          5.1 |         1.9 | virginica |
|          7.1 |         3.0 |          5.9 |         2.1 | virginica |
|          6.3 |         2.9 |          5.6 |         1.8 | virginica |
|          6.5 |         3.0 |          5.8 |         2.2 | virginica |

## Get OS Query

``` r
auth_response <- auth_os(url =  Sys.getenv("OSTESTURL"),
                         username = Sys.getenv("OSUSERNAME"),
                         password = Sys.getenv("OSPASSWORDTEST"))
#> ✔ Authentication successful

query114 <- get_os_query(auth_response, query_id = 114,
                         driving_form = "Participant",
                         wide_row_mode = "OFF",
                         start_at = 0,
                         max_results = 5)

kable(query114)
```

| specimen_label     | specimen_type         | specimen_requirement_name |
|:-------------------|:----------------------|:--------------------------|
| CV0010150000002    | Fluid - Not Specified | Oropharyngeal Swab        |
| CV0010150000002001 | Fluid - Not Specified | Oropharyngeal Swab        |
| CV0010150000002002 | Fluid - Not Specified | Oropharyngeal Swab        |
| CV0010150000002003 | Fluid - Not Specified | Oropharyngeal Swab        |
| CV0010150000002004 | Fluid - Not Specified | Oropharyngeal Swab        |

## Get OS Bulk Query

``` r

cv_samples <- get_bulk_query(auth_response, query_id = 105)
#> ✔ 5,000 rows retrieved
#> ✔ 10,000 rows retrieved
#> ✔ 15,000 rows retrieved
#> ✔ 18,897 rows retrieved
  

kable(cv_samples[1:5])
```

| participant_ppid | specimen_label     | specimen_type         | specimen_available_quantity | specimen_container_name | specimen_container_position |
|:-----------------|:-------------------|:----------------------|:----------------------------|:------------------------|:----------------------------|
| CV001015000      | CV0010150000002001 | Fluid - Not Specified | 0.18                        | UPC002.S01.R03.D01.B01  | 1                           |
| CV001015000      | CV0010150000002002 | Fluid - Not Specified | 0.18                        | UPC002.S01.R03.D01.B01  | 2                           |
| CV001015000      | CV0010150000002003 | Fluid - Not Specified | 0.18                        | UPC002.S01.R03.D01.B01  | 3                           |
| CV001015000      | CV0010150000002004 | Fluid - Not Specified | 0.18                        | UPC002.S01.R03.D01.B01  | 4                           |
| CV001015000      | CV0010150000002005 | Fluid - Not Specified | 0.18                        | UPC002.S01.R03.D01.B01  | 5                           |

## Get os Orders

``` r

orders <- get_bulk_orders(auth_response)
#> ✔ 36 rows retrieved
#> Warning in `[.data.table`(df, , `:=`((personal_info), NULL)): length(LHS)==0;
#> no columns to delete or assign RHS to.

kable(orders[1:5])
```

|  id | distribution_protocol_id | distribution_protocol_short_title | distribution_protocol_distributed_specimens_count | distribution_protocol_distributing_sites | requester_id | requester_cp_count | creation_date       | execution_date      | status   | specimen_cnt | site_id |
|----:|-------------------------:|:----------------------------------|--------------------------------------------------:|:-----------------------------------------|-------------:|-------------------:|:--------------------|:--------------------|:---------|-------------:|--------:|
|  58 |                       14 | Demo DP                           |                                                 0 | NULL                                     |          114 |                  0 | 2022-07-04 12:37:19 | 2022-07-04 12:36:55 | EXECUTED |            2 |      NA |
|  57 |                       14 | Demo DP                           |                                                 0 | NULL                                     |          114 |                  0 | 2022-07-04 12:26:14 | 2022-07-04 12:26:14 | EXECUTED |            4 |      NA |
|  56 |                       14 | Demo DP                           |                                                 0 | NULL                                     |          114 |                  0 | 2022-07-04 12:23:46 | 2022-07-04 12:21:05 | EXECUTED |            4 |      NA |
|  54 |                       14 | Demo DP                           |                                                 0 | NULL                                     |          114 |                  0 | 2021-10-12 08:29:25 | 2021-10-12 08:29:25 | EXECUTED |            2 |      NA |
|  52 |                       14 | Demo DP                           |                                                 0 | NULL                                     |          114 |                  0 | 2021-09-14 11:31:37 | 2021-09-14 11:30:57 | EXECUTED |            6 |      NA |

## Get Order Details

``` r
oder_details <- get_order_detail(auth_response, order_id = 52)

kable(oder_details)
```

| id  | distribution_protocol_id | distribution_protocol_title | distribution_protocol_short_title | principal_investigator_id | principal_investigator_type | principal_investigator_domain | principal_investigator_institute_id | principal_investigator_admin | principal_investigator_institute_admin | principal_investigator_manage_forms | principal_investigator_manage_wfs | principal_investigator_download_labels_print_file | principal_investigator_cp_count | principal_investigator_creation_date | principal_investigator_activity_status | distribution_protocol_start_date | distribution_protocol_distributed_specimens_count | distribution_protocol_activity_status | report_id | report_title                  | report_created_by_id | report_created_by_type | report_created_by_domain | report_created_by_admin | report_created_by_institute_admin | report_created_by_manage_forms | report_created_by_manage_wfs | report_created_by_download_labels_print_file | report_created_by_cp_count | report_created_by_activity_status | report_last_modified_by_id | report_last_modified_by_type | report_last_modified_by_domain | report_last_modified_by_admin | report_last_modified_by_institute_admin | report_last_modified_by_manage_forms | report_last_modified_by_manage_wfs | report_last_modified_by_download_labels_print_file | report_last_modified_by_cp_count | report_last_modified_by_activity_status | report_last_modified_on | requester_id | requester_type | requester_domain | requester_institute_id | requester_admin | requester_institute_admin | requester_manage_forms | requester_manage_wfs | requester_download_labels_print_file | requester_cp_count | requester_creation_date | requester_activity_status | creation_date       | execution_date      | status   | specimen_cnt | distributor_id | distributor_type | distributor_domain | distributor_institute_id | distributor_admin | distributor_institute_admin | distributor_manage_forms | distributor_manage_wfs | distributor_download_labels_print_file | distributor_cp_count | distributor_creation_date | distributor_activity_status | activity_status | async | completed | checkout | find_project_number | find_grant_code | distributing_site     |
|:----|:-------------------------|:----------------------------|:----------------------------------|:--------------------------|:----------------------------|:------------------------------|:------------------------------------|:-----------------------------|:---------------------------------------|:------------------------------------|:----------------------------------|:--------------------------------------------------|:--------------------------------|:-------------------------------------|:---------------------------------------|:---------------------------------|:--------------------------------------------------|:--------------------------------------|:----------|:------------------------------|:---------------------|:-----------------------|:-------------------------|:------------------------|:----------------------------------|:-------------------------------|:-----------------------------|:---------------------------------------------|:---------------------------|:----------------------------------|:---------------------------|:-----------------------------|:-------------------------------|:------------------------------|:----------------------------------------|:-------------------------------------|:-----------------------------------|:---------------------------------------------------|:---------------------------------|:----------------------------------------|:------------------------|:-------------|:---------------|:-----------------|:-----------------------|:----------------|:--------------------------|:-----------------------|:---------------------|:-------------------------------------|:-------------------|:------------------------|:--------------------------|:--------------------|:--------------------|:---------|:-------------|:---------------|:-----------------|:-------------------|:-------------------------|:------------------|:----------------------------|:-------------------------|:-----------------------|:---------------------------------------|:---------------------|:--------------------------|:----------------------------|:----------------|:------|:----------|:---------|:--------------------|:----------------|:----------------------|
| 52  | 14                       | Demo DP                     | Demo DP                           | 114                       | SUPER                       | openspecimen                  | 1                                   | TRUE                         | FALSE                                  | TRUE                                | TRUE                              | FALSE                                             | 0                               | 2021-08-19 22:00:00                  | Active                                 | 2021-08-23 22:00:00              | 0                                                 | Active                                | 18        | Distribution order data query | 1                    | SUPER                  | openspecimen             | TRUE                    | FALSE                             | FALSE                          | TRUE                         | FALSE                                        | 0                          | Locked                            | 1                          | SUPER                        | openspecimen                   | TRUE                          | FALSE                                   | FALSE                                | TRUE                               | FALSE                                              | 0                                | Locked                                  | 1632288342000           | 114          | SUPER          | openspecimen     | 1                      | TRUE            | FALSE                     | TRUE                   | TRUE                 | FALSE                                | 0                  | 2021-08-19 22:00:00     | Active                    | 2021-09-14 11:31:37 | 2021-09-14 11:30:57 | EXECUTED | 0            | 113            | SUPER            | openspecimen       | 1                        | TRUE              | FALSE                       | TRUE                     | TRUE                   | FALSE                                  | 0                    | 2021-06-13 22:00:00       | Active                      | Active          | FALSE | TRUE      | FALSE    | 4132131             | 54532           | FIND,ZeptoMetrix Inc. |

## Get bulk order details

``` r
oders_details <- get_bulk_order_detail(auth_response, orders_ids = orders$id )
#> ! Error in order_id: 58 Some duplicates exist in 'old': [extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.name, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.udn, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.caption, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.type, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.name, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.udn, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.caption, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.value, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.type, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.displayValue]
#> ! Error in order_id: 49 Some duplicates exist in 'old': [extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.name, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.udn, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.caption, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.type, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.name, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.udn, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.caption, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.value, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.type, extraAttrs.distInvoice.order.distributionProtocol.extensionDetail.attrs.displayValue]
#> ! Error in order_id: 8 Some duplicates exist in 'old': [distributionProtocol.coordinators.id, distributionProtocol.coordinators.type, distributionProtocol.coordinators.firstName, distributionProtocol.coordinators.lastName, distributionProtocol.coordinators.loginName, distributionProtocol.coordinators.domain, distributionProtocol.coordinators.emailAddress, distributionProtocol.coordinators.instituteId, distributionProtocol.coordinators.instituteName, distributionProtocol.coordinators.primarySite, ...]
#> ✔ All 36 orders retrieved

kable(oders_details[1:5])
```

| id  | distribution_protocol_id | distribution_protocol_title | distribution_protocol_short_title | principal_investigator_id | principal_investigator_type | principal_investigator_domain | principal_investigator_institute_id | principal_investigator_admin | principal_investigator_institute_admin | principal_investigator_manage_forms | principal_investigator_manage_wfs | principal_investigator_download_labels_print_file | principal_investigator_cp_count | principal_investigator_creation_date | principal_investigator_activity_status | distribution_protocol_start_date | distribution_protocol_distributed_specimens_count | distribution_protocol_activity_status | report_id | report_title                  | report_created_by_id | report_created_by_type | report_created_by_domain | report_created_by_admin | report_created_by_institute_admin | report_created_by_manage_forms | report_created_by_manage_wfs | report_created_by_download_labels_print_file | report_created_by_cp_count | report_created_by_activity_status | report_last_modified_by_id | report_last_modified_by_type | report_last_modified_by_domain | report_last_modified_by_admin | report_last_modified_by_institute_admin | report_last_modified_by_manage_forms | report_last_modified_by_manage_wfs | report_last_modified_by_download_labels_print_file | report_last_modified_by_cp_count | report_last_modified_by_activity_status | report_last_modified_on | requester_id | requester_type | requester_domain | requester_institute_id | requester_admin | requester_institute_admin | requester_manage_forms | requester_manage_wfs | requester_download_labels_print_file | requester_cp_count | requester_creation_date | requester_activity_status | creation_date       | execution_date      | status   | specimen_cnt | distributor_id | distributor_type | distributor_domain | distributor_institute_id | distributor_admin | distributor_institute_admin | distributor_manage_forms | distributor_manage_wfs | distributor_download_labels_print_file | distributor_cp_count | distributor_creation_date | distributor_activity_status | clear_list_id | activity_status | async | completed | checkout | find_project_number | find_grant_code | distributing_site     | site_id | comments                 | clear_list_mode | principal_investigator_primary_site | report_created_by_institute_id | report_created_by_creation_date | report_last_modified_by_institute_id | report_last_modified_by_creation_date | requester_primary_site | all_reserved_spmns | sbrc_approval_no_of_votes | distribution_protocol_order_extn_form_form_id | distribution_protocol_order_extn_form_caption | distribution_protocol_order_extn_form_created_by_id | distribution_protocol_order_extn_form_created_by_type | distribution_protocol_order_extn_form_created_by_domain | distribution_protocol_order_extn_form_created_by_institute_id | distribution_protocol_order_extn_form_created_by_admin | distribution_protocol_order_extn_form_created_by_institute_admin | distribution_protocol_order_extn_form_created_by_manage_forms | distribution_protocol_order_extn_form_created_by_manage_wfs | distribution_protocol_order_extn_form_created_by_download_labels_print_file | distribution_protocol_order_extn_form_created_by_cp_count | distribution_protocol_order_extn_form_created_by_activity_status | distribution_protocol_order_extn_form_creation_time | distribution_protocol_order_extn_form_modification_time | distribution_protocol_order_extn_form_sys_form | distribution_protocol_order_extn_form_multiple_records | distribution_protocol_order_extn_form_notif_enabled | distribution_protocol_order_extn_form_data_in_notif | extension_detail_id | extension_detail_object_id | extension_detail_form_id | extension_detail_form_caption | extension_detail_attrs_udn | extension_detail_attrs_caption | extension_detail_attrs_value | extension_detail_attrs_type | extension_detail_attrs_display_value | extension_detail_use_udn | distributor_primary_site | tracking_url | specimen_list_id | specimen_list_created_on | specimen_list_last_updated_on | specimen_list_owner_id | specimen_list_owner_type | specimen_list_owner_domain | specimen_list_owner_institute_id | specimen_list_owner_primary_site | specimen_list_owner_admin | specimen_list_owner_institute_admin | specimen_list_owner_manage_forms | specimen_list_owner_manage_wfs | specimen_list_owner_download_labels_print_file | specimen_list_owner_cp_count | specimen_list_owner_creation_date | specimen_list_owner_activity_status | specimen_list_default_list | specimen_list_specimen_count | specimen_list_description | distribution_protocol_end_date | distribution_protocol_coordinators_id | distribution_protocol_coordinators_type | distribution_protocol_coordinators_domain | distribution_protocol_coordinators_institute_id | distribution_protocol_coordinators_primary_site | distribution_protocol_coordinators_admin | distribution_protocol_coordinators_institute_admin | distribution_protocol_coordinators_manage_forms | distribution_protocol_coordinators_manage_wfs | distribution_protocol_coordinators_download_labels_print_file | distribution_protocol_coordinators_cp_count | distribution_protocol_coordinators_creation_date | distribution_protocol_coordinators_activity_status |
|:----|:-------------------------|:----------------------------|:----------------------------------|:--------------------------|:----------------------------|:------------------------------|:------------------------------------|:-----------------------------|:---------------------------------------|:------------------------------------|:----------------------------------|:--------------------------------------------------|:--------------------------------|:-------------------------------------|:---------------------------------------|:---------------------------------|:--------------------------------------------------|:--------------------------------------|:----------|:------------------------------|:---------------------|:-----------------------|:-------------------------|:------------------------|:----------------------------------|:-------------------------------|:-----------------------------|:---------------------------------------------|:---------------------------|:----------------------------------|:---------------------------|:-----------------------------|:-------------------------------|:------------------------------|:----------------------------------------|:-------------------------------------|:-----------------------------------|:---------------------------------------------------|:---------------------------------|:----------------------------------------|:------------------------|:-------------|:---------------|:-----------------|:-----------------------|:----------------|:--------------------------|:-----------------------|:---------------------|:-------------------------------------|:-------------------|:------------------------|:--------------------------|:--------------------|:--------------------|:---------|:-------------|:---------------|:-----------------|:-------------------|:-------------------------|:------------------|:----------------------------|:-------------------------|:-----------------------|:---------------------------------------|:---------------------|:--------------------------|:----------------------------|:--------------|:----------------|:------|:----------|:---------|:--------------------|:----------------|:----------------------|:--------|:-------------------------|:----------------|:------------------------------------|:-------------------------------|:--------------------------------|:-------------------------------------|:--------------------------------------|:-----------------------|:-------------------|:--------------------------|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------------|:------------------------------------------------------|:--------------------------------------------------------|:--------------------------------------------------------------|:-------------------------------------------------------|:-----------------------------------------------------------------|:--------------------------------------------------------------|:------------------------------------------------------------|:----------------------------------------------------------------------------|:----------------------------------------------------------|:-----------------------------------------------------------------|:----------------------------------------------------|:--------------------------------------------------------|:-----------------------------------------------|:-------------------------------------------------------|:----------------------------------------------------|:----------------------------------------------------|:--------------------|:---------------------------|:-------------------------|:------------------------------|:---------------------------|:-------------------------------|:-----------------------------|:----------------------------|:-------------------------------------|:-------------------------|:-------------------------|:-------------|:-----------------|:-------------------------|:------------------------------|:-----------------------|:-------------------------|:---------------------------|:---------------------------------|:---------------------------------|:--------------------------|:------------------------------------|:---------------------------------|:-------------------------------|:-----------------------------------------------|:-----------------------------|:----------------------------------|:------------------------------------|:---------------------------|:-----------------------------|:--------------------------|:-------------------------------|:--------------------------------------|:----------------------------------------|:------------------------------------------|:------------------------------------------------|:------------------------------------------------|:-----------------------------------------|:---------------------------------------------------|:------------------------------------------------|:----------------------------------------------|:--------------------------------------------------------------|:--------------------------------------------|:-------------------------------------------------|:---------------------------------------------------|
| 57  | 14                       | Demo DP                     | Demo DP                           | 114                       | SUPER                       | openspecimen                  | 1                                   | TRUE                         | FALSE                                  | TRUE                                | TRUE                              | FALSE                                             | 0                               | 2021-08-19 22:00:00                  | Active                                 | 2021-08-23 22:00:00              | 0                                                 | Active                                | 18        | Distribution order data query | 1                    | SUPER                  | openspecimen             | TRUE                    | FALSE                             | FALSE                          | TRUE                         | FALSE                                        | 0                          | Locked                            | 1                          | SUPER                        | openspecimen                   | TRUE                          | FALSE                                   | FALSE                                | TRUE                               | FALSE                                              | 0                                | Locked                                  | 1632288342000           | 114          | SUPER          | openspecimen     | 1                      | TRUE            | FALSE                     | TRUE                   | TRUE                 | FALSE                                | 0                  | 2021-08-19 22:00:00     | Active                    | 2022-07-04 12:26:14 | 2022-07-04 12:26:14 | EXECUTED | 0            | 113            | SUPER            | openspecimen       | 1                        | TRUE              | FALSE                       | TRUE                     | TRUE                   | FALSE                                  | 0                    | 2021-06-13 22:00:00       | Active                      | 44            | Active          | FALSE | TRUE      | FALSE    | 4132131             | 54532           | FIND,ZeptoMetrix Inc. | NA      | NA                       | NA              | NA                                  | NA                             | NA                              | NA                                   | NA                                    | NA                     | NA                 | NA                        | NA                                            | NA                                            | NA                                                  | NA                                                    | NA                                                      | NA                                                            | NA                                                     | NA                                                               | NA                                                            | NA                                                          | NA                                                                          | NA                                                        | NA                                                               | NA                                                  | NA                                                      | NA                                             | NA                                                     | NA                                                  | NA                                                  | NA                  | NA                         | NA                       | NA                            | NA                         | NA                             | NA                           | NA                          | NA                                   | NA                       | NA                       | NA           | NA               | NA                       | NA                            | NA                     | NA                       | NA                         | NA                               | NA                               | NA                        | NA                                  | NA                               | NA                             | NA                                             | NA                           | NA                                | NA                                  | NA                         | NA                           | NA                        | NA                             | NA                                    | NA                                      | NA                                        | NA                                              | NA                                              | NA                                       | NA                                                 | NA                                              | NA                                            | NA                                                            | NA                                          | NA                                               | NA                                                 |
| 56  | 14                       | Demo DP                     | Demo DP                           | 114                       | SUPER                       | openspecimen                  | 1                                   | TRUE                         | FALSE                                  | TRUE                                | TRUE                              | FALSE                                             | 0                               | 2021-08-19 22:00:00                  | Active                                 | 2021-08-23 22:00:00              | 0                                                 | Active                                | 18        | Distribution order data query | 1                    | SUPER                  | openspecimen             | TRUE                    | FALSE                             | FALSE                          | TRUE                         | FALSE                                        | 0                          | Locked                            | 1                          | SUPER                        | openspecimen                   | TRUE                          | FALSE                                   | FALSE                                | TRUE                               | FALSE                                              | 0                                | Locked                                  | 1632288342000           | 114          | SUPER          | openspecimen     | 1                      | TRUE            | FALSE                     | TRUE                   | TRUE                 | FALSE                                | 0                  | 2021-08-19 22:00:00     | Active                    | 2022-07-04 12:23:46 | 2022-07-04 12:21:05 | EXECUTED | 0            | 113            | SUPER            | openspecimen       | 1                        | TRUE              | FALSE                       | TRUE                     | TRUE                   | FALSE                                  | 0                    | 2021-06-13 22:00:00       | Active                      | 44            | Active          | FALSE | TRUE      | FALSE    | 4132131             | 54532           | FIND,ZeptoMetrix Inc. | NA      | NA                       | NA              | NA                                  | NA                             | NA                              | NA                                   | NA                                    | NA                     | NA                 | NA                        | NA                                            | NA                                            | NA                                                  | NA                                                    | NA                                                      | NA                                                            | NA                                                     | NA                                                               | NA                                                            | NA                                                          | NA                                                                          | NA                                                        | NA                                                               | NA                                                  | NA                                                      | NA                                             | NA                                                     | NA                                                  | NA                                                  | NA                  | NA                         | NA                       | NA                            | NA                         | NA                             | NA                           | NA                          | NA                                   | NA                       | NA                       | NA           | NA               | NA                       | NA                            | NA                     | NA                       | NA                         | NA                               | NA                               | NA                        | NA                                  | NA                               | NA                             | NA                                             | NA                           | NA                                | NA                                  | NA                         | NA                           | NA                        | NA                             | NA                                    | NA                                      | NA                                        | NA                                              | NA                                              | NA                                       | NA                                                 | NA                                              | NA                                            | NA                                                            | NA                                          | NA                                               | NA                                                 |
| 54  | 14                       | Demo DP                     | Demo DP                           | 114                       | SUPER                       | openspecimen                  | 1                                   | TRUE                         | FALSE                                  | TRUE                                | TRUE                              | FALSE                                             | 0                               | 2021-08-19 22:00:00                  | Active                                 | 2021-08-23 22:00:00              | 0                                                 | Active                                | 18        | Distribution order data query | 1                    | SUPER                  | openspecimen             | TRUE                    | FALSE                             | FALSE                          | TRUE                         | FALSE                                        | 0                          | Locked                            | 1                          | SUPER                        | openspecimen                   | TRUE                          | FALSE                                   | FALSE                                | TRUE                               | FALSE                                              | 0                                | Locked                                  | 1632288342000           | 114          | SUPER          | openspecimen     | 1                      | TRUE            | FALSE                     | TRUE                   | TRUE                 | FALSE                                | 0                  | 2021-08-19 22:00:00     | Active                    | 2021-10-12 08:29:25 | 2021-10-12 08:29:25 | EXECUTED | 0            | 113            | SUPER            | openspecimen       | 1                        | TRUE              | FALSE                       | TRUE                     | TRUE                   | FALSE                                  | 0                    | 2021-06-13 22:00:00       | Active                      | NA            | Active          | FALSE | TRUE      | FALSE    | 4132131             | 54532           | FIND,ZeptoMetrix Inc. | NA      | NA                       | NA              | NA                                  | NA                             | NA                              | NA                                   | NA                                    | NA                     | NA                 | NA                        | NA                                            | NA                                            | NA                                                  | NA                                                    | NA                                                      | NA                                                            | NA                                                     | NA                                                               | NA                                                            | NA                                                          | NA                                                                          | NA                                                        | NA                                                               | NA                                                  | NA                                                      | NA                                             | NA                                                     | NA                                                  | NA                                                  | NA                  | NA                         | NA                       | NA                            | NA                         | NA                             | NA                           | NA                          | NA                                   | NA                       | NA                       | NA           | NA               | NA                       | NA                            | NA                     | NA                       | NA                         | NA                               | NA                               | NA                        | NA                                  | NA                               | NA                             | NA                                             | NA                           | NA                                | NA                                  | NA                         | NA                           | NA                        | NA                             | NA                                    | NA                                      | NA                                        | NA                                              | NA                                              | NA                                       | NA                                                 | NA                                              | NA                                            | NA                                                            | NA                                          | NA                                               | NA                                                 |
| 52  | 14                       | Demo DP                     | Demo DP                           | 114                       | SUPER                       | openspecimen                  | 1                                   | TRUE                         | FALSE                                  | TRUE                                | TRUE                              | FALSE                                             | 0                               | 2021-08-19 22:00:00                  | Active                                 | 2021-08-23 22:00:00              | 0                                                 | Active                                | 18        | Distribution order data query | 1                    | SUPER                  | openspecimen             | TRUE                    | FALSE                             | FALSE                          | TRUE                         | FALSE                                        | 0                          | Locked                            | 1                          | SUPER                        | openspecimen                   | TRUE                          | FALSE                                   | FALSE                                | TRUE                               | FALSE                                              | 0                                | Locked                                  | 1632288342000           | 114          | SUPER          | openspecimen     | 1                      | TRUE            | FALSE                     | TRUE                   | TRUE                 | FALSE                                | 0                  | 2021-08-19 22:00:00     | Active                    | 2021-09-14 11:31:37 | 2021-09-14 11:30:57 | EXECUTED | 0            | 113            | SUPER            | openspecimen       | 1                        | TRUE              | FALSE                       | TRUE                     | TRUE                   | FALSE                                  | 0                    | 2021-06-13 22:00:00       | Active                      | NA            | Active          | FALSE | TRUE      | FALSE    | 4132131             | 54532           | FIND,ZeptoMetrix Inc. | NA      | NA                       | NA              | NA                                  | NA                             | NA                              | NA                                   | NA                                    | NA                     | NA                 | NA                        | NA                                            | NA                                            | NA                                                  | NA                                                    | NA                                                      | NA                                                            | NA                                                     | NA                                                               | NA                                                            | NA                                                          | NA                                                                          | NA                                                        | NA                                                               | NA                                                  | NA                                                      | NA                                             | NA                                                     | NA                                                  | NA                                                  | NA                  | NA                         | NA                       | NA                            | NA                         | NA                             | NA                           | NA                          | NA                                   | NA                       | NA                       | NA           | NA               | NA                       | NA                            | NA                     | NA                       | NA                         | NA                               | NA                               | NA                        | NA                                  | NA                               | NA                             | NA                                             | NA                           | NA                                | NA                                  | NA                         | NA                           | NA                        | NA                             | NA                                    | NA                                      | NA                                        | NA                                              | NA                                              | NA                                       | NA                                                 | NA                                              | NA                                            | NA                                                            | NA                                          | NA                                               | NA                                                 |
| 51  | 14                       | Demo DP                     | Demo DP                           | 114                       | SUPER                       | openspecimen                  | 1                                   | TRUE                         | FALSE                                  | TRUE                                | TRUE                              | FALSE                                             | 0                               | 2021-08-19 22:00:00                  | Active                                 | 2021-08-23 22:00:00              | 0                                                 | Active                                | 18        | Distribution order data query | 1                    | SUPER                  | openspecimen             | TRUE                    | FALSE                             | FALSE                          | TRUE                         | FALSE                                        | 0                          | Locked                            | 1                          | SUPER                        | openspecimen                   | TRUE                          | FALSE                                   | FALSE                                | TRUE                               | FALSE                                              | 0                                | Locked                                  | 1632288342000           | 114          | SUPER          | openspecimen     | 1                      | TRUE            | FALSE                     | TRUE                   | TRUE                 | FALSE                                | 0                  | 2021-08-19 22:00:00     | Active                    | 2021-08-25 11:57:00 | 2021-08-25 11:56:47 | EXECUTED | 0            | 113            | SUPER            | openspecimen       | 1                        | TRUE              | FALSE                       | TRUE                     | TRUE                   | FALSE                                  | 0                    | 2021-06-13 22:00:00       | Active                      | 43            | Active          | FALSE | TRUE      | FALSE    | 4132131             | 54532           | FIND,ZeptoMetrix Inc. | 127     | Plasma specimens request | NONE            | NA                                  | NA                             | NA                              | NA                                   | NA                                    | NA                     | NA                 | NA                        | NA                                            | NA                                            | NA                                                  | NA                                                    | NA                                                      | NA                                                            | NA                                                     | NA                                                               | NA                                                            | NA                                                          | NA                                                                          | NA                                                        | NA                                                               | NA                                                  | NA                                                      | NA                                             | NA                                                     | NA                                                  | NA                                                  | NA                  | NA                         | NA                       | NA                            | NA                         | NA                             | NA                           | NA                          | NA                                   | NA                       | NA                       | NA           | NA               | NA                       | NA                            | NA                     | NA                       | NA                         | NA                               | NA                               | NA                        | NA                                  | NA                               | NA                             | NA                                             | NA                           | NA                                | NA                                  | NA                         | NA                           | NA                        | NA                             | NA                                    | NA                                      | NA                                        | NA                                              | NA                                              | NA                                       | NA                                                 | NA                                              | NA                                            | NA                                                            | NA                                          | NA                                               | NA                                                 |

## Get Shipped/Distributed Samples

``` r
distributed_samples <- get_bulk_order_items(auth_response,
                                        orders_ids = orders$id )
#> ✔ Retrieved 10 orders out of 36
#> ! Error in order_id: 34 subscript out of bounds
#> ✔ Retrieved 20 orders out of 36
#> ! Error in order_id: 21 subscript out of bounds
#> ✔ Retrieved 30 orders out of 36
#> ✔ Done: orders retrieved

kable(distributed_samples[1:5])
```

| order_id | order_name                  | status                 | specimen_ppid | specimen_label     | specimen_event_label | specimen_cp_short_title | specimen_visit_date | specimen_type | specimen_availability_status |
|:---------|:----------------------------|:-----------------------|:--------------|:-------------------|:---------------------|:------------------------|:--------------------|:--------------|:-----------------------------|
| 58       | Demo DP_Jul 04, 2022 18:06  | DISTRIBUTED_AND_CLOSED | CH000010067   | CH0000100670006001 | Baseline             | CH000                   | 2019-10-22 09:53:09 | Plasma        | Available                    |
| 58       | Demo DP_Jul 04, 2022 18:06  | DISTRIBUTED_AND_CLOSED | CH000010067   | CH0000100670006002 | Baseline             | CH000                   | 2019-10-22 09:53:09 | Plasma        | Distributed                  |
| 57       | Demo DP_07-04-2022 17:56:12 | RETURNED               | CH000010025   | CH0000100250006001 | Baseline             | CH000                   | 2019-10-22 09:53:08 | Plasma        | Available                    |
| 57       | Demo DP_07-04-2022 17:56:12 | DISTRIBUTED_AND_CLOSED | CH000010025   | CH0000100250006002 | Baseline             | CH000                   | 2019-10-22 09:53:08 | Plasma        | Distributed                  |
| 57       | Demo DP_07-04-2022 17:56:12 | DISTRIBUTED_AND_CLOSED | CH000010025   | CH0000100250006003 | Baseline             | CH000                   | 2019-10-22 09:53:08 | Plasma        | Distributed                  |

## Get all Sites

``` r
sites <- get_all_sites(auth_response)
kable(sites[1:5])
```

|  id | name                    | instituteName                     | code | type            | activityStatus | cpCount |
|----:|:------------------------|:----------------------------------|:-----|:----------------|:---------------|--------:|
|  80 | AAMI                    | Australian Army Malaria Institute | 09   | Not Specified   | Active         |       0 |
| 132 | Access Bio Site 2       | Access Bio, Inc                   | NA   | Not Specified   | Active         |       0 |
| 130 | Access Bio, Inc         | Access Bio, Inc                   | NA   | Not Specified   | Active         |       0 |
| 131 | Alere Technologies GmbH | Alere Technologies GmbH           | NA   | Not Specified   | Active         |       0 |
| 124 | ARC                     | American Red Cross                | NA   | Collection Site | Active         |       0 |

## Get all Sites details

``` r

sites_details <- get_bulk_site_details(auth_response, 
                               site_ids = sites$id)
kable(sites_details[1:5])
```

|                       id | name                    | instituteName                     | code | type            | activityStatus | cpCount | address                                                                                            | country |
|-------------------------:|:------------------------|:----------------------------------|:-----|:----------------|:---------------|--------:|:---------------------------------------------------------------------------------------------------|:--------|
|                       80 | AAMI                    | Australian Army Malaria Institute | 09   | Not Specified   | Active         |       0 | Australian Army Malaria InstituteWeary Dunlop DriveGallipoli Barracks, Enoggera Qld Australia 4051 | NA      |
|                      132 | Access Bio Site 2       | Access Bio, Inc                   | NA   | Not Specified   | Active         |       0 | other dept, 65 Clude Rd Suite A,                                                                   |         |
| Somerset, NJ, 08873, USA | NA                      |                                   |      |                 |                |         |                                                                                                    |         |
|                      130 | Access Bio, Inc         | Access Bio, Inc                   | NA   | Not Specified   | Active         |       0 | 65 Clude Rd Suite A,                                                                               |         |
| Somerset, NJ, 08873, USA | NA                      |                                   |      |                 |                |         |                                                                                                    |         |
|                      131 | Alere Technologies GmbH | Alere Technologies GmbH           | NA   | Not Specified   | Active         |       0 | Loebstedter Str. 103-105, Jena, 07749, Germany                                                     | NA      |
|                      124 | ARC                     | American Red Cross                | NA   | Collection Site | Active         |       0 | NA                                                                                                 | NA      |
