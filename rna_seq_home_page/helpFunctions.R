getReactomeJS <- function(id,genes){
  part1 = '<script> 
  var diagram = Reactome.Diagram.create({
  "placeHolder" : "diagramHolder",
  "width" : 1300,
  "height" : 700}); 
  diagram.loadDiagram("'
  part2 = '");'
  
  part3 = 'diagram.onDiagramLoaded(function (loaded) {
  console.info("Loaded ", loaded);
  diagram.flagItems("'
  part4='");});
  </script>'
  
  temp = paste(part1, id, part2, "\n", part3, genes, part4, sep="")
  
  # temp = paste(part1, id, part2, sep="")

  
  return(temp)
}


getSRC <- function(kegg_name, condition1, condition2, exp_id, pathview, condition_table){
  
  condition1 = condition_table %>% 
    filter(name == condition1) %>% 
    filter(experiment_id == exp_id) %>% 
    select(c('id'))
  condition2 = condition_table %>% 
    filter(name == condition2) %>% 
    filter(experiment_id == exp_id) %>% 
    select(c('id'))

  src = pathview %>% 
        filter(experiment_id == exp_id & condition1_id == condition1$id[1] & condition2_id == condition2$id[1]) %>%
        filter(kegg ==kegg_name)

  return(src$location)
  
}

createLink <- function(val, db,species_id_input) {
  if (db=="NCBI"){
    sprintf('<a href="https://www.ncbi.nlm.nih.gov/gene/?term=%s" class="btn btn-success" target="_blank">NCBI</a>',val)
  }
  else if(db=="OMIM"){
    val2 = mim2gene(val,species_id_input)
    
    sprintf('<a href="https://omim.org/entry/%s" class="btn btn-warning" target="_blank">OMIM</a>',val2)
      
  }
  else if(db=="Uniprot"){
    sprintf('<a href="http://www.uniprot.org/uniprot/%s" class="btn btn-danger" target="_blank">Uniprot</a>', val)
  }
}


mim2gene <- function(val,species_id_input){

  mim_temp <- mim %>% filter(species_id == species_id_input)
  #detemine whether species is rat
  if (species_id_input == 3){
    val_ensembl = left_join(as.data.frame(val), gene_info, by = c("val"="entrez")) %>%
      select(c('ensembl', 'val'))
    out <- left_join(val_ensembl, human_homolog[!duplicated(human_homolog$rat_ensembl),], by=c('ensembl' = 'rat_ensembl' )) %>%
      select(c('val', 'mim'))
  }
  else{
    out <- left_join(as.data.frame(val), mim_temp, by = c("val"="entrez"))
  }
  return(out$mim)
}


getKEGGLink<-function(kegg){
  kegg = sub("path:", "", kegg, fixed=T)
  link <- paste0("http://www.genome.jp/kegg-bin/show_pathway?", kegg)
  return(link)
}

getStringSVG2 <- function(genes, network_flavor, addInteractor1, 
                          addInteractor2,requried_score, species_id){
  
  string_api_url = "http://string-db.org/api"
  format = "svg"
  method = "network"
  
  my_genes = genes
  
  
  if (species_id==1){
    #human
    species = "9606"
  }else if(species_id==2){
    #mouse
    species = "10090"
  }else if (species_id==3){
    #rat
    species="10116"
  }
  
  
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

getFunctionalEnrichment2<-function(genes, species_id){
  
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "enrichment"
  
  my_genes = genes
  
  if (species_id==1){
    #human
    species = "9606"
  }else if(species_id==2){
    #mouse
    species = "10090"
  }else if (species_id==3){
    #rat
    species="10116"
  }
  
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

getStrNetwork2 <- function(genes, score, species_id){
  add_nodes = 0
  string_api_url = "http://string-db.org/api"
  format = "json"
  method = "network"
  
  my_genes = genes
  
  if (species_id==1){
    #human
    species = "9606"
  }else if(species_id==2){
    #mouse
    species = "10090"
  }else if (species_id==3){
    #rat
    species="10116"
  }
  
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



