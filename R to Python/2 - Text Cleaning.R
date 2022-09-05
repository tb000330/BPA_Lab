# Load
library("tm")

rm(list=ls()) # cleaning up environment

src_dir = c("C:/Users/user/Desktop/220809 - Top Hotels/Sentence")
src_file = list.files(src_dir) # list
src_file
src_file_cnt <- length(src_file)


# Text cleaning process
for (i in 1:src_file_cnt){
  
  text = readLines(paste(src_dir,"/",src_file[i], sep=""))
  name = sub('.txt$', '', src_file[i])  
  #print(name)
  
  # Load the data as a corpus
  docs <- Corpus(VectorSource(text))
  inspect(docs)
  
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english common stopwords
  docs <- tm_map(docs, removeWords, stopwords("english"))
  # Remove punctuations
  docs <- tm_map(docs, removePunctuation)
  # Eliminate extra white spaces
  docs <- tm_map(docs, stripWhitespace)
  
  # specify your stopwords as a character vector
  docs <- tm_map(docs, removeWords, c("also", "can", "will", "ubububububwifiubububububub", "ububububub")) 
  # Text stemming
  # docs <- tm_map(docs, stemDocument)
  
  #File format is ANSI, change to UTF-8
  saveaddress = paste0("C:/Users/user/Desktop/220809 - Top Hotels/cleaning_text/",name,"(refined).txt")
  lapply(docs, write, saveaddress, append=T)
  
}
