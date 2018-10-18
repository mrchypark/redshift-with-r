## docker run -p 5432:5432 --name res -e POSTGRES_PASSWORD=1q2w3e -tid postgres

library(DBI)
library(dplyr)
library(tibble)
library(lubridate)

con <- dbConnect(RPostgres::Postgres(),
                 host = '192.168.99.100',
                 port = 5432,
                 user = 'postgres',
                 password = '1q2w3e')

dtdata <- as.character(Sys.time()+sample(1:1000000,10))
dtdata <- tibble(time = dtdata) %>% 
  mutate(time = as_datetime(time))

copy_to(con, dtdata, overwrite =T)
dbListTables(con)
DBI::dbGetQuery(con, "drop table dtdata")


tbl(con, "dtdata") %>% 
  mutate(add = time %+ interval% '9 hours') %>% 
  collect() %>% 
  mutate(date = as.Date(time),
         datez = as.Date(time, tz ="Asia/Seoul"))
