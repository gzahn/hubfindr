#' Find hub taxa
#'
#' Returns a named vector of hub taxa (vertices)
#'
#' @import igraph
#'
#' @param graph An igraph object
#' @param cutoff Method to use for determining hub taxa authority cutoff. One of "midpoint", "median","1sd","2sd
#' @param layout Which layout to use for vertices. Currently accepts one of: "auto","gem","davidson"
#' @param littlepoint Base size for non-hub taxa in the plot
#'
#' @return plot of igraph network with vertices sized by authority score
#'
#' @examples
#' plot_hubs(igraph_object)
#'
#' @export


# graph <- readRDS("../Cheeke_Proposal/Output/ITS_igraph_4_out.RDS")

find_hubs <- function(graph,cutoff="median"){

  a.score <- igraph::authority_score(graph)$vector
  h.score <- igraph::hub_score(graph)$vector

  if(cutoff=="median"){
    h.cutoff <- median(c(min(h.score),max(h.score)))
  }

  if(cutoff == "1sd"){
    h.cutoff <- mean(h.score) + 1*(sd(h.score))
  }

  if(cutoff == "2sd"){
    h.cutoff <- mean(h.score) + 2*(sd(h.score))
  }

  # use cutoff to pull hub taxa
  hub.taxa <- h.score[h.score > h.cutoff]
  hub.taxa.names <- names(hub.taxa)

  return(hub.taxa)
}
