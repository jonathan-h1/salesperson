#' Compute tour length given a TSP instance and a tour/permutation.
#'
#' @param x [\code{Network}]\cr
#'   TSP instance.
#' @param tour [\code{integer}]\cr
#'   Permutation of nodes.
#' @param close.tour [\code{logical(1)}]\cr
#'   Should the tour be closed? I.e., do we want a roundtrip tour?
#'   Default is \code{TRUE}.
#' @param round [\code{logical}]\cr
#'   Should the distances be rounded? Default is \code{FALSE}. Concorde internally
#'   does this.
#' @return [\code{numeric(1)}]
#' @export
computeTourLength = function(x, tour, close.tour = TRUE, round = FALSE) {
  assertClass(x, "Network")
  assertFlag(close.tour)
  assertFlag(round)
  n = getNumberOfNodes(x)

  # if (!isPermutation(tour, source = seq(n))) {
  #   stopf("Second parameter needs to be a permutation of {1, ..., %i}.", n)
  # }

  # close tour
  if (close.tour)
    tour = c(tour, tour[1L])
  tour_length = 0

  #FIXME: fix this in makeNetwork
  dist.mat = x$distance.matrix
  if (hasDepots(x)) {
    dist.mat = as.matrix(dist(as.matrix(as.data.frame(x, include.extra = FALSE))))
  }

  # compute tour length
  for (i in 1:(length(tour) - 1L)) {
    tour_length = tour_length + dist.mat[tour[i], tour[i + 1L]]
    if (round) {
      tour_length = round(tour_length)
    }
  }
  return(tour_length)
}
