library(pool)
library(dplyr)
require("httr")
require("jsonlite")
library(async)
library(future)
plan(multiprocess)

#################connect to database#################
host = Sys.getenv(c("MYSQL"))
username = Sys.getenv(c("MYSQL_USER"))
password = Sys.getenv(c("MYSQL_PASSWORD"))

my_db2 <- dbPool(
  RMySQL::MySQL(),
  dbname = "rna_seq2",
  host = host,
  username=username,
  password = password
)

gene_table = data.frame(my_db2 %>% tbl('ensembl') %>% filter(species_id == 1) %>% select(c("gene_name")))
experiment_table = data.frame(my_db2 %>% tbl("experiment"))
condition_table = data.frame(my_db2 %>% tbl("condition"))

# 
poolClose(my_db2)
