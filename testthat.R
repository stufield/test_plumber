context("Testing the API local deployment")

library(jsonlite)
library(httr)



# Setup ----
api <- callr::r_bg(
  function() {
    pr <- plumber::plumb(dir = "R")
    pr$run()
  }
)


# necessary pause for API to startup
# if connection fails; try a longer sleep time
Sys.sleep(6)

test_that("API is alive", {
  expect_true(api$is_alive())
})

# Base Endpoint URL
# Modified below in the POST() and GET() calls
url <- "http://127.0.0.1"


# Testing ----
test_that("the API returns the correct POST request predictions", {
  r <- httr::POST(url, body = toJSON(data.frame(a = 1)), encode = "json",
                  port = 8000, path = "myapi")
  expect_equal(r$status_code, 200)
  r_txt <- httr::content(r, as = "text", encoding = "UTF-8")
  expect_named(fromJSON(r_txt), "api_response")
  out <- fromJSON(r_txt) %>% purrr::pluck("api_response")
  expect_is(out, "numeric")
  set.seed(1)
  expect_equal(out, rnorm(10))
})

# not sure if this is necessary
testthat::teardown({
  api$kill()
})
