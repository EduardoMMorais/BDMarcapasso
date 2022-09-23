library(lightgbm)
library(workflows)

model <- lgb.load("./final_model.txt")
workflow <- readRDS("./final_model_wf.rds")
# saveRDS does not save the trained model correctly. We need to replace it with a model loaded correctly
workflow$fit$fit$fit <- model

calculateModel <- function(input) {
  #TODO
  10.0
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
        body = paste('{"readmission_30d":',calculateModel(),'}')
      )
    }
  )
)$new()
