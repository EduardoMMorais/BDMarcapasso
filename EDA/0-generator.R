setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

rmarkdown::render('1-processing.Rmd',
                  output_file = './results/1-processing.pdf',
                  clean=TRUE)

columns_list <- yaml.load_file("./auxiliar/columns_list.yaml")

outcome_columns = setdiff(columns_list$outcome_columns, 
                          c('death_intraop', 'death_hospitalar', 'death_readmission', 'death'))

for(outcome_column in outcome_columns){
  dir.create(file.path(paste0('./results/', outcome_column)),
             showWarnings = FALSE)

  rmarkdown::render('2-tables.Rmd',
                    params = list(outcome_column = outcome_column),
                    output_file = paste0('./results/', outcome_column, '/2-tables.pdf'),
                    clean=TRUE)

  rmarkdown::render('3-plots.Rmd',
                    params = list(outcome_column = outcome_column),
                    output_file = paste0('./results/', outcome_column, '/3-plots.pdf'),
                    clean=TRUE)

  rmarkdown::render('4-correlations.Rmd',
                    params = list(outcome_column = outcome_column),
                    output_file = paste0('./results/', outcome_column, '/4-correlations.pdf'),
                    clean=TRUE)
  
  
  rmarkdown::render('6-model.Rmd',
                    params = list(outcome_column = outcome_column),
                    output_file = paste0('./results/', outcome_column, '/6-model.pdf'),
                    clean=TRUE)
}

rmarkdown::render('5-distribution_shift.Rmd',
                  output_file = './results/5-distribution_shift.pdf',
                  clean=TRUE)

rmarkdown::render('7-final_results.Rmd',
                  output_file = './results/7-final_results.pdf',
                  clean=TRUE)