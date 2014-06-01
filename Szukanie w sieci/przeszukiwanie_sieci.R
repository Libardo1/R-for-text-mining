google.search <- function(search){
   shell.exec(paste("http://www.google.com/#q=", search, sep = ""))
}


google.search("ANOVA")

rseek.search <- function(search){
   url <- paste("http://www.rseek.org/?cx=010923144343702598753%3Aboaz1reyxd4&newwindow=1&q=",search,"&sa=Search+functions%2C+lists%2C+and+more&cof=FORID%3A11&siteurl=www.rseek.org%2F%23q%3Dhey%2520guys#1006",sep = "")
   shell.exec(url)
}

rseek.search("ANOVA")

rseek.search("cmgph")

shell.exec("http://www.talkstats.com")
