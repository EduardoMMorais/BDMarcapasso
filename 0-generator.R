library(yaml)
library(progress)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# renv::activate()

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

SHUTDOWN <- FALSE
RUN_ALL <- FALSE

START <- 1
FINISH <- 1 #length(outcome_columns)

total <- 4 + 5 * (FINISH - START + 1) + 1
pb <- progress_bar$new(total = total)
pb$tick(0)
if (RUN_ALL) {
  rmarkdown::render(
    '1-processing.Rmd',
    output_file = './results/1-processing.pdf',
    clean = TRUE,
    quiet = TRUE
  )
  
  pb$tick()
  
  rmarkdown::render(
    '2-distribution_shift.Rmd',
    output_file = './results/2-distribution_shift.pdf',
    clean = TRUE,
    quiet = TRUE
  )
  
  pb$tick()
  
  dir.create(file.path(paste0('./results/', 'split')),
             showWarnings = FALSE)
  
  rmarkdown::render(
    '3-tables.Rmd',
    params = list(outcome_column = 'split'),
    output_file = paste0('./results/', 'split', '/3-tables.pdf'),
    clean = TRUE,
    quiet = TRUE
  )
  
  pb$tick()
  
  rmarkdown::render(
    '3-tables.Rmd',
    params = list(outcome_column = 'general'),
    output_file = './results/3-tables.pdf',
    clean = TRUE,
    quiet = TRUE
  )
  
  pb$tick()
} else {
  pb$tick()
  pb$tick()
  pb$tick()
  pb$tick()
}

for (outcome_column in outcome_columns[START:FINISH]) {
  cat(sprintf("\nRunning %s\n", outcome_column))
  dir.create(file.path(paste0('./results/', outcome_column)),
             showWarnings = FALSE)

  # rmarkdown::render(
  #   '3-tables.Rmd',
  #   params = list(outcome_column = outcome_column),
  #   output_file = paste0('./results/', outcome_column, '/3-tables.pdf'),
  #   clean = TRUE,
  #   quiet = TRUE
  # )

  pb$tick()

  # rmarkdown::render(
  #   '4-plots.Rmd',
  #   params = list(outcome_column = outcome_column),
  #   output_file = paste0('./results/', outcome_column, '/4-plots.pdf'),
  #   clean = TRUE,
  #   quiet = TRUE
  # )

  pb$tick()

  # rmarkdown::render(
  #   '5-correlations.Rmd',
  #   params = list(outcome_column = outcome_column),
  #   output_file = paste0('./results/', outcome_column, '/5-correlations.pdf'),
  #   clean = TRUE,
  #   quiet = TRUE
  # )
  
  pb$tick()
  
  rmarkdown::render(
    '6-model_selection.Rmd',
    params = list(outcome_column = outcome_column,
                  k = 10,
                  grid_size = 30,
                  repeats = 2,
                  RUN_ALL_MODELS = TRUE),
    output_file = paste0('./results/', outcome_column, '/6-model_selection.pdf'),
    clean = TRUE,
    quiet = TRUE
  )

  pb$tick()

  rmarkdown::render(
    '7-final_model.Rmd',
    params = list(outcome_column = outcome_column,
                  k = 10,
                  grid_size = 50,
                  repeats = 2),
    output_file = paste0('./results/', outcome_column, '/7-final_model.pdf'),
    clean = TRUE,
    quiet = TRUE
  )
  
  pb$tick()
}


rmarkdown::render(
  '8-modeling_results.Rmd',
  output_file = './results/8-modeling_results.pdf',
  clean = TRUE,
  quiet = TRUE
)

pb$tick()

if (SHUTDOWN) system('shutdown -s')
