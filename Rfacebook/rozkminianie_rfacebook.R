install.packages("Rfacebook")
library(Rfacebook)
help(package=Rfacebook)



tokenX <- "CAACEdEose0cBABWShf92a3ggf3x3LKf2NcTfsGVHqTqUIQxoZAP5QTE9HPMWl1Q14SlgZAOwViTCTiePptSXFhkaLPl34f0S1pkdzjK5rXPYXuCB1RHCZAjSefwYja1YW99gXBFh20doZByO57i0C3ZBJlstwrifnlai68kpBzdzl3BYFwdj9D41gbjA3vY4ZD"
me <- getUsers("100000389837213", tokenX, private_info = TRUE)
me$name # my name
names(me)

fanpejdz <- getUsers("511322428879731", token=tokenX, private_info=TRUE)
fanpejdz
tk <- tokenX
getFriends(token=tk, simplify=TRUE)
my_friends <- getFriends(token=tokenX, simplify=TRUE)
my_friends[111,]

my_friends_info <- getUsers(my_friends$id, token=tokenX, private_info=TRUE)
t(my_friends_info[111,])
my_friends_info$username


table(my_friends_info$relationship_status)

z<-getPage("KorkiMatma", token=tokenX)
z

fb.posts <- searchFacebook( "stringi", token=tokenX, n=100)
fb.posts


fb.users <- getUsers( fb.posts$from_id, token=tokenX )
table(fb.users$gender)


getCheckins(me$id, token=tokenX, n=20, tags=FALSE)
getCheckins(c("1557861575"), token=tokenX, n=20, tags=FALSE)


class(me$id)

?getNetwork

mat <- getNetwork(token=tokenX, format="adj.matrix")
# install.packages("igraph")
library(igraph)
colnames(mat) <- 1:dim(mat)[2]
network <- graph.adjacency(mat, mode="min", diag=FALSE, weighted=TRUE,add.rownames="code")
#pdf("network_plot.pdf")
plot(network)
dev.off()

mat2 <- mat
mat2 <- apply(mat2,2, as.numeric) 
mat2 <- as.matrix(mat2)
heatmap(mat2,Rowv = NA, Colv = NA, scale = "column")


x <- getPage(page="KorkiMatma",token=tokenX, n=1000, feed=TRUE)
names(x)
x$from_id
# najbardziej like'owany post :)
t(x[91,])
shell.exec(paste("www.facebook.com/",x[which.max(x$likes_count),"id"], sep=""))
x$link

# info o ludziach postuajcych na mojej stronce
xx <- getUsers( x$from_id, token=tokenX)
xx <- getUsers( unique(x$from_id), token=tokenX, private_info=TRUE)


# najlepiej wzic o nich info jakie inne strony jeszcze lubia: getLikes()
xx


require(Rfacebook)
y <- getPage(page="pedzlenie",token=tokenX, n=1000, feed=TRUE)

head(y)
write.csv2(y, file="chaty.csv", row.names=TRUE)


z <- getNewsfeed(token=tokenX, n=200)
names(z)
z$message
names(x)
x$from_name

#moje polubienia
getLikes("100000389837213", n=500, token=tokenX)



#strony zawierajace slowo matematyka w opisice lub nazwie - konkurencja :P
konkur <- searchPages("matematyka", token=tokenX, n=1000)
konkur$likes

rr <- searchPages(c("R"), token=tokenX, n=1000)
names(rr)
rr$name

# najbardziej popularny post
?getPost #zwraca liste
oposcie <- getPost(x[which.max(x$likes_count),"id"], token=tokenX)
oposcie[1]
oposcie[2]
oposcie[3]
j <- oposcie$likes$from_id

# otiweramy stronke uzytkownikow, ktorzy lubia najbardziej popularny post 
sapply(paste("www.facebook.com/",j, sep=""), shell.exec )

# otwieramy strony konkurencji
sapply(paste("www.facebook.com/",konkur$id, sep=""), shell.exec )



#   page <- "KorkiMatma"
#   url <- paste0("https://graph.facebook.com/", page, "/posts?fields=from,message,created_time,type,link,comments.summary(true)", 
#                 ",likes.summary(true),shares&limit=")
#   zonk <- Rfacebook:::callAPI
#   con <- zonk(url = url, token = tokenX)
#   con$paging
 #   df <- Rfacebook:::pageDataToDF(con$data)
 #  df




### 30.04.2014

library(Rfacebook)
ddl <- Rfacebook:::callAPI
token2 <- tokenX

system.time({
url2 <- paste0("https://graph.facebook.com/", "185657434455?fields=members")
SGH <- ddl(url2, token=token2)


SGH_id <- character(length=length(SGH$members$data))
for ( i in 1:length(SGH$members$data)){
SGH_id[i] <- SGH$members$data[[i]]$id
}
SGH_info <- getUsers(SGH_id, token=token2)
})

head(SGH_info)
table(SGH_info$gender)



token2 <- tokenX

system.time({
url3 <- paste0("https://graph.facebook.com/", "185657434455?fields=members.fields(id)")
SGH3 <- ddl(url3, token=token2)
SGH3_id <- unlist(SGH3$members$data)
SGH3_info <- getUsers(SGH3_id, token=token2)
})

###WUM
url4 <- paste0("https://graph.facebook.com/", "255218128860?fields=members.fields(id)")
Uw <- ddl(url4, token=token2)
Uw_id <- unlist(Uw$members$data)
Uw_info <- getUsers(Uw_id, token=token2)
Uw_info
