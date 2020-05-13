# The next packages will be needed, if you have not installed them, please uncomment the lines
# install.packages("intergraph")
# install.packages("ggnetwork")
# install.packages("netrankr")
# install.packages("ggrepel")

#Load the libraries. 
library(tidygraph)
library(intergraph)
library(ggnetwork)
library(netrankr)
library(ggrepel)

# Obtain the data. 
library(devtools)
install_github("DougLuke/UserNetR")
library(UserNetR)
data(Bali)

#Start building the net 
net <- ggnetwork(Bali, layout="kamadakawai")
head(net)

# b. Plot the network using ggplot with the terrorists in the nodes. 
ggplot(net,aes(x,y,xend=xend,yend=yend)) + geom_edges(color="lightgrey") + geom_nodes(alpha=0.6,size=5) + geom_nodetext(aes(label=vertex.names),col="red") + theme_blank()

# c. Plot the network using ggplot with the role of the terrorists in the nodes. 
ggplot(net,aes(x,y,xend=xend,yend=yend)) + geom_edges(color="lightgrey") + geom_nodes(alpha=0.6,size=5) + geom_nodetext(aes(label=role),col="yellow") + theme_blank()
