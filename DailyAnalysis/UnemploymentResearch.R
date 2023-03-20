
library(data.table)
library(stringr)
library(plotly)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(pdftools)
library(tesseract)
#https://medium.com/swlh/the-adventure-of-pdf-to-data-frame-in-r-f90609035600

# Convert PDF to Excel######################################################################################

file_19 <- "https://www.bls.gov/news.release/archives/empsit_12062019.pdf"

read_industry<-function(file_19,page = 6){
data_19 <- pdf_text(file_19) %>% 
  str_split("\n")
by_industry_19 <- data_19[[page]]

#from line 9 -> line 53
#line 4 & line 5 as header
by_industry_19_header_1 <- by_industry_19[[4]]%>%str_squish() %>% str_split(' ')
by_industry_19_header_2 <- by_industry_19[[5]]%>%str_squish() %>% str_split(' ')

headers <- paste(by_industry_19_header_2[[1]][2:5],by_industry_19_header_1[[1]],sep = '_')
headers <- c('Category',headers)
# 9 -> 53 
infos <- c()
for( i in c(9:53)){
words <- by_industry_19[[i]] %>% str_squish() %>% str_split(' ')
#num_col<-grepl("[-]?[0-9]+[.]?[0-9]*|[-]?[0-9]+[L]?|[-]?[0-9]+[.]?[0-9]*[eE][0-9]+",words[[1]])
num_col <- !is.na(as.numeric(words[[1]]))
if(sum(num_col)>0){
  print(paste('this is the ' ,i,'row',sep = ''))
  print(length(words[[1]]))
  length_words <- length(words[[1]])
  cols_num <- words[[1]][(length_words-3):length_words]
   words_other <- words[[1]][1:(length_words-4)]
   cols_name <- paste0(words_other[words_other!='.'],collapse = ' ')
   info <- c(cols_name,cols_num)
   infos <- rbind(infos,info)
}
}

write.csv(infos,'infos_19.csv',row.names = FALSE)
return(infos)
}

file_20 <-  'https://www.bls.gov/news.release/archives/empsit_05072021.pdf'
file_22 <- 'https://www.bls.gov/news.release/pdf/empsit.pdf'

data_19 <- read_industry(file_19)
data_20 <- read_industry(file_20,page = 7)
data_22 <- read_industry(file_22,page = 6)
