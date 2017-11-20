getInputExperiments <- function(experiments){
  if ("All" %in% experiments | length(experiments)==0){
    exp = experiment_table
  }else{
    exp = experiment_table[experiment_table$description %in% experiments, ]
  }
  return(exp)
  
}

getConditionChoices <- function(experiments){
  exp = getInputExperiments(experiments)

  outList = list()
  for (i in (1: dim(exp)[1])){
    outList = c(outList, list(condition_table$name[condition_table$experiment_id==exp$id[i]]))
  }
  names(outList) = exp$description
  return(outList)
}

getInputConditions<- function(experiments, conditions){
  exp = getInputExperiments(experiments)
  conditions_all = condition_table[condition_table$experiment_id %in% exp$id,]

  if ("All" %in% conditions | length(conditions)==0){
    return(conditions_all$name)
  }else{
    choosen_condition_exp = unique(conditions_all$experiment_id[conditions_all$name %in% conditions])
    not_choosen_exp = exp$id[! exp$id %in% choosen_condition_exp]
    
    other_conditions = conditions_all$name[conditions_all$experiment_id==not_choosen_exp]
  
    return(c(conditions, other_conditions))
  }
  
  
  
}


getExpression <- function(genes, experiments, conditions){

  expression_table = data.frame(my_db2 %>% 
                                  tbl("gene_expression_tpm") %>%
                                  filter(sample_id %in% c(9:20)) %>%
                                  filter(ensembl_id %in% c(1:3)) %>% 
                                  left_join(my_db2 %>% tbl("sample"), by=c("sample_id"="id")))
          
  
  return(expression_table)
  
}

getString <- function(genes){
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "resolveList"
  
  my_genes = c("p53", "BRACA", "cdk2", "Q99835")
  
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes, 
                   "&", "species=", species
                   )
  print(request)
  
  get_string <- GET(request)
  out = content(get_string, "text")
  out <- as.data.frame(fromJSON(out, flatten=TRUE))
  
  return(out)
}

