
<!-- README.md is generated from README.Rmd. Please edit that file -->

# swissMunicipalities

<!-- badges: start -->

[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://github.com/swissStatsR/swissMunicipalities/)
[![R-CMD-check](https://github.com/SwissStatsR/swissMunicipalities/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/SwissStatsR/swissMunicipalities/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**swissMunicipalities** gives access to official historicized lists of
municipalities of Switzerland using the official [REST API of the Swiss
Federal Statistical
Office](https://www.bfs.admin.ch/bfs/de/home/dienstleistungen/forschung/api/api-gemeinde.html).

More information about the API can be found
[here](https://www.bfs.admin.ch/bfs/de/home/dienstleistungen/forschung/api/api-gemeinde.html).

## Installation

You can install the development version of swissMunicipalities like so:

``` r
library(remotes)

remotes::install_github("SwissStatsR/swissMunicipalities")
```

## Get historicized lists of Swiss municipalities

``` r
library(swissMunicipalities)
```

You can get a “snapshot” using `get_snapshots()` that exist for at least
part of the specified period (or the specified day when `start_period` =
`end_period`).

By default, the FSO number is returned. To get the historicized ID, add
`hist_id = TRUE` in the `get_snapshots()` function.

``` r
snapshot <- get_snapshots(start_period = "2024-01-01", end_period = "2024-08-01")

snapshot
```

    ## # A tibble: 2,302 × 34
    ##    Identi…¹ Valid…² ValidTo Level Parent Name_en Name_fr Name_de Name_it ABBRE…³
    ##       <dbl> <chr>   <chr>   <dbl>  <dbl> <chr>   <chr>   <chr>   <chr>   <chr>  
    ##  1        1 12.09.… <NA>        1     NA Zürich  Zürich  Zürich  Zürich  ZH     
    ##  2    10053 12.09.… <NA>        2      1 Bezirk… Bezirk… Bezirk… Bezirk… Affolt…
    ##  3    10575 12.09.… <NA>        3  10053 Stalli… Stalli… Stalli… Stalli… <NA>   
    ##  4    11742 12.09.… <NA>        3  10053 Affolt… Affolt… Affolt… Affolt… <NA>   
    ##  5    11801 12.09.… <NA>        3  10053 Bonste… Bonste… Bonste… Bonste… <NA>   
    ##  6    11992 01.01.… <NA>        3  10053 Hausen… Hausen… Hausen… Hausen… <NA>   
    ##  7    12249 12.09.… <NA>        3  10053 Heding… Heding… Heding… Heding… <NA>   
    ##  8    12433 12.09.… <NA>        3  10053 Mettme… Mettme… Mettme… Mettme… <NA>   
    ##  9    12497 12.09.… <NA>        3  10053 Obfeld… Obfeld… Obfeld… Obfeld… <NA>   
    ## 10    12671 01.01.… <NA>        3  10053 Kappel… Kappel… Kappel… Kappel… <NA>   
    ## # … with 2,292 more rows, 24 more variables: ABBREV_1_Text_fr <chr>,
    ## #   ABBREV_1_Text_de <chr>, ABBREV_1_Text_it <chr>, ABBREV_1_Text <chr>,
    ## #   CODE_OFS_1_Text_en <dbl>, CODE_OFS_1_Text_fr <dbl>,
    ## #   CODE_OFS_1_Text_de <dbl>, CODE_OFS_1_Text_it <dbl>, CODE_OFS_1_Text <dbl>,
    ## #   INSCRIPTION_1_Text_en <dbl>, INSCRIPTION_1_Text_fr <dbl>,
    ## #   INSCRIPTION_1_Text_de <dbl>, INSCRIPTION_1_Text_it <dbl>,
    ## #   INSCRIPTION_1_Text <dbl>, RADIATION_1_Text_en <dbl>, …

> :information_source: **When using `start_period` and `end_period`
> arguments, the date should be in format “yyyy-mm-dd” (for example
> “2024-08-01”).**

Using the `Level` column, you can extract the existing list of cantons
(Level 1), districts (Level 2) and municipalities (Level 3), and even
join them to consolidate the municipality dataset.

``` r
library(dplyr) # just for data wrangling examples

# municipality in German
municipalities <- snapshot |> 
  filter(Level == 3) |>
  select(Code_municipality_de = CODE_OFS_1_Text_de, Identifier_municipality = Identifier, Name_de_municipality = Name_de, Parent_municipality = Parent)

# district in German
districts <- snapshot |> 
  filter(Level == 2) |>
  select(Code_district_de = CODE_OFS_1_Text_de, Identifier_district = Identifier, Name_de_district = Name_de, Parent_district = Parent)

# canton in German
cantons <- snapshot |> 
  filter(Level == 1) |>
  select(Code_canton_de = CODE_OFS_1_Text_de, Identifier_canton = Identifier, Name_de_canton = Name_de)

# consolidate municipality data with districts and cantons levels
municipalities_consolidated <- municipalities |>
  inner_join(districts, by = join_by(Parent_municipality == Identifier_district)) |>
  inner_join(cantons, by = join_by(Parent_district == Identifier_canton)) |>
  rename(Identifier_district = Parent_municipality, Identifier_canton = Parent_district) |>
  arrange(Identifier_municipality, Identifier_district)

# get all municipalities of St. Gallen for the given period
municipalities_consolidated |>
  filter(Name_de_canton == "St. Gallen")
```

    ## # A tibble: 75 × 9
    ##    Code_munici…¹ Ident…² Name_…³ Ident…⁴ Code_…⁵ Name_…⁶ Ident…⁷ Code_…⁸ Name_…⁹
    ##            <dbl>   <dbl> <chr>     <dbl>   <dbl> <chr>     <dbl>   <dbl> <chr>  
    ##  1          3201   14378 Häggen…   10266    1721 Wahlkr…      17      NA St. Ga…
    ##  2          3202   14379 Muolen    10266    1721 Wahlkr…      17      NA St. Ga…
    ##  3          3203   14380 St. Ga…   10266    1721 Wahlkr…      17      NA St. Ga…
    ##  4          3204   14381 Witten…   10266    1721 Wahlkr…      17      NA St. Ga…
    ##  5          3211   14382 Berg (…   10265    1722 Wahlkr…      17      NA St. Ga…
    ##  6          3212   14383 Eggers…   10266    1721 Wahlkr…      17      NA St. Ga…
    ##  7          3213   14384 Goldach   10265    1722 Wahlkr…      17      NA St. Ga…
    ##  8          3214   14385 Mörsch…   10265    1722 Wahlkr…      17      NA St. Ga…
    ##  9          3215   14386 Rorsch…   10265    1722 Wahlkr…      17      NA St. Ga…
    ## 10          3216   14387 Rorsch…   10265    1722 Wahlkr…      17      NA St. Ga…
    ## # … with 65 more rows, and abbreviated variable names ¹​Code_municipality_de,
    ## #   ²​Identifier_municipality, ³​Name_de_municipality, ⁴​Identifier_district,
    ## #   ⁵​Code_district_de, ⁶​Name_de_district, ⁷​Identifier_canton, ⁸​Code_canton_de,
    ## #   ⁹​Name_de_canton

Access all the mutation list which describes all changes related to
municipalities that occurred during the specified period.

To exclude records that only concern territory changes, use
`include_territory_exchange = FALSE`.

``` r
get_mutations(start_period = "2024-01-01", end_period = "2024-08-01", include_territory_exchange = FALSE)
```

    ## # A tibble: 6 × 14
    ##   MutationNumber Mutat…¹ Initi…² Initi…³ Initi…⁴ Initi…⁵ Initi…⁶ Initi…⁷ Termi…⁸
    ##            <dbl> <chr>     <dbl>   <dbl> <chr>     <dbl> <chr>     <dbl>   <dbl>
    ## 1           3983 01.01.…   15344     947 Zwiese…   10289 Verwal…      29   16651
    ## 2           3984 01.01.…   15376     993 Wangen…   10286 Verwal…      29   16652
    ## 3           3985 01.01.…   14067    2456 Lüters…   10100 Bezirk…      29   16653
    ## 4           3986 01.01.…   13320    6773 Beurne…   10226 Distri…      29   16654
    ## 5           3986 01.01.…   13322    6775 Bonfol    10226 Distri…      29   16654
    ## 6           3987 01.01.…   10886    4042 Turgi     10025 Bezirk…      29   16655
    ## # … with 5 more variables: TerminalCode <dbl>, TerminalName <chr>,
    ## #   TerminalParentHistoricalCode <dbl>, TerminalParentName <chr>,
    ## #   TerminalStep <dbl>, and abbreviated variable names ¹​MutationDate,
    ## #   ²​InitialHistoricalCode, ³​InitialCode, ⁴​InitialName,
    ## #   ⁵​InitialParentHistoricalCode, ⁶​InitialParentName, ⁷​InitialStep,
    ## #   ⁸​TerminalHistoricalCode

Get the municipality correspondences, which indicates for each
municipality existing at the `start_period` time, which is/are the
corresponding municipality(ies) at the `end_period` time.

To exclude districts and municipalities that have not undergone any
changes, add `include_unmodified = FALSE`.

``` r
get_correspondances(
  start_period = "2024-01-01", 
  end_period = "2024-08-01", 
  include_unmodified = FALSE, 
  include_territory_exchange = FALSE
)
```

    ## # A tibble: 2 × 12
    ##   InitialHisto…¹ Initi…² Initi…³ Initi…⁴ Initi…⁵ Initi…⁶ Termi…⁷ Termi…⁸ Termi…⁹
    ##            <dbl>   <dbl> <chr>     <dbl> <chr>     <dbl>   <dbl>   <dbl> <chr>  
    ## 1          12547      64 Nürens…   10081 Bezirk…      26   16657      64 Nürens…
    ## 2          12673      62 Kloten    10081 Bezirk…      26   16656      62 Kloten 
    ## # … with 3 more variables: TerminalParentHistoricalCode <dbl>,
    ## #   TerminalParentName <chr>, TerminalStep <dbl>, and abbreviated variable
    ## #   names ¹​InitialHistoricalCode, ²​InitialCode, ³​InitialName,
    ## #   ⁴​InitialParentHistoricalCode, ⁵​InitialParentName, ⁶​InitialStep,
    ## #   ⁷​TerminalHistoricalCode, ⁸​TerminalCode, ⁹​TerminalName

The geographical levels offer several classifications of municipalities
according to, for example, linguistic regions, agglomerations or even
the degree of urbanization.

By default, the FSO number is returned. To get the historicized ID, add
`hist_id = TRUE` in the `get_levels()` function. You can change the
`label_languages` between French (“fr”), German (“de”), Italian (“it”)
and English (“en”).

``` r
get_levels(start_period = "2024-01-01", end_period = "2024-08-01", label_languages = "de")
```

    ## # A tibble: 2,133 × 59
    ##    Identifier Name_de    CODE_…¹ HR_HG…² HR_HG…³ HR_HG…⁴ HR_HG…⁵ HR_AG…⁶ HR_AG…⁷
    ##         <dbl> <chr>        <dbl>   <dbl> <chr>     <dbl> <chr>     <dbl> <chr>  
    ##  1      10009 Villnache…    4122      19 Aargau    10023 Bezirk…       0 keine …
    ##  2      10078 Vionnaz       6158      23 Valais…   10013 Distri…       0 keine …
    ##  3      10157 Speicher      3023      15 Appenz…   10098 Bezirk…    3203 St. Ga…
    ##  4      10159 Zwischber…    6011      23 Valais…   10035 Bezirk…    6002 Brig –…
    ##  5      10162 Villars-s…    2228      10 Fribou…   10104 Distri…    2196 Fribou…
    ##  6      10165 Villarsel…    2230      10 Fribou…   10104 Distri…    2196 Fribou…
    ##  7      10242 Wila           181       1 Zürich    10076 Bezirk…       0 keine …
    ##  8      10268 Wil (ZH)        71       1 Zürich    10081 Bezirk…     261 Zürich 
    ##  9      10275 Wettingen     4045      19 Aargau    10025 Bezirk…    4021 Baden …
    ## 10      10277 Wetzikon …     121       1 Zürich    10079 Bezirk…     261 Zürich 
    ## # … with 2,123 more rows, 50 more variables: HR_AGGL2020 <dbl>,
    ## #   HR_AGGL2020_Name_de <chr>, HR_AGGLGK2012_L1 <dbl>,
    ## #   HR_AGGLGK2012_L1_Name_de <chr>, HR_AGGLGK2012_L2 <dbl>,
    ## #   HR_AGGLGK2012_L2_Name_de <chr>, HR_AGGLGK2020_L1 <dbl>,
    ## #   HR_AGGLGK2020_L1_Name_de <chr>, HR_AGGLGK2020_L2 <dbl>,
    ## #   HR_AGGLGK2020_L2_Name_de <chr>, HR_BAE2018_L1 <chr>,
    ## #   HR_BAE2018_L1_Name_de <chr>, HR_BAE2018_L2 <chr>, …

## Acknowledgements

This R package is inspired by
**[swissmuni](https://gitlab.com/rpkg.dev/swissmuni/)**. As
**swissmuni** is available only for the latest version of R and rely on
several R package dependencies which are not on CRAN, this R package
provides a simplified R wrapper of the API with minimal dependencies so
it can be used on older versions of R (R \>= 4.0).
