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

nms_old_pos <- c("specimen_type", "specimen_requirement_name",
                 "specimen_label", "specimen_barcode", "specimen_container_name",
                 "specimen_container_position", "scanned_barcode")

nms_old_pos[!nms_old_pos %in% names(tb_specimen_df)]
tb_specimen_df[, specimen_requirement_name := specimen_type]
tb_specimen_df[, specimen_barcode := ""]
tb_specimen_df[, specimen_container_name := "ZMC100"]
tb_specimen_df[, specimen_container_position := as.integer(gl(.N, 81, .N))]
tb_specimen_df[, specimen_container_name := paste0(specimen_container_name, specimen_container_position)]


usethis::use_data(tb_specimen_df, overwrite = TRUE)

checkhelper::use_data_doc("tb_specimen_df")


tb_df <- merge(tb_data,
               tb_specimen_df,
               by = "ppid",
               all.x = T)

id_cols <- c("tb_group", "hiv_status", "sex", "country")



# id_cols_df <- tb_df_clin[, (id_cols) := lapply(.SD, unique), by = ppid, .SDcols = id_cols]
#
# idcols_all <- c("ppid",id_cols)
#
# tb_df_clin <- tb_df[, ..idcols_all] |>
#     unique(by = idcols_all)

variable_name <- c("tb_group",
                   "hiv_status",
                   "sex",
                   "country")

variable_description <- c("TB Group Negative, Positive",
                          "HIV staus, pos, Neg",
                          "Sex of participant",
                          "Country of participant")

tb_dictionary <- data.table(variable_name,variable_description )

usethis::use_data(tb_dictionary, overwrite = TRUE)
checkhelper::use_data_doc("tb_dictionary")


dir.create("inst/extdata")

data("iris")

write.csv(iris, file = "inst/extdata/iris.csv")

iris_split <- split(iris, f = iris$Species)
library(data.table)

create_save_workbook <- function(list_of_dfs, path_name, sheet_names ){

    library(openxlsx)

    wb <- createWorkbook()

    for ( i in seq_along(sheet_names)) {
        df = list_of_dfs[[i]]
        sheet_i = sheet_names[i]
        setDF(df)
        addWorksheet(wb, sheet_i)
        writeData(wb, sheet_i , df, startCol = 1)
    }
    saveWorkbook(wb, file = path_name)
}

file.remove("inst/extdata/iris_species.xlsx")
create_save_workbook(list_of_dfs =iris_split,
                     path_name = "inst/extdata/iris_species.xlsx",
                     sheet_names = names(iris_split))


respirotory_symptoms <- c("COUGH", "EXPECTORATION",
                          "HEMOPTYSIS", "CHEST_PAIN",
                          "DYSPNOE")

valresp <- c("Yes", "No")

list_colsresp <- lapply(seq_along(respirotory_symptoms), function(x){

    valresp

})
library(dplyr)
library(data.table)
simulate_df <- function(list_cols, n_persons = 5, nms_list = respirotory_symptoms){

    list_3 = vector(mode = "list",
                    length = length(list_cols))

    for (i in seq_along(list_cols)) {
        nmi = nms_list[i]
        this_i = list_cols[[i]]
        n_len = length(this_i)
        this_is = sample(this_i, size = n_persons, replace = T)
        list_3[[i]] = this_is
    }

    names(list_3) <- nms_list

    simulated_vars <- bind_cols(list_3) %>%
        setDT()


    simulated_vars
}

tb_resp_symptoms = simulate_df(list_colsresp)

tb_resp_symptoms[, ID:= 1:.N]


usethis::use_data(tb_resp_symptoms, overwrite = TRUE)

checkhelper::use_data_doc("tb_resp_symptoms")


nms_new_pos <- c("Participant_PPID", "Specimen_Type", "Specimen_Requirement Name",
                 "Specimen_Specimen Label", "Specimen_Barcode", "Specimen_Container Name",
                 "Specimen_Container Position", "Scanned_barcode")

nms_old_pos <- c("Participant_PPID", "specimen_type", "specimen_requirement_name",
                 "specimen_label", "specimen_barcode", "specimen_container_name",
                 "specimen_container_position", "scanned_barcode")

ids <- c(nms_old_pos, LETTERS[1:10])
all(nms_old_pos %in% ids)
