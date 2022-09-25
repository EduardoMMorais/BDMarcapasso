library(lightgbm)
library(workflows)
library(yaml)

outcome_column <- "readmission_30d"

columns_list <- yaml.load_file("./column_list_readmission_30d.yaml")
lg_model <- lgb.load("./final_model.txt")
lg_workflow <- readRDS("./final_model_wf.rds")
# saveRDS does not save the trained model correctly. We need to replace it with a model loaded correctly
lg_workflow$fit$fit$fit <- lg_model

calculateModel <- function(env) {
  req <- Rook::Request$new(env)
  new_data <- data.frame(req$POST()[names(req$POST()) %in% c(columns_list,outcome_column)])
  
  lg_recipe<-extract_recipe(lg_workflow)
  types <- lg_recipe[["var_info"]][["type"]]
  names(types) <- lg_recipe[["var_info"]][["variable"]]
  for (column in names(new_data)) {
    if (types[column] == 'numeric') {
      new_data[column] <- as.double(new_data[column])
    }
  }

  predict(lg_workflow, new_data = new_data, type="prob")$.pred_1
}

app <- setRefClass(
  'HelloWorld',
  methods = list(
    call = function(env){
      list(
        status=200,
        headers = list(
          'Content-Type' = 'application/json',
          'Access-Control-Allow-Origin' = '*'
        ),
        body = paste('{"readmission_30d":',calculateModel(env),'}')
      )
    }
  )
)$new()
