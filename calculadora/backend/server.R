library(Rook)
# Esta aplicação não roda no RStudio. Veja https://github.com/jeffreyhorner/Rook/pull/31/files para detalhes
s <- Rhttpd$new()
s$add(
  app='./app.R',
  name='marcapasso'
)
s$start(listen='127.0.0.1', port='8081', quiet=FALSE)