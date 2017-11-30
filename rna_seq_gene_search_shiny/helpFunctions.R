getInputExperiments <- function(experiments){
  if ("All" %in% experiments | length(experiments)==0){
    exp = experiment_table
  }else{
    exp = experiment_table[experiment_table$description %in% experiments, ]
  }
  return(exp)
  
}


getConditionChoices <- function(exp){
  exp = getInputExperiments(exp)
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


getExpression2<-function(genes, experiments, conditions){
  if (genes[1] == ""){
    return(NULL)
  }
  my_db2 <- dbPool(
    RMySQL::MySQL(),
    dbname = "rna_seq2",
    host = host,
    username=username,
    password = password
  )
  
  gene_homo = lapply(genes, function(gene){
    mouse <- data.frame(my_db2 %>% tbl("human_mouse_homo") %>%
                          filter(gene_name == gene) %>%
                          select(c("mouse_gene_name")))$mouse_gene_name
    rat <- data.frame(my_db2 %>% tbl("human_rat_homo") %>% 
                        filter(gene_name == gene) %>%
                        select(c("rat_gene_name")))$rat_gene_name
    return(c(gene, mouse, rat))
  })
  
  genes = unlist(gene_homo)
  ensembl_ids = data.frame(my_db2 %>% tbl("ensembl") %>% 
                   filter(gene_name %in% genes) %>%
                   select(c("id", "gene_name")))

  expression_table =data.frame(my_db2 %>% tbl("expression_tpm_view") %>%
                                  filter(ensembl_id %in% ensembl_ids$id) %>%
                                  filter(experiment %in% experiments) %>% 
                                  filter(condition_name %in% conditions))
  
  expression_table = merge(expression_table, ensembl_ids, by.x="ensembl_id", by.y="id", all.x=T)

  poolClose(my_db2)
  return(expression_table)

}


getStringMap <- function(genes){
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "resolveList"
  
  my_genes = genes
  
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes, 
                   "&", "species=", species
  )
  
  get_string <- GET(request)
  out = content(get_string, "text")
  out <- as.data.frame(fromJSON(out, flatten=TRUE))
  out <- out[,c("preferredName", "taxonName","annotation")]
  colnames(out) <- c("Name", "Species", "Annotation")
  return(out)
}

getStringMap2 <- async(function(genes){
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "resolveList"
  
  my_genes = genes
  
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes, 
                   "&", "species=", species
  )
  
  get_string <- http_get(request)
  out <- get_string$then(function(response) {
    out = response$content
    out <- as.data.frame(fromJSON(rawToChar(out), flatten=TRUE))
    print(out)
    out
  })
  
  return(out)
  
  
})

getStringSVG <- function(genes, network_flavor, addInteractor1, 
                         addInteractor2,requried_score){
  
  string_api_url = "http://string-db.org/api"
  format = "svg"
  method = "network"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species,
                   "&", "network_flavor=", network_flavor,
                   "&", "required_score=", requried_score,
                   "&", "add_color_nodes=", addInteractor1,
                   "&", "add_white_nodes=", addInteractor2
  )
  
  svg <- getURL(request)
  
  return(svg)
  
}

getStringSVG2 <- function(genes, network_flavor, addInteractor1, 
                          addInteractor2,requried_score){
  
  string_api_url = "http://string-db.org/api"
  format = "svg"
  method = "network"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species,
                   "&", "network_flavor=", network_flavor,
                   "&", "required_score=", requried_score,
                   "&", "add_color_nodes=", addInteractor1,
                   "&", "add_white_nodes=", addInteractor2
  )
  
  svg <- http_get(request)
  svg <- svg$then(function(response) {
    out = response$content
    out <- rawToChar(out)
    out
  })
  
  return(svg)
  
}

getFunctionalEnrichment<-function(genes){
  
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "enrichment"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species
  )
  
  enrichments <- GET(request)
  out = content(enrichments, "text")
  out <- as.data.frame(fromJSON(out, flatten=TRUE))
  if (dim(out)[1]>1){
    out = out[,c("term", "description", "number_of_genes",
                 "inputGenes", "fdr", "category")]
    colnames(out) = c("pathwayID", "pathway description",
                      "count in gene set", "input genes", "false discovery rate", "category")
  }
  
  return(out)
}

getFunctionalEnrichment2<-function(genes){
  
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "enrichment"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species
  )
  
  
  enrichments <- http_get(request)
  out <- enrichments$then(function(response) {
    out = response$content
    out <- as.data.frame(fromJSON(rawToChar(out), flatten=TRUE))
    if (dim(out)[1]>1){
      out = out[,c("term", "description", "number_of_genes",
                   "inputGenes", "fdr", "category")]
      colnames(out) = c("pathwayID", "pathway description",
                        "count in gene set", "input genes", "false discovery rate", "category")
    }
    print(out)
    out
  })
  
  return(out)
}


getPpiEnrichment<-function(genes){
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "enrichment"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species
  )
  
  enrichments <- GET(request)
  out = content(enrichments, "text")
  out <- as.data.frame(fromJSON(out, flatten=TRUE))
  
  return(out)
  
}

getStrNetwork <- function(genes, score){
  add_nodes = 0
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "network"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species,
                   "&", "required_score=", score,
                   "&", "add_nodes=", add_nodes 
                   
  )
  
  enrichments <- GET(request)
  out = content(enrichments, "text")
  out <- as.data.frame(fromJSON(out, flatten=TRUE))
  
  return(out)
}

getStrNetwork2 <- function(genes, score){
  add_nodes = 0
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "network"
  
  my_genes = genes
  species = "9606"
  
  genes = paste(my_genes, collapse="%0D")
  request = paste0(string_api_url, "/",
                   format, "/",
                   method, "?",
                   "identifiers=", genes,
                   "&", "species=", species,
                   "&", "required_score=", score,
                   "&", "add_nodes=", add_nodes 
                   
  )
  
  
  enrichments <- http_get(request)
  out <- enrichments$then(function(response) {
    out = response$content
    out <- as.data.frame(fromJSON(rawToChar(out), flatten=TRUE))
    print(out)
    out
  })
  return(out)
}



