calculateModel <- function(input) {
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
