#' Stream in & flatten an ndjson file into a \code{tbl_dt}
#'
#' Given a file of streaming JSON (ndjson) this function reads in the records
#' and creates a flat \code{data.table} / \code{tbl_dt} from it.
#'
#' @md
#' @param path path to file (supports "\code{gz}" files)
#' @param cls the package uses \code{data.table::rbindlist} for speed but
#'        that's not always the best return type for everyone, so you have
#'        option of keeping it a `tbl_dt` via "`dt`" or converting it to a `tbl`
#' @return \code{tbl_dt} or \code{tbl} or \{data.frame}
#' @export
#' @references \url{http://ndjson.org/}
#' @examples
#' f <- system.file("extdata", "test.json", package="ndjson")
#' nrow(stream_in(f))
#'
#' gzf <- system.file("extdata", "testgz.json.gz", package="ndjson")
#' nrow(stream_in(gzf))
stream_in <- function(path, cls = c("dt", "tbl")) {
  cls <- match.arg(cls, c("dt", "tbl"))
  tmp <- .Call('ndjson_internal_stream_in', path.expand(path), PACKAGE='ndjson')
  tmp <- dtplyr::tbl_dt(data.table::rbindlist(tmp, fill=TRUE))
  if (cls == "tbl") dplyr::tbl_df(tmp) else tmp
}

#' Validate ndjson file
#'
#' Given a file of streaming JSON (ndjson) this function reads in the records
#' and validates that they are all legal JSON records. If the \code{verbose}
#' parameter is \code{TRUE} and errors are found, the line numbers of the
#' errant records will be displayed.
#'
#' @param path path to file (supports "\code{gz}" files)
#' @param verbose display verbose information (filename and line numbers with bad records)
#' @return logical
#' @export
#' @references \url{http://ndjson.org/}
#' @examples
#' f <- system.file("extdata", "test.json", package="ndjson")
#' validate(f)
#'
#' gzf <- system.file("extdata", "testgz.json.gz", package="ndjson")
#' validate(gzf)
validate <- function(path, verbose=FALSE) {
  .Call('ndjson_internal_validate', path.expand(path), verbose, PACKAGE='ndjson')
}

#' Flatten a character vector of individual JSON lines into a \code{tbl_dt}
#'
#' @md
#' @param x character vector of individual JSON lines to flatten
#' @param cls the package uses \code{data.table::rbindlist} for speed but
#'        that's not always the best return type for everyone, so you have
#'        option of keeping it a `tbl_dt` via "`dt`" or converting it to a `tbl`
#' @return \code{tbl_dt} or \code{tbl} or \{data.frame}
#' @export
#' @examples
#' flatten('{"top":{"next":{"final":1,"end":true},"another":"yes"},"more":"no"}')
flatten <- function(x, cls = c("dt", "tbl")) {
  cls <- match.arg(cls, c("dt", "tbl"))
  tmp <- .Call('ndjson_internal_flatten', x, PACKAGE='ndjson')
  tmp <- dtplyr::tbl_dt(data.table::rbindlist(tmp, fill=TRUE))
  if (cls == "tbl") dplyr::tbl_df(tmp) else tmp
}
