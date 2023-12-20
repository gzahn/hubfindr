#' Find hub taxa
#'
#' Returns a named vector of hub taxa (vertices)
#'
#' @import igraph
#' @import SpiecEasi
#'
#' @param graph An igraph object
#' @param physeq A phyloseq object (must include taxonomy table) that matches the taxa in the igraph object
#' @param cutoff Method to use for determining hub taxa authority cutoff. One of "midpoint", "median","1sd","2sd"
#'
#' @details
#' cutoff == "midpoint": hub taxa have scores above the midpoint between min and max hub scores
#' cutoff == "1sd": hub taxa have scores > 1 std.dev higher than the mean hub score
#' cutoff == "2sd": hub taxa have scores > 2 std.devs higher than the mean hub score
#'
#'
#' @return Data Frame of hub taxa identities and hub scores. colNames = c("hub_taxon","hub_score","vertex_id). If the igraph object does not have vertex names, a vector of hub values for taxa over the threshold is returned instead.
#'
#' @examples
#' find_hubs(igraph_object,physeq)
#'
#' @export


# graph <- readRDS("../Cheeke_Proposal/Output/ITS_igraph_4_out.RDS")

find_hubs <- function(graph,physeq,cutoff="midpoint"){

  a.score <- igraph::authority_score(graph)$vector
  h.score <- igraph::hub_score(graph)$vector

  if(cutoff=="midpoint"){
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

  if(length(unique(hub.taxa.names)) == 1){
    warning("igraph object did not have vertex names. returning unnamed hub values.")

    return(hub.taxa)
  } else {
    hub.taxa.indices <- as.numeric(names(hub.taxa))
    hub.taxonomy <- paste(
      tax_table(physeq)[hub.taxa.indices,1],
      tax_table(physeq)[hub.taxa.indices,2],
      tax_table(physeq)[hub.taxa.indices,3],
      tax_table(physeq)[hub.taxa.indices,4],
      tax_table(physeq)[hub.taxa.indices,5],
      tax_table(physeq)[hub.taxa.indices,6],
      tax_table(physeq)[hub.taxa.indices,7],
      sep = ";"
    )

    vertex.labels <- names(hub.taxa)

    names(hub.taxa) <- hub.taxonomy

    hub.taxa.df <-
    data.frame(hub_taxon = names(hub.taxa),
               hub_score = unname(hub.taxa),
               vertex_id = vertex.labels)

    return(hub.taxa.df)
  }




}
