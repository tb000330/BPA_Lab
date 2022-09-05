#install.packages("tokenizers")
library(tokenizers)

rm(list=ls()) # cleaning up environment
src_dir = c("C:/Users/user/Desktop/220809 - Top Hotels/Raw Data")
# listing up name of files in the directory => object
src_file = list.files(src_dir) # list
src_file
src_file_cnt <- length(src_file)

for (i in 1:src_file_cnt) {
  Rword = readLines(paste(src_dir,"/",src_file[i], sep=""))
  Rword
  name = sub('.txt$', '', src_file[i])  
  print(name)
  Rsentese = tokenize_sentences(Rword)
  Rsentese = unlist(Rsentese)
  saveaddress = paste0("C:/Users/user/Desktop/220809 - Top Hotels/R_Sentence",name,"(sentence).txt")
  
  # ?????? ?????͸? ???Ϸ? ?Ʒ? ???ο? ????
  lapply(Rsentese, write, saveaddress, append=T)
  
}

