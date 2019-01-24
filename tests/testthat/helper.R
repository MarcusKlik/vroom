test_vroom <- function(content, ..., equals) {
  expect_equivalent(
    vroom(content, ...),
    equals
  )

  tf <- tempfile()
  on.exit(unlink(tf))
  readr::write_lines(content, tf)

  con <- file(tf, "rb")
  on.exit(close(con), add = TRUE)

  res <- vroom(con, ...)

  # Has a temp_file environment, with a filename
  tf2 <- attr(res, "filename")
  expect_true(is.character(tf2))
  expect_true(file.exists(tf2))
  expect_equivalent(res, equals)

  rm(res)
  gc()

  # Which is removed after the object is deleted and the finalizer has run
  expect_false(file.exists(tf2))
}
