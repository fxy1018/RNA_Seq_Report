library(pool)
library(dplyr)

#################connect to database#################
# host = Sys.getenv(c("MYSQL"))
# username = Sys.getenv(c("MYSQL_USER"))
# password = Sys.getenv(c("MYSQL_PASSWORD"))

host = "127.0.0.1"
username = "ironwood"
password = "irtest"

my_db2 <- dbPool(
  RMySQL::MySQL(),
  dbname = "rna_seq2",
  host = host,
  username=username,
  password = password
)

#get experiment information
experiment_table = data.frame(my_db2 %>% tbl("experiment"))
experiment_table2 = experiment_table[,c(2,3,4,7)]
experiment_table2 = experiment_table2[order(experiment_table2$description),]
experiment_table2$date <- sapply(experiment_table2$date, function(x) sub(pattern = " 00:00:00", replacement = "",x = x))
colnames(experiment_table2) <- c('Experiment', 'Date', 'Tech', 'Description')

#get condition 
condition = data.frame(my_db2 %>% tbl("condition"))

#get sample
sample = data.frame(my_db2 %>% tbl("sample"))

#get tissue
tissue = data.frame(my_db2 %>% tbl('tissue'))

#get ensembl
ensembl = data.frame(my_db2 %>% tbl('ensembl'))

#get homologue
human_homolog = data.frame(my_db2 %>% tbl('human_homologue'))

#get gene expression
gene_expression_rpkm =data.frame(my_db2 %>% tbl("gene_expression_log_rpkm"))

#get TPM gene expression
gene_expression_tpm = data.frame(my_db2 %>% tbl("gene_expression_tpm"))


#get diff_gene_expression
diff_gene_expression = data.frame(my_db2 %>% tbl("diff_gene_expression"))

#get gene_info
gene_info = data.frame(my_db2 %>% tbl("gene_info") %>% select(c('entrez', 'symbol','ensembl', 'description','species_id')))

#get uniprot table
uniprot = data.frame(my_db2 %>% tbl("uniprot")%>%
                             select(c('uniprot', 'entry_name', 'protein_name', "species_id")))

#load mim2gene table
mim <- data.frame(my_db2 %>% tbl("gene_info") %>% 
                    select('entrez', 'mim', 'symbol', 'ensembl', 'species_id'))

#get kegg pathway analysis
kegg_pathway_analysis = data.frame(my_db2 %>% tbl('kegg_pathway_analysis'))

#get kegg pathway
kegg_pathways = data.frame(my_db2 %>% tbl('kegg_pathway'))

#get kegg disease pathway 
kegg_disease_pathways = data.frame(my_db2 %>% tbl("kegg_disease_pathway"))

#get kegg pathview table
pathview = data.frame(my_db2 %>% tbl('pathview'))
pathview = merge(pathview, kegg_pathways, by.x='kegg_id', by.y='id', all.x=T)

#get genes from kegg pathways
gene2KEGGTable = data.frame(my_db2 %>% tbl('kegg_pathway_gene')) %>% left_join(kegg_pathways, by = c("pathway_id" = 'id'))

#get reactome pathway analysis
reactome_pathway_analysis = data.frame(my_db2 %>% tbl('reactome_pathway_analysis'))

#get reactome pathway
reactome_pathways = data.frame(my_db2 %>% tbl('reactome_pathway'))

#get transpoter table
transporter = data.frame(my_db2 %>% tbl('transporter'))

#get transcription factor
transcription_factor = data.frame(my_db2 %>% tbl('transcription_factor'))

#get sGC table
sGC = data.frame(my_db2 %>% tbl("sgc_pathway_gene"))


poolClose(my_db2)

my_db <- dbPool(
  RMySQL::MySQL(),
  dbname = "ncbi_gene_expression",
  host = host,
  username=username,
  password = password
)

#get ncbi gene expression project
ncbi_gene_exp_project = data.frame(my_db %>% tbl("project"))
ncbi_expression_tissue = data.frame(my_db %>% tbl("expression_tissue"))
ncbi_tissue = data.frame(my_db %>% tbl('tissue'))

poolClose(my_db)
