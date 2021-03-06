#' @export
makeTSPSolver.farthest_insertion = function() {
  makeTSPSolverInternal(
    cl = "farthest_insertion",
    short.name = "farthest_insertion",
    name = "Farthest Insertion Algorithm for the (euclidean) TSP",
    description = "",
    properties = c("euclidean", "deterministic"),
    packages = "TSP"
  )
}

#' @export
run.farthest_insertion = function(solver, instance, ...) {
  return(runSolverFromTSPPackage(solver, instance, ...))
}
