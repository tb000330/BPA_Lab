#load packages
library("rvest")
library("tidyverse")
library("RSelenium")
library("stringi")

# cleaning up environment
rm(list=ls())

#open browser using Selenium
rD <- rsDriver(browser = "firefox", port=45310L, verbose=F) #change port number
remDr <- rD[["client"]]
url <- "https://www.tripadvisor.com/Hotel_Review-g294197-d12310284-Reviews-Signiel_Seoul-Seoul.html"
remDr$navigate(url)

# First wait for the DOM to load by pausing for a couple seconds.
Sys.sleep(2) 

#store items in vectors
dates = c()
score = c()
review_title = c()
reviews = c()
review_response = c()

other_score = c()
other_score_label = c()
other_score_all = c()
other_score_label_all = c()

review_date_all = c()
review_rating_all = c()
review_title_all = c()
review_text_all = c()
review_response_all = c()

df_all = c()
df_dates = c()
df_ratings = c()
df_title = c()
df_response = c()
df_reviews = c()


##Test the page expansion and code
remDr$findElements("xpath", ".//div[contains(@data-test-target, 'expand-review')]")[[1]]$clickElement()
html <- remDr$getPageSource()[[1]]
html <- read_html(html)

#pagesequence, indicate number of English reviews. 
NumReviews <- plyr::round_any(182, 10, f = ceiling) #round-up!
PageSequence <- seq(from = 0, to = (NumReviews)-10, by = 10)
#options(max.print=1000000) #if more than 10,000 reviews
NumReviews

## Proceed with data scraping
for (i in PageSequence){
  
  if (i == 0){
  # remDr$navigate(url)
  } 
  else{
   Sys.sleep(1) 
  }
  
  remDr$findElements("xpath", ".//div[contains(@data-test-target, 'expand-review')]")[[1]]$clickElement()
  html <- remDr$getPageSource()[[1]]
  html <- read_html(html)
  
  dates <- html %>%
    html_elements(".teHYY._R.Me.S4.H3") %>%
    html_text() %>%
    str_remove_all("Date of stay: ")  # Remove unwanted strings
  
  review_title <- html %>%
    html_elements(".KgQgP.MC._S.b.S6.H5._a") %>%
    html_text() 
  
  reviews <- html %>% 
    html_elements("._T.FKffI q.QewHA.H4._a") %>% 
    html_text()
  
  score <- html %>%
    html_elements(".Hlmiy.F1") %>%
    html_children() %>% # Look at the child of the named class
    html_attr("class") %>% # Grab the name of the class of the child
    str_remove_all("ui_bubble_rating bubble_") %>%
    str_remove_all("0") %>%
    as.numeric()
  
  other_score_label <- html %>%
    html_elements(".hemdC.S2.H2.WWOoy span") %>%
    html_text() 
  other_score_label <- as.character(stri_remove_empty(other_score_label, na_empty = FALSE))
  
  other_score <- html %>%
    html_elements(".hemdC.S2.H2.WWOoy span.Nd") %>%
    html_children() %>% # Look at the child of the named class
    html_attr("class") %>% # Grab the name of the class of the child
    str_remove_all("ui_bubble_rating bubble_") %>%
    str_remove_all("0") %>%
    as.numeric()
  
  review_response <- html %>%
    html_elements(".fIrGe._T span.MInAm._a") %>%
    html_text()
  
  #integrate all data and reviews
  review_date_all = append(review_date_all, dates)
  review_rating_all = append(review_rating_all, score)
  review_text_all = append(review_text_all, reviews)
  review_response_all = append(review_response_all, review_response)
  review_title_all = append(review_title_all, review_title)
  
  #integrate detailed score labels
  other_score_all = append(other_score_all, other_score)
  other_score_label_all = append(other_score_label_all, other_score_label)
  
  remDr$findElements(using='css selector', ".ui_button.nav.next.primary")[[1]]$clickElement()
  Sys.sleep(2) 
}

path = "C:/Users/user/Desktop/Korean Hotels/"
name = "SignielSeoul"

##Reviews in txt file
df_reviews <- data.frame(review_text_all)
save2 <- paste0(path, name, "-Reviews.txt")
lapply(df_reviews, write, save2, append=T)

###Export DATES to csv file
df_dates <- data.frame('Dates' = review_date_all)
save3 <- paste0(path, name, "-Dates.csv")
write.csv(df_dates, file = save3, row.names = TRUE)

##Export ALL to csv file
df_all <- data.frame(#'Dates' = review_date_all,
                     'Title' = review_title_all,
                     'Rating' = review_rating_all,
                     'Review' = review_text_all)
save4 <- paste0(path, name, "-All.csv")
write.csv(df_all, file = save4, row.names = TRUE)


##Detailed label
df_detail <- data.frame(
  'Attribute' = other_score_all,
  'Rating' = other_score_label_all
   )
save5 <- paste0(path, name, "-detail.csv")
write.csv(df_detail, file = save5, row.names = TRUE)
