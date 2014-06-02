install.packages("tm")
library(tm)

txt <- system.file("texts", "txt", package = "tm")

####   Corpus  ####

(ovid <- Corpus(DirSource(txt, encoding = "UTF-8"), readerControl = list(language = "lat")))
inspect(ovid)
summary(ovid)

ovid[[2]]
ovid[["ovid_2.txt"]]

docs <- c("This is a text.", "This another one.")
docsc <- Corpus(VectorSource(docs))
inspect(docsc)


#install.packages("XML")
#library(XML)

#format XML - 
reut21578 <- system.file("texts", "crude", package = "tm")
reuters <- Corpus(DirSource(reut21578), readerControl = list(reader = readReut21578XML))
inspect(reuters) # duzo smieci, znaczniki "<>" w tekscie 

###  Przetwarzanie tekstu  +  tm_map   ####

reuters <- tm_map(reuters, as.PlainTextDocument)
inspect(reuters) # pozbylismy sie smieci

reuters <- tm_map(reuters, stripWhitespace)
reuters <- tm_map(reuters, tolower)
reuters <- tm_map(reuters, removeWords, stopwords("english"))
stopwords("en")
reuters <- tm_map(reuters, removePunctuation)
i1<-inspect(reuters) 
i1[[1]] ## czysty tekst

#install.packages("SnowballC")
#library(SnowballC)
reuters <- tm_map(reuters, stemDocument)
i2<-inspect(reuters) 
i2[[1]] # bez koncowek ("s","ed")
i1[[1]] # z koncowkami

##  filtrowanie  ##

#install.packages("stringi")
library(stringi)
## filtrowanie po tekstach
reutf <- tm_filter(reuters, FUN = function(x) stri_detect_fixed(x,"contract price") )
reutf
inspect(reutf)

## filtrowanie po metadanych
tm_filter(reuters, FUN = sFilter, query)
query <- "id =='237'& heading =='INDONESIA SEEN AT CROSSROADS OVER ECONOMIC CHANGE'"
tm_filter(reuters, FUN = sFilter, query)

###  Metadane   ###

data("crude")
DublinCore(crude[[1]])
DublinCore(crude[[1]], "Creator") <- "Ano Nymous"
DublinCore(crude[[1]])
meta(crude[[1]])
meta(crude, tag = "test", type = "corpus") <- "test meta"
meta(crude, type = "corpus")
meta(crude, "foo") <- letters[1:20]
meta(crude)

###     DocumentTermMatrix   ###

dtm <- DocumentTermMatrix(reuters)
dtm
inspect(dtm[1:10,100:105])

##  czesto wystepujace slowa  ##
findFreqTerms(dtm, 10)

inspect(dtm[,c("oil","opec")])

###  mozna policzyc sobie korelacje  ###
cor(inspect(dtm[,c("oil")]),inspect(dtm[,c("opec")]))

###  troche wygodniej:  ###
findAssocs(dtm, "opec", 0.8)


##########################

source("http://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")
plot(tdm,corThreshold = 0.5, weighting = TRUE)

###  uzupelnianie koncowek  ###

stemCompletion(c("compan", "entit", "suppl"), crude)
(s <- stemDocument(crude[[1]]))
stemCompletion(s, crude)



######    porownywanie tekstow   -   macierz odmiennosci  #####

#install.packages("proxy")
#library(proxy)

#data("crude")
#tdm <- TermDocumentMatrix(crude)
d <- dissimilarity(dtm, method = "cosine") #nie zwraca macierzy tylko obiekt klasy "dist"
as.matrix(d)[1:8,1:8]

dissimilarity(crude[[1]], crude[[2]], method = "eJaccard")



#######   PRZYKLAD    ######


wiki <- Corpus(VectorSource(c(
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Integral"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Riemann_integral"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Riemann%E2%80%93Stieltjes_integral"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Derivative"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Limit_of_a_sequence"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Monoid"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Group_%28mathematics%29"),col=" "),
  stri_flatten(readLines("http://en.wikipedia.org/wiki/Ring_%28mathematics%29"),col=" "))))

inspect(wiki) #wyglada paskudnie...

wiki2 <- tm_map(wiki,function(x) stri_replace_all_regex(x,"<.+?>"," "))
wiki3 <- tm_map(wiki2,function(x) stri_replace_all_fixed(x,"\t"," "))

wiki4 <- tm_map(wiki3, PlainTextDocument)
wiki5 <- tm_map(wiki4, stripWhitespace)
wiki5 <- tm_map(wiki5, tolower)
wiki5 <- tm_map(wiki5, removeWords, stopwords("english"))
wiki5 <- tm_map(wiki5, removePunctuation)



inspect(wiki5)  #wyglada niezle
wikiTDM <- TermDocumentMatrix(wiki5)
wikiTDM

dim(wikiTDM)
inspect(wikiTDM[stri_detect_regex(rownames(wikiTDM),"^(integr)"),])

inspect(wikiTDM[c("integral","derivative","riemann","limit","infinity","operation"),])
wikidissim <- dissimilarity(wikiTDM, method = "cosine") #zwraca obiekt klasy 'dist'!

wikidissim2 <- as.matrix(wikidissim)
rownames(wikidissim2) <- c("Int.","Riem. int.","R. S. int.",
                           "Der.","Lim.","Mon.","Group","Ring") 
colnames(wikidissim2) <- c("Integral","Riem. integral","R. Stieltjes int.",
                           "Derivative","Limit...","Monoid","Group","Ring")
wikidissim2
h <- hclust(wikidissim, method="ward")
plot(h,labels=c("Integral","Riemann integral","Riemann and Stieltjes integral",
                "Derivative","Limit of a sequence","Monoid","Group","Ring"))





