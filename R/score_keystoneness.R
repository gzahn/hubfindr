#' Find keystoneness scores for taxa
#'
#' Returns a data frame of taxa (vertices) and their keystoneness scores
#'
#' @import igraph
#' @import SpiecEasi
#' @import phyloseq
#'
#' @param graph An igraph object
#' @param physeq A phyloseq object (must include taxonomy table) that matches the taxa in the igraph object
#'
#' @details
#' "keystoneness" is defined here as the sum of zscores for mean degree, inverse betweenness centrality, closeness centrality, and eigenvector centrality. See https://doi.org/10.3389%2Ffmicb.2014.00219 for details.
#'
#'
#' @return Data Frame of all taxa identities and keystoneness scores. colNames = c("taxon","keystoneness_score","vertex_id). If the igraph object does not have vertex names, a vector of hub values for taxa over the threshold is returned instead.
#'
#' @examples
#' score_keystoneness(graph,physeq)
#'
#' @export


score_keystoneness <- function(graph,physeq){
  degree <- igraph::degree(graph) # high
  betweenness <- igraph::betweenness(graph) # low
  closeness <- igraph::closeness(graph) # high
  eigenvector_centrality <- igraph::evcent(graph)$vector # high

  df <- data.frame(degree,betweenness,closeness,eigenvector_centrality)

  df_zscore <- as.data.frame(apply(df,2,function(x){(x-mean(x,na.rm=TRUE))/sd(x,na.rm=TRUE)}))
  df_zscore$betweenness <- df_zscore$betweenness * -1 # invert, for lowest betweenness???

  keystone_scores <- data.frame(vertex_id = seq_along(df_zscore$degree),
                                keystone_score = rowSums(df_zscore))

  if(length(unique(igraph::vertex.attributes(graph)$name)) == 1){
    warning("igraph object did not have vertex names. returning unnamed keystoneness score values.")

    return(keystone_scores)
  } else {
    taxa.indices <- as.numeric(keystone_scores$vertex_id)
    vertex.taxonomy <- paste(
      phyloseq::tax_table(physeq)[taxa.indices,1],
      phyloseq::tax_table(physeq)[taxa.indices,2],
      phyloseq::tax_table(physeq)[taxa.indices,3],
      phyloseq::tax_table(physeq)[taxa.indices,4],
      phyloseq::tax_table(physeq)[taxa.indices,5],
      phyloseq::tax_table(physeq)[taxa.indices,6],
      phyloseq::tax_table(physeq)[taxa.indices,7],
      sep = ";"
    )


  return(data.frame(taxon=vertex.taxonomy,keystoneness_score=keystone_scores$keystone_score,vertex_id=keystone_scores$vertex_id))

        }
}


