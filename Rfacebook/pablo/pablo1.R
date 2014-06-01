library(maps)
library(mapproj)

# Load data
quakes <- read.csv('http://datasets.flowingdata.com/earthquakes1974.csv')

# Draw map
par(mar=c(0,0,0,0))
map("world", col="orange", bg="#000000", fill=FALSE, interior=TRUE, lwd=0.5, projection="cylequalarea", par=0, wrap=TRUE)
map("county", col="orange", bg="#000000", fill=FALSE, interior=TRUE, lwd=0.5, projection="rectangular", par=0, wrap=TRUE)
# Add points
ptsproj <- mapproject(quakes$longitude, quakes$latitude)
points(ptsproj, pch=20, cex=0.15, col="#ffffff40")
?map
# Circle the highest magnitude quakes
quakes.o <- quakes[order(quakes$mag, decreasing=TRUE),]
majorpts <- mapproject(quakes.o$longitude[1:10], quakes.o$latitude[1:10])
symbols(majorpts, circles=rep(0.03, 10), add=TRUE, inches=FALSE, fg="green", lwd=2)


https://mail.google.com/mail/u/0/?tab=wm#inbox/1456f5a8193a85ca