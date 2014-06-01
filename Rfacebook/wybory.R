if(!require(Rfacebook)) { 
   install.packages("Rfacebook"); require(Rfacebook)}
fb.posts_wybory <- searchFacebook( "wybory", token=tokenX, n=1000)
fb.posts_wybory


#usuwam puste wpisy zawierajace same linki/zdjecia bez komentarzy
Wposty <- na.omit(fb.posts_wybory$message)

#usuwam spam 
Wposty <- unique(Wposty)

#wgrywam posty do tabelki .csv
write.csv2(Wposty, file="wybory.csv", row.names=TRUE)


# wgrywam posty do jednego pliku .txt
require(stringi)
Wposty_single <- stri_flatten(Wposty, collapse= "\n ")

write.table(Wposty_single,"Wposty_single.txt", sep="\t", quote=FALSE )
