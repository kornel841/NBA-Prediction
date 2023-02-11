rm(list=ls()) 
library(tidyverse)
install.packages("GGally")
library(GGally) # ggplot2-based visualization of correlations
install.packages("factoextra")
library(factoextra) # ggplot2-based visualization of pca

historical_players.df = read.csv(file = "nba.csv", header=T, sep=";")

glimpse(historical_players.df)

hist(rowMeans(is.na(historical_players.df)))

barplot(colMeans(is.na(historical_players.df)), las=2)

# skip players with NA information in any variable
historical_players.df =
  historical_players.df[rowSums(is.na(historical_players.df)) == 0,]
dim(historical_players.df)
#brakuje danych w kilku kolumnach; sprawdzmy czy mozemy usunac tylko wiersze

nba = historical_players.df[,3:ncol(historical_players.df)]
nba = as.data.frame(sapply(nba, as.numeric ))
names = historical_players.df[,2]

dim(nba)
summary(nba)
#usunieto ok. 200 graczy 

boxplot(nba, las=2, col="darkblue")

# skalowane czy nieskalowane?
boxplot(scale(nba), las=2, col="darkblue")

# korelacja z GGally
ggcorr(nba, label = T)
#widzimy silna korelacje pomiedzy ftm i fta; natomist ciezko jest uzyskac dodatkowe informacje dlatego potrzebujemy zredukowac wymiar

pca = prcomp(nba, scale=T)
# pca = princomp(nba, cor=T) # the same, but using SVD instead of eigen decomposition 
summary(pca)

#ile komponentów bedzie wykorzystywane?
fviz_screeplot(pca, addlabels = TRUE)
#dzieki 2 komponentom jestesmy w stanie wytlumaczyc 70% zmiennosci 

#INTERPRETACJA
#1st PCA - stl_tov = 1 (bo jest to znormlaizowany wektor)
barplot(pca$rotation[,1], las=2, col="red")
sum(pca$rotation[,1]^2)
#that means squared loading are easier to interpret than the loadings; contribution of variables to components 
fviz_contrib(pca, choice = "var", axes = 1, color="yellow")
#czerwonia linia na wykresie wskazuje na expected average contribution
#teraz mozemy uszeregowac graczy wg ich 1-szych wynikow na PC; najlepszych historycznych graczy pod wzgledem wydajnosci 

calculateScore = function(data) {
  return(sum((pca$rotation[, 1]*data)^2))
}
historical_players.df$player_name[sort.int(apply(nba, 1, calculateScore), decreasing = T, index.return = T)$ix[1:10]]

#analiza drugiego komponentu
barplot(pca$rotation[,2], las=2, col="lightpink")

calculateScore = function(data) {
  return(sum((pca$rotation[, 2]*data)^2))
}
nba$gp[sort.int(apply(nba, 1, calculateScore), decreasing = T, index.return = T)$ix[1:10]]

fviz_contrib(pca, choice = "var", axes = 2)

#udzial kazdego gracza w komponentach
head(get_pca_ind(pca)$contrib[,1]) # tw %, miedzy 0 a 100
head((pca$x[,1]^2)/(pca$sdev[1]^2))/dim(nba)[1] # przedzial miedzy 0 a 1

#wszyscy gracze, pierwszy komponent
fviz_contrib(pca, choice = "ind", axes = 1)

#zobaczmy pierwsze imiona
names[order(get_pca_ind(pca)$contrib[,1],decreasing=T)][1:10]
# mega podobny do names[order(pca$x[,1])][1:10] ale w %

#widok w top 20 graczy 
names_z1 = names[order(get_pca_ind(pca)$contrib[,1],decreasing=T)]
fviz_contrib(pca, choice = "ind", axes = 1, top=20)+scale_x_discrete(labels=names_z1)

biplot(pca) #dla 2 pierwszych komponentów;nieinformacyjny bo za duzo graczy 

fviz_pca_var(pca, col.var = "contrib") #na podstawie zmiennych  (contributions) - instead of loading, without graczy 

#WYNIKI 
#wykreslanie wykresu dla dwoch pierwszych wynikow
data.frame(z1=-pca$x[,1],z2=pca$x[,2]) %>% 
  ggplot(aes(z1,z2,label=names)) + geom_point(size=0) +
  labs(title="PCA", x="PC1", y="PC2") +
  theme_bw() + scale_color_gradient(low="black", high="green")+theme(legend.position="bottom") + geom_text(size=2, hjust=0.6, vjust=0, check_overlap = TRUE)
#pieerwsze 2 PCA wydaja sie niezalezne ale sa nieskorelowane

#dla rozgranych gier: 
data.frame(z1=-pca$x[,1],z2=pca$x[,2]) %>% 
  ggplot(aes(z1,z2,label=names,color=nba$gp)) + geom_point(size=0) +
  labs(title="PCA", x="PC1", y="PC2") +
  theme_bw() + scale_color_gradient(low="red", high="green")+theme(legend.position="bottom") + geom_text(size=2, hjust=0.6, vjust=0, check_overlap = TRUE)

#top gracze maja wysokie PC1 i sa dopasowani do prawej strony wykresu 
#gracze ofensywy maja wysokie PC2 i sa widoczni w gornej czesci wykresu 
#mozemy sklasyfikowac dowolnego gracza na podstawie tego wykresu i dokonac rozroznien. w prawnym gornym rogu widac najlepsza ofenywe natomiast w prawym dolnym to najlepsza obrona 

#PODSUMOWANIE
#dzieki PCA mozemy zmniejszyc wymiary i lepiej zobaczyc roznice pomiedzy graczami 
#PCA pozwala nam zredukowac naprawde duze zbiory danych do latwiejszego ich analizowania 
#mozmey lepiej wykreslic grupy i identyfikowac separacje miedzy kazdym typem
#PCA koncentruje sie na relacjach miedzy zaleznymi co przeklada sie na lepszy model,dopasowanie 