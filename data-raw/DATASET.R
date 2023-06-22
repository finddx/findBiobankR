## code to prepare `DATASET` dataset goes here
library(tidyverse)
library(data.table)

study <- "TB099"

# to convert all this code to 2 functions. one that simulates clinical data and a second that simulates specimen data
# the function will be under label generation
sites_codes <- paste0("0", 1:3)

sites_labels <- c("Peru",
                  "South Africa",
                  "Moldova")

ids <- paste0("000", 1:9)

specs_code <-  paste0("0", 1:3)

specs_labels <- c("Serum",
                  "Urine",
                  "Plasma")

aliquots <- paste0("00", 1:3)

aliquots_each <- rep(aliquots, each = length(specs_code))

tb_groups <- c( "TB, Pos",
                "TB, Neg")

hiv <- c("HIV-",
         "HIV+",
         "Unkown")

list_ids <- list()

n <- length(ids)

sites_codes_all <- rep(sites_codes, each = n)

nsites <- length(sites_codes_all)

ids2 <- rep(ids, times = length(sites_codes))

ids_final <- paste0(study, sites_codes_all, ids2)

aliquots_code_all <- rep(aliquots, each = length(specs_code))

specs_code_all <- rep(specs_code, times = length(aliquots))
specs_labels_m <-paste0(specs_code_all, aliquots_code_all)

specs_labels_m_all <- rep(specs_labels_m, each = length(ids_final))
ids_rep_specs <- rep(ids_final, times = length(specs_labels_m))

specimen_labels <- paste0(ids_rep_specs,"01", specs_labels_m_all) #01 is for baseline


tb_specimen_df <- data.table(specimen_label = specimen_labels)

clinical_df <- data.table(ppid = ids_final)



sex <- c("Female", "Male")

list_cols <- list(tb_group=tb_groups,
                  hiv_status=hiv,
                  sex = sex )

n_persons = nrow(clinical_df)
nms_list <- names(list_cols)
list_3 <- list()

for (i in 1:length(list_cols)) {
    nmi = nms_list[i]
    this_i = list_cols[[i]]
    n_len = length(this_i)
    this_is = sample(this_i, size = n_persons, replace = T)
    list_3[[i]] = this_is
}

names(list_3) <- nms_list

simulated_vars <- bind_cols(list_3)

tb_data <- bind_cols(clinical_df,
                     simulated_vars)  %>%
    setDT()


tb_data[, country := str_sub(ppid, 6, 7)]

tb_data[, country := factor(country,
                            levels = sites_codes,
                            labels = sites_labels)]



usethis::use_data(tb_data, overwrite = TRUE)

checkhelper::use_data_doc("tb_data")

tb_specimen_df[, ppid := str_extract(specimen_label, "^.{11}")]

tb_specimen_df <- tb_specimen_df[, .(ppid, specimen_label)]

tb_specimen_df[, specimen_type := str_sub(specimen_label, 14, 15) ]

tb_specimen_df[, visit_event := "Baseline"]

tb_specimen_df[, specimen_type := factor(specimen_type,
                                      levels = specs_code,
                                      labels = specs_labels)]


usethis::use_data(tb_specimen_df, overwrite = TRUE)

checkhelper::use_data_doc("tb_specimen_df")


tb_df <- merge(tb_data,
               tb_specimen_df,
               by = "ppid",
               all.x = T)

id_cols <- c("tb_group", "hiv_status", "sex", "country")



id_cols_df <- tb_df_clin[, (id_cols) := lapply(.SD, unique), by = ppid, .SDcols = id_cols]

idcols_all <- c("ppid",id_cols)

tb_df_clin <- tb_df[, ..idcols_all] |>
    unique(by = idcols_all)

