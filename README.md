
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
| TB099010001 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 |
| TB099010002 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 |
| TB099010003 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 |
| TB099010004 | TB, Neg  | HIV+       | Male   | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 |
| TB099010005 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 |

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
| TB099010001 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 | TB0990100010101001 | TB0990100010101001 |
| TB099010002 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 | TB0990100020101001 | TB0990100020101001 |
| TB099010003 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 | TB0990100030101001 | TB0990100030101001 |
| TB099010004 | TB, Neg  | HIV+       | Male   | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 | TB0990100040101001 | TB0990100040101001 |
| TB099010005 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 | TB0990100050101001 | TB0990100050101001 |

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
| TB099010001 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 | TB0990100010101001 | TB0990100010101002 |
| TB099010002 | TB, Neg  | HIV-       | Male   | Peru    |              3 | TB0990100020101001, TB0990100020101002, TB0990100020101003 |               3 | TB0990100020103001, TB0990100020103002, TB0990100020103003 | TB0990100020101001 | TB0990100020101002 |
| TB099010003 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 | TB0990100030101001 | TB0990100030101002 |
| TB099010004 | TB, Neg  | HIV+       | Male   | Peru    |              3 | TB0990100040101001, TB0990100040101002, TB0990100040101003 |               3 | TB0990100040103001, TB0990100040103002, TB0990100040103003 | TB0990100040101001 | TB0990100040101002 |
| TB099010005 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 | TB0990100050101001 | TB0990100050101002 |

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

## Find is a patient has a positive/negative outcome based on several tests

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
| No    | No            | No         | No         | No      |   1 |
| No    | No            | Yes        | No         | No      |   2 |
| Yes   | No            | No         | Yes        | No      |   3 |
| Yes   | No            | No         | Yes        | No      |   4 |
| No    | No            | Yes        | No         | No      |   5 |

``` r
outcome_df  <- any_pos_any_neg(df = tb_resp_symptoms, 
                 test_cols =respirotory_symptoms ,
                 test_type = "resp_symp" ,
                 neg_value ="No",
                 pos_value = "Yes",
                 id_cols ="ID")
kable(head(outcome_df, 5))
```

|  ID | resp_symp_any_neg | resp_symp_any_pos | resp_symp_pos_no | resp_symp_neg_no |
|----:|:------------------|:------------------|-----------------:|-----------------:|
|   1 | TRUE              | FALSE             |                0 |                5 |
|   2 | TRUE              | TRUE              |                1 |                4 |
|   3 | TRUE              | TRUE              |                2 |                3 |
|   4 | TRUE              | TRUE              |                2 |                3 |
|   5 | TRUE              | TRUE              |                1 |                4 |

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
| TB099010001 | TB, Neg  | Unkown     | Male   | Peru    |              3 | TB0990100010101001, TB0990100010101002, TB0990100010101003 |               3 | TB0990100010103001, TB0990100010103002, TB0990100010103003 | TB0990100010101001 | TB0990100010101002 |
| TB099010003 | TB, Pos  | HIV-       | Male   | Peru    |              3 | TB0990100030101001, TB0990100030101002, TB0990100030101003 |               3 | TB0990100030103001, TB0990100030103002, TB0990100030103003 | TB0990100030101001 | TB0990100030101002 |
| TB099010005 | TB, Pos  | HIV+       | Female | Peru    |              3 | TB0990100050101001, TB0990100050101002, TB0990100050101003 |               3 | TB0990100050103001, TB0990100050103002, TB0990100050103003 | TB0990100050101001 | TB0990100050101002 |
