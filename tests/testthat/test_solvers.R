context("TSP solvers")

test_that("Solvers from TSP package can be called without problems.", {
  # do five repetitions with random instances
  n.reps = 5L
  # check these solvers
  solvers = c("nearest_insertion", "farthest_insertion", "cheapest_insertion", "arbitrary_insertion",
    "nn", "repetitive_nn")

  for (i in seq(n.reps)) {
    n.points = sample(10:50, size = 1L)
    x = generateRandomNetwork(n.points)
    for (solver in solvers) {
      res = runSolver(solver, instance = x)
      expect_valid_TSPSolverResult(res, n.points, info = solver)
    }
  }
})

test_that("External solvers can be called", {
  skip_on_cran()
  skip_on_travis()

  solvers = c("eax", "lkh", "concorde")
  cutoff.time = 1
  n.points = 200L

  # extract correct os (see: https://www.r-bloggers.com/identifying-the-os-from-r/)
  get_os = function(){
    sysinf = Sys.info()
    if (!is.null(sysinf)){
      os = sysinf["sysname"]
      if (os == "Darwin") {
        os = "osx"
      }
    } else { ## mystery machine
      os = .Platform$OS.type
      if (grepl("^darwin", R.version$os)) {
        os = "osx"
      } else if (grepl("linux-gnu", R.version$os)) {
        os = "linux"
      }
    }
    tolower(os)
  }

  config.path = path.expand("~/.config/salesperson/")
  solverPaths(
    list(
      lkh = paste0(config.path, "solvers/LKH-2.0.7/LKH"),
      eax = paste0(config.path, "solvers/eax/main"),
      concorde = sprintf("%ssolvers/concorde/%s/concorde", config.path, get_os())
    )
  )

  for (solver in solvers) {
    x = generateRandomNetwork(n.points)
    res = runSolver(solver, instance = x, cutoff.time = cutoff.time)
    expect_valid_TSPSolverResult(res, n.points, info = solver)
  }
})
