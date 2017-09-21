##this is provide a function to connect to server and get experiment data##

library(pool)
library(dplyr)

#################
getConditionTable <- function(expId){
  
  condition_table = condition%>% filter(experiment_id == expId)
  return(condition_table)
}

################
getSampleTable <- function(expId, condition_table){
  sample_table = sample %>%
    filter(experiment_id == expId) %>%
    left_join(condition_table, by =c('condition_id' = 'id')) %>%
    left_join(tissue, by=c('tissue_id'='id')) %>%
    select(c('sample_name', 'name.x', 'name.y'))
  colnames(sample_table) <- c('sample_name', 'condition', 'tissue')
  
  return(sample_table)
}


################
getExpressionGeneTable <- function(condition_table, select_gene_condition, select_gene_gene,exp_id, ensembl_gene_table){
  
  #get condition ids 
  selected_conditions = condition_table %>% filter(name %in% select_gene_condition)

  #get sub sample table
  sample_sub =  sample %>% filter(experiment_id == exp_id) %>% filter(condition_id %in% selected_conditions$id)
  
  selected_genes = ensembl_gene_table %>% filter(gene_name %in% select_gene_gene)
  
  gene_expression_table =  gene_expression %>%
    filter(sample_id %in% sample_sub$id) %>%
    filter(ensembl_id %in% selected_genes$id)
  
  gene_expression_table = gene_expression_table %>%
    left_join(sample_sub, by= c("sample_id" = "id")) %>%
    left_join(selected_conditions, by=c("condition_id" = "id")) %>% 
    left_join(selected_genes, by=c('ensembl_id'='id')) %>% 
    select(c('gene_name', 'expression', 'name', 'sample_name'))
  
  colnames(gene_expression_table) = c('Gene', 'Expression','Condition', 'Sample')
  
  return(gene_expression_table)
}

################
getDiffGeneTable <- function(expId, condition_table){
  
  #load diff gene expression
  diff_gene_table = diff_gene_expression %>%
    filter(experiment_id == expId)
  
  #load condition table
  tmp_condition = condition_table %>% select(c('id', 'name'))
  
  diff_gene_table = merge(diff_gene_table, gene_info, by.x= 'entrez', by.y = 'entrez', all.x= T)
  diff_gene_table = merge(diff_gene_table, tmp_condition, by.x= 'condition1_id', by.y = 'id', all.x= T)
  diff_gene_table = merge(diff_gene_table, tmp_condition, by.x= 'condition2_id', by.y = 'id', all.x= T)
  
  #reorder eneTable
  diff_gene_table = diff_gene_table[,c(2,1,3,5,15,17,18,8, 11,12)]
  colnames(diff_gene_table) <- c("condition1_id", "condition2_id", "entrez",
                                 "gene_name", "description",  "condition1",
                                 "condition2", "logfc", "pvalue", "fdr")
  return(diff_gene_table)
  
}

################
filterDiffGeneTable <- function(diff_gene_table, condition_table, condition1, condition2, fdr){
  data <- diff_gene_table
  if (condition1 != "All" & condition2 != 'All'){
    c1_id = condition_table$id[condition_table$name == condition1]
    c2_id = condition_table$id[condition_table$name == condition2]
    validated =  as.numeric(c1_id) > as.numeric(c2_id)
    validate(
      need(validated,"No results, choose opposite comparison")
    )
    
    filter = diff_gene_table$condition1_id ==c1_id & diff_gene_table$condition2_id ==c2_id
    data <- diff_gene_table[filter,]
  }
  
  data <- data[data$fdr < fdr, c(-1,-2)]
  
  #format the data
  data$fdr <- format(as.numeric(data$fdr), scientific = T, digits=4)
  data$pvalue <- format(as.numeric(data$pvalue), scientific = T, digits=4)
  data$logfc <- round(as.numeric(data$logfc), 3)
  # data$logcpm <- round(as.numeric(data$logcpm), 3)
  # data$lr <- round(as.numeric(data$lr), 3)
  return(data)
}

################
getKEGGTable <- function(expId, condition_table){
  #load kegg results
  kegg_table = kegg_pathway_analysis %>% filter(experiment_id == expId)
  
  #load condition table
  tmp_condition = condition_table %>% select(c('id', 'name'))
  
  kegg_table = merge(kegg_table, tmp_condition, by.x= 'condition1_id', by.y = 'id', all.x= T)
  kegg_table = merge(kegg_table, tmp_condition, by.x= 'condition2_id', by.y = 'id', all.x= T)
  kegg_table = merge(kegg_table, kegg_pathways, by.x = 'kegg_pathway_id', by.y = "id", all.x=T)
  #reorder eneTable
  kegg_table = kegg_table[,c(3,2,1,5:12,14,15,16)]
  colnames(kegg_table) <- c("condition1_id", "condition2_id", "kegg_pathway_id", "description", "n", "up",
                            "down", "p_up", "fdr_up", "p_down",  "fdr_down", "condition1", "condition2", "kegg")
  return(kegg_table)
}


##############
filterKEGGTable <- function(kegg_table, condition_table, condition1, condition2, fdr){
  data <- kegg_table
  if (condition1 != "All" & condition2 != 'All'){
    c1_id = condition_table$id[condition_table$name == condition1]
    c2_id = condition_table$id[condition_table$name == condition2]
    validated =  as.numeric(c1_id) > as.numeric(c2_id)
    validate(
      need(validated,"No results, choose opposite comparison")
    )
    
    filter = kegg_table$condition1_id ==c1_id & kegg_table$condition2_id ==c2_id
    data <- kegg_table[filter,]
  }
  
  data <- data[data$fdr_up < fdr | data$fdr_down < fdr, ]
  
  #format the data
  data$p_up <- format(as.numeric(data$p_up), scientific = T, digits=4)
  data$p_down <- format(as.numeric(data$p_down), scientific = T, digits=4)
  
  data$fdr_up <- format(as.numeric(data$fdr_up), scientific = T, digits=4)
  data$fdr_down <- format(as.numeric(data$fdr_down), scientific = T, digits=4)
  
  data = data %>% select(c("kegg", "description", "n", "up", "down", "p_up", "fdr_up", "p_down", "fdr_down", "condition1", "condition2"))
  return(data)
}

##############
getReactomeTable <- function(expId, condition_table){
  
  #load kegg results
  reactome_table = reactome_pathway_analysis %>%
    filter(experiment_id == expId)
  
  #load condition table
  tmp_condition = condition_table %>% select(c('id', 'name'))
  
  reactome_table = merge(reactome_table, tmp_condition, by.x= 'condition1_id', by.y = 'id', all.x= T)
  reactome_table = merge(reactome_table, tmp_condition, by.x= 'condition2_id', by.y = 'id', all.x= T)
  reactome_table = merge(reactome_table, reactome_pathways, by.x = 'reactome_id', by.y = "id", all.x=T)
  
  #reorder eneTable
  reactome_table = reactome_table[,c(3,2,1,5:12,14,15,16)]
  colnames(reactome_table) <- c("condition1_id", "condition2_id", "reactome_id", "description", "gene_ratio", "bg_ratio",
                                "pvalue", "padjust", "qvalue", "genes", "n", "condition1", "condition2", "reactome")
  
  return(reactome_table)
}

###############
filterReactomeTable <- function(reactome_table, condition_table, condition1, condition2, fdr){
  data <- reactome_table
  if (condition1 != "All" & condition2 != 'All'){
    c1_id = condition_table$id[condition_table$name == condition1]
    c2_id = condition_table$id[condition_table$name == condition2]
    validated =  as.numeric(c1_id) > as.numeric(c2_id)
    validate(
      need(validated,"No results, choose opposite comparison")
    )
    
    filter = reactome_table$condition1_id ==c1_id & reactome_table$condition2_id ==c2_id
    data <- reactome_table[filter,]
  }
  
  data <- data[data$qvalue < fdr, ]
  
  #format the data
  data$pvalue <- format(as.numeric(data$pvalue), scientific = T, digits=4)
  data$qvalue <- format(as.numeric(data$qvalue), scientific = T, digits=4)
  data$padjust <- format(as.numeric(data$padjust), scientific = T, digits=4)
  
  data = data %>% select(c("reactome", "description", "n", "gene_ratio", "bg_ratio", "pvalue", "padjust", "qvalue", "condition1", "condition2", "genes"))
  return(data)
}