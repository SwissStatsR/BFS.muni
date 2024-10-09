#' Get municipalities snapshots
#'
#' a snapshot is the list of municipalities that exist for at least part of the
#' specified period (or the specified day when `start_period` = `end_period`)
#'
#' @param start_period Start of requested period
#' @param end_period End of requested period
#' @param escape_chars Defines forbidden characters in the response and their
#' respective escape characters. For example, with the value "/( ).(_)",
#' all slashes in the response will be replaced with a space while periods are
#' replaced with underscore.
#' @param hist_id Determines whether BFSNR (snapshot) or
#' HISTID (geographic levels) will be delivered.
#' @param name_repair \code{\link[readr]{read_csv}} is used internally and
#' ensures column names are "unique" using the "name_repair" argument.
#'
#' @return a data.frame/tibble
#' @export
#'
#' @examples
#' \donttest{
#' get_snapshots(
#'   start_period = "2024-01-01",
#'   end_period = "2024-08-01"
#' )
#' }
#'
get_snapshots <- function(
    start_period = Sys.Date(),
    end_period = Sys.Date(),
    escape_chars = NULL,
    hist_id = NULL,
    name_repair = "unique"
){
  httr2::request(base_url = "https://sms.bfs.admin.ch/") %>%
    httr2::req_url_path_append("WcfBFSSpecificService.svc/AnonymousRest/communes/snapshots") %>%
    httr2::req_url_query(startPeriod = format(as.Date(start_period), "%d-%m-%Y"),
                         endPeriod = format(as.Date(end_period), "%d-%m-%Y"),
                         useBfsCode = hist_id, # useBfsCode=true returns historic id, so changed argument name in function
                         escapeChars = escape_chars) %>%
    httr2::req_retry(max_tries = 3, max_seconds = 10) %>%
    httr2::req_perform() %>%
    httr2::resp_body_raw() %>%
    readr::read_csv(name_repair = name_repair, show_col_types = FALSE)
}
