#' Find and plot hub taxa
#'
#' Returns a plot with points (vertices) sized by authority score
#'
#' @import igraph
#'
#' @param graph An igraph object
#' @param bigpoint Base point size for hub taxa in the plot
#' @param layout Which layout to use for vertices. Currently accepts one of: "auto","gem","davidson"
#' @param littlepoint Base size for non-hub taxa in the plot
#'
#' @return plot of igraph network with vertices sized by authority score
#'
#' @examples
#' plot_hubs(igraph_object)
#'
#' @export

# plot igraph, showing hub taxa articulation points as larger dots, sized by authority score
plot_hubs <- function(graph,bigpoint=10,littlepoint=3,layout='auto'){

  if(layout=='auto'){
    am.coord <- layout.auto(graph)
  }
  if(layout=="davidson"){
    am.coord <- igraph::layout.davidson.harel(graph)
  }
  if(layout=="gem"){
    am.coord <- igraph::layout.gem(graph)
  }

  art <- articulation_points(graph)
  plot(graph,
       layout = am.coord,
       vertex.size=(scale01(abs(igraph::authority_score(graph)$vector)) * 10)+3,
       vertex.label=NA)
}
