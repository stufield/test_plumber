
## api-setup ----
library(plumber)
library(glmnet)


#* @apiTitle Generate 10 Random Numbers from a Gaussian
#* @apiDescription Show warning during plumber deployment via RSconnect

## filter-logger ----
#* Log some information about the incoming request: who, when
#* @filter logger
function(req) {
  cat(as.character(Sys.time()), "-",
      req$REQUEST_METHOD, req$PATH_INFO, "-",
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  forward()
}

## Return 10 Gaussian ----
#* A POST request for the model
#* @param req The request body; data in JSON format.
#* @json(digits = 12)
#* @post /myapi
function(req, res) {
  data <- tryCatch(jsonlite::parse_json(req$postBody, simplifyVector = TRUE),
                   error = function(e) NULL)
  if ( is.null(data) ) {
    res$status <- 400
    return(list(error = "No data submitted!"))
  }
  if ( !inherits(data, "data.frame") ) {
    stop("Incoming request in incorrect format ... not a data.frame")
  }
  set.seed(1)
  list(api_response = rnorm(10))
}

