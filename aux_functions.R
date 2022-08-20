library(kableExtra)

niceFormatting = function(df, caption="", digits = 2, font_size = NULL, label = 1){
  df %>%
    kbl(booktabs = T, longtable = T, caption = caption, digits = digits, format = "latex", label = label) %>%
    kable_styling(font_size = font_size,
                  latex_options = c("striped", "HOLD_position", "repeat_header"))
}

validation = function(model_fit, new_data, plot=TRUE) {
  test_predictions_prob <-
    predict(model_fit, new_data = new_data, type = "prob") %>%
    rename_at(vars(starts_with(".pred_")), ~ str_remove(., ".pred_")) %>%
    .$`1`
  
  pROC_obj <- roc(
    new_data[[outcome_column]],
    test_predictions_prob, 
    direction = "<",
    levels = c(0, 1),
    smoothed = TRUE,
    ci = TRUE,
    ci.alpha = 0.9,
    stratified = FALSE,
    plot = plot,
    auc.polygon = TRUE,
    max.auc.polygon = TRUE,
    grid = TRUE,
    print.auc = TRUE,
    show.thres = TRUE
  )
  
  proc_coords <- coords(
    pROC_obj,
    x = "best",
    best.method = "youden",
    ret = c(
      "threshold",
      "sensitivity",
      "specificity"
    )
  )
  
  test_predictions_prob <-
    predict(model_fit, new_data = new_data, type = "prob") %>%
    rename_at(vars(starts_with(".pred_")), ~ str_remove(., ".pred_")) %>%
    .$`1`
  
  test_predictions_class <- ifelse(test_predictions_prob > proc_coords$threshold, 
                                   1, 0)
  
  conf_matrix <- table(data = test_predictions_class,
                       reference = new_data[[outcome_column]])
  
  if (plot) {
    sens.ci <- ci.se(pROC_obj)
    plot(sens.ci, type = "shape", col = "lightblue", print.thres = "best")
    plot(sens.ci, type = "bars")
    
    print(sprintf("Optimal Threshold: %.2f", proc_coords$threshold))
    caret::confusionMatrix(conf_matrix) %>% print
  }
  
  return(pROC_obj)
}

extract_vip <- function(fit_tidymodels, pred_wrapper = predict,
                        reference_class = "0", nsim = 5, 
                        use_matrix = TRUE, method = "permute") {
  fit_parsnip <- fit_tidymodels %>%
    extract_fit_parsnip()
  
  # fit_parsnip %>%
  #   vip(geom = "point")
  
  trained_rec <- extract_recipe(fit_tidymodels)
  
  df_train_baked <- bake(trained_rec, new_data = df_train)
  df_train_baked[[outcome_column]] <- df_train_baked[[outcome_column]] %>% as.character() %>% as.numeric()
  matrix_train <- as.matrix(df_train_baked) 
  
  if (use_matrix) {
    data_train <- matrix_train
  } else {
    data_train <- df_train_baked
  }
  
  if (method == 'permute') {
    vip(fit_parsnip, train = data_train, method = method,
        target = outcome_column, metric = "auc", reference_class = reference_class,
        nsim = nsim, pred_wrapper = pred_wrapper, geom = "boxplot", all_permutations = TRUE,
        mapping = aes_string(fill = "Variable"),
        aesthetics = list(color = "grey35"))
  } else {
    vi_model(fit_parsnip) %>% vip
  }
}