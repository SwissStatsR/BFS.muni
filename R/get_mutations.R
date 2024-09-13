#' Get municipalities mutations
#'
#' Mutation list describes all changes related to municipalities that occurred
#' during the specified period.
#'
#' @param start_period Start of requested period
#' @param end_period End of requested period
#' @param escape_chars Defines forbidden characters in the response and their
#' respective escape characters. For example, with the value "/( ).(_)",
#' all slashes in the response will be replaced with a space while periods are
#' replaced with underscore.
#' @param include_territory_exchange Include/exclude records that only concern
#' territory changes.
#' @param name_repair \code{\link[readr]{read_csv}} is used internally and
#' ensures column names are "unique" using the "name_repeir" argument.
#'
#' @return a data.frame/tibble
#' @export
#'
#' @examples
#' \donttest{
#' get_mutations(start_period = "2024-01-01", end_period = "2024-08-01")
#' }
#'
get_mutations <- function(
    start_period = NULL,
    end_period = NULL,
    escape_chars = NULL,
    include_territory_exchange = NULL,
    name_repair = "unique"
  ){
  httr2::request(base_url = "https://sms.bfs.admin.ch/") %>%
    httr2::req_url_path_append("WcfBFSSpecificService.svc/AnonymousRest/communes/mutations") %>%
    httr2::req_url_query(startPeriod = format(as.Date(start_period), "%d-%m-%Y"),
                         endPeriod = format(as.Date(end_period), "%d-%m-%Y"),
                         includeTerritoryExchange = include_territory_exchange,
                         escapeChars = escape_chars) %>%
    httr2::req_retry(max_tries = 3, max_seconds = 10) %>%
    httr2::req_perform() %>%
    httr2::resp_body_raw() %>%
    readr::read_csv(name_repair = name_repair, show_col_types = FALSE)
}
