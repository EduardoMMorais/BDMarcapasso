setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

rmarkdown::render('1-processing.Rmd',
                  output_file = './results/1-processing.pdf',
                  clean = TRUE)


rmarkdown::render('2-distribution_shift.Rmd',
                  output_file = './results/2-distribution_shift.pdf',
                  clean = TRUE)

columns_list <- yaml.load_file("./auxiliar/columns_list.yaml")

outcome_columns = setdiff(
  columns_list$outcome_columns,
  c(
    'death_intraop',
    'death_hospitalar',
    'death_readmission',
    'death'
  )
)

for (outcome_column in outcome_columns[1]) {
  dir.create(file.path(paste0('./results/', outcome_column)),
             showWarnings = FALSE)
  
  rmarkdown::render(
    '3-tables.Rmd',
    params = list(outcome_column = outcome_column),
    output_file = paste0('./results/', outcome_column, '/3-tables.pdf'),
    clean = TRUE
  )
  
  rmarkdown::render(
    '4-plots.Rmd',
    params = list(outcome_column = outcome_column),
    output_file = paste0('./results/', outcome_column, '/4-plots.pdf'),
    clean = TRUE
  )
  
  rmarkdown::render(
    '5-correlations.Rmd',
    params = list(outcome_column = outcome_column),
    output_file = paste0('./results/', outcome_column, '/5-correlations.pdf'),
    clean = TRUE
  )
  
  cat_features_list = readRDS(
    sprintf(
      "../EDA/auxiliar/significant_columns/categorical_%s.rds",
      outcome_column
    )
  )
  
  num_features_list = readRDS(
    sprintf(
      "../EDA/auxiliar/significant_columns/numerical_%s.rds",
      outcome_column
    )
  )
  
  features_list = c(cat_features_list, num_features_list)
  
  rmarkdown::render(
    '6-model_selection.Rmd',
    params = list(outcome_column = outcome_column,
                  features_list = features_list),
    output_file = paste0('./results/', outcome_column, '/6-model_selection.pdf'),
    clean = TRUE
  )
  
  rmarkdown::render(
    '8-final_model.Rmd',
    params = list(outcome_column = outcome_column,
                  features_list = features_list),
    output_file = paste0('./results/', outcome_column, '/8-final_model.pdf'),
    clean = TRUE
  )
}

rmarkdown::render('7-model_selection_results.Rmd',
                  output_file = './results/7-model_selection_results.pdf',
                  clean = TRUE)
