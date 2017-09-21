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
    sprintf('<a href="https://www.ncbi.nlm.nih.gov/gene/?term=%s" class="btn btn-success">NCBI</a>',val)
  }
  else if(db=="OMIM"){
    val2 = mim2gene(val,species_id_input)
    sprintf('<a href="https://omim.org/entry/%s" class="btn btn-warning">OMIM</a>',val2)
  }
  else if(db=="Uniprot"){
    sprintf('<a href="http://www.uniprot.org/uniprot/%s" class="btn btn-danger">Uniprot</a>', val)
  }
}


mim2gene <- function(val,species_id_input){
  mim_temp <- mim %>% filter(species_id == species_id_input)
  out <- merge(mim_temp, as.data.frame(val), by.x="entrez", by.y="val", all.y = T)
  out[order(as.numeric(out$entrez)),]
  return(out$mim)
}

