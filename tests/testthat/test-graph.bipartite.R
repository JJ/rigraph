test_that("make_bipartite_graph works", {
  I <- matrix(sample(0:1, 35, replace = TRUE, prob = c(3, 1)), ncol = 5)
  g <- graph_from_incidence_matrix(I)

  edges <- unlist(sapply(seq_len(nrow(I)), function(x) {
    w <- which(I[x, ] != 0) + nrow(I)
    if (length(w) != 0) {
      as.vector(rbind(x, w))
    } else {
      numeric()
    }
  }))
  g2 <- make_bipartite_graph(seq_len(nrow(I) + ncol(I)) > nrow(I), edges)
  I2 <- as_incidence_matrix(g2)

  expect_that(I2, is_equivalent_to(I))
})

test_that("make_bipartite_graph works with vertex names", {
  types <- c(0, 1, 0, 1, 0, 1)
  names(types) <- LETTERS[1:length(types)]
  edges <- c("A", "B", "C", "D", "E", "F", "A", "D", "D", "E", "B", "C", "C", "F")
  g <- make_bipartite_graph(types, edges)

  expect_that(V(g)$name, is_equivalent_to(c("A", "B", "C", "D", "E", "F")))
  expect_that(V(g)$type, is_equivalent_to(c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE)))

  expect_error(make_bipartite_graph(types, c(edges, "Q")), "edge vector contains a vertex name that is not found")
})
