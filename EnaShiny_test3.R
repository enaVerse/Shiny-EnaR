############# Check and install missing packages
list.of.packages <- c("network", "enaR", "networkD3")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


library(network)
library(networkD3)
library(enaR)

############# Building the enaR model
Ena_inputs_function<- function (flow, input, export, respiration, storage, living){
  
  length<-nrow(input)
  
  flow<-as.matrix(flow)
  input<-input[c(1:length),]
  export<-export[c(1:length),]
  respiration<-respiration[c(1:length),]
  storage<-storage[c(1:length),]
  living<-living[c(1:length),]
  
  ###model construction
  model_test<-pack(flow = flow, input = input, 
                   export = export, respiration = respiration,
                   living = living, storage = storage)
  

############# Building the network plot 
  
  ### Construction des objets sources et target à partir de la matrice des flux
  F_mat <- as.matrix(model_test,attrname="flow") #matrice des flux
  vertex <- which(F_mat!=0, arr.ind=T) #extraction des coodronnées des vertex
  
  ###construction of simple network (network3d package, function : "simpleNetwork")
  n<-nrow(vertex)
  
  # source vector
  source<-vector()
  for (i in 1:n) {
    x<-vertex[i,1]
    source[[i]]<-row.names(F_mat)[x]
  }
  
  # target vector
  target<-vector()
  for (i in 1:n) {
    x<-vertex[i,2]
    target[[i]]<-row.names(F_mat)[x]
  }
  
  Network_data<-data.frame(source, target)
  simpleNetwork(Network_data, fontSize = 12, linkDistance = 200, opacity = 0.9, fontFamily = "Corbel" )
  
  ###construction of a complex network (network3d package, function : "forceNetwork")
  
  #flux data
  flow<-vector()
  for (i in 1:n) {
    flow[i]<-F_mat[vertex[i,1], vertex[i,2]]
  }
  
  Links<-vertex
  Links<-data.frame(source = Links[,1]-1, target = Links[,2]-1, value = flow) # le -1 c'est pour commencer à partir de l'indice 0 pour le package network3d
  
  vertex.cex=model_test%v%"storage"
  Nodes<-data.frame(name=row.names(F_mat), group = 1, size = vertex.cex)
  
 return(forceNetwork(Links = Links, Nodes = Nodes,
                      Source = "source", Target = "target", 
                      Value = "value", NodeID = "name", 
                      Group = "group", Nodesize = "size",
                      fontSize = 12, fontFamily = "Arial",
                      linkDistance = 200,
                      #linkDistance = JS("function(d){return 1/d.value * 100}"), 
                      opacity = 0.9, zoom = T,
                      arrows = T, opacityNoHover = 0.7
  )
 )
}


############# Table of main outputs of enaR  

Ena_mainOutputs_function<- function (flow, input, export, respiration, storage, living){
  
  length<-nrow(input)
  
  flow<-as.matrix(flow)
  input<-input[c(1:length),]
  export<-export[c(1:length),]
  respiration<-respiration[c(1:length),]
  storage<-storage[c(1:length),]
  living<-living[c(1:length),]
  
  ###model construction
  model_test<-pack(flow = flow, input = input, 
                   export = export, respiration = respiration,
                   living = living, storage = storage)
 
 
ena_asc<-enaAscendency(model_test)
ena_flow<-enaFlow(model_test)
ena_structure <- enaStructure(model_test)

TST<-ena_flow$ns[2]
APL<-ena_flow$ns[4]
FCI<-ena_flow$ns[5]
N<-ena_structure$ns[1]
ASC<-ena_asc[5]
Robustness <-ena_asc[9]

main_outputs<-data.frame(Compartiments = N, TST = TST, 
                         APL=APL, Ascendency = ASC, 
                         FCI = FCI , Robustness=Robustness)
return(main_outputs)
}

