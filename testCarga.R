setwd("Descargas/datasets/")
summary(rendimiento)
barplot(rendimiento$SIT_FIN)
library(ggplot2)
p <- ggplot(rendimiento,aes(x=PROM_GRAL))
p + geom_bar()
p <- ggplot(rendimiento,aes(x=ASISTENCIA))
p + geom_bar()


