#!/usr/bin/Rscript --vanilla
library(yaml)

load('../dataset/processed_dictionary.RData') 
columns_list <- yaml.load_file("backend/column_list_readmission_30d.yaml")
output <- ""
for (column in columns_list) {
  dic_entry <- df_names[which(df_names['variable.name']==column),]
  if (grepl('\\|',dic_entry['options..definition'])) {
    cat(sprintf('<div class="mb-3"><label for="%s" class="form-label">%s</label><select class="form-select" name="%s" id="%s"><option selected></option>',dic_entry['variable.name'],dic_entry['field.label'],dic_entry['variable.name'],dic_entry['variable.name']), sep="")
    options <- unlist(strsplit(as.character(dic_entry['options..definition']), '|', fixed=TRUE))
    for (option in options) {
      pair <- unlist(strsplit(option, ',', fixed=TRUE))
      cat(sprintf('<option value="%s">%s</option>',trimws(pair[1]), trimws(pair[2])), sep='')
    }
    cat("</select></div>", sep="\n")
  } else {
    cat(sprintf('<div class="mb-3"><label for="%s" class="form-label">%s</label><input type="number" class="form-control" id="%s" name="%s" value="0"></div>',dic_entry['variable.name'],dic_entry['field.label'],dic_entry['variable.name'],dic_entry['variable.name']), sep="\n")
  }
}