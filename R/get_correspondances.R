#' Get municipalities correspondances
#'
#' the correspondences indicate for each municipality existing at the
#' `start_period` time, which is/are the corresponding municipality(ies) at the
#' `end_period` time.
#'
#' @param start_period Start of requested period
#' @param end_period End of requested period
#' @param include_unmodified Include municipalities that have not undergone any changes
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
#' get_correspondances(start_period = "2024-01-01", end_period = "2024-08-01")
#' }
#'
get_correspondances <- function(
    start_period = NULL,
    end_period = NULL,
    include_unmodified = NULL,
    include_territory_exchange = NULL,
    name_repair = "unique"
){
  httr2::request(base_url = "https://sms.bfs.admin.ch/") %>%
    httr2::req_url_path_append("WcfBFSSpecificService.svc/AnonymousRest/communes/correspondances") %>%
    httr2::req_url_query(startPeriod = format(as.Date(start_period), "%d-%m-%Y"),
                         endPeriod = format(as.Date(end_period), "%d-%m-%Y"),
                         includeUnmodified = include_unmodified,
                         includeTerritoryExchange = include_territory_exchange) %>%
    httr2::req_retry(max_tries = 3, max_seconds = 10) %>%
    httr2::req_perform() %>%
    httr2::resp_body_raw() %>%
    readr::read_csv(name_repair = name_repair, show_col_types = FALSE)
}
