#' @title Extracting data frames from `{ggstatsplot}` plots
#'
#' @details
#'
#' This is a convenience function to extract data frames with statistical details
#' that are used to create expressions displayed in `{ggstatsplot}` plots as
#' subtitle, caption, etc. Note that all of this analysis is carried out by
#' the `{statsExpressions}` [package](https://indrajeetpatil.github.io/statsExpressions/).
#'
#' The only exception is the `ggcorrmat()` function. But, if a data frame is
#' what you want, you shouldn't be using `ggcorrmat()` anyway. You can use
#' `correlation::correlation()` function which provides tidy data frames by
#' default.
#'
#' @return
#'
#' A list of tibbles containing summaries of various statistical analyses.
#' The exact details included will depend on the function.
#'
#' @param p A plot from `{ggstatsplot}` package
#' @param ... Ignored
#'
#' @examplesIf requireNamespace("PMCMRplus", quietly = TRUE)
#' \donttest{
#' set.seed(123)
#' library(ggstatsplot)
#'
#' # non-grouped function -----------------------------
#'
#' # in case of group comparisons
#' p <- ggbetweenstats(mtcars, cyl, mpg)
#' extract_stats(p)
#'
#' # the exact details depend on the function
#' extract_stats(ggbarstats(mtcars, cyl, am))
#'
#' # grouped function -----------------------------
#' p <- grouped_ggbarstats(
#'   Titanic_full,
#'   x = Survived,
#'   y = Sex,
#'   grouping.var = Age
#' )
#'
#' extract_stats(p[[1L]])
#' extract_stats(p[[2L]])
#' }
#' @export
extract_stats <- function(p, ...) {
  list(
    subtitle_data             = tryCatch(p$plot_env$subtitle_df, error = function(e) NULL),
    caption_data              = tryCatch(p$plot_env$caption_df, error = function(e) NULL),
    pairwise_comparisons_data = tryCatch(p$plot_env$mpc_df, error = function(e) NULL),
    descriptive_data          = tryCatch(p$plot_env$descriptive_df, error = function(e) NULL),
    one_sample_data           = tryCatch(p$plot_env$onesample_df, error = function(e) NULL),
    tidy_data                 = tryCatch(p$plot_env$tidy_df, error = function(e) NULL),
    glance_data               = tryCatch(p$plot_env$glance_df, error = function(e) NULL)
  )
}

#' @noRd
.eval_f <- function(.f, ...) {
  tryCatch(
    suppressWarnings(suppressMessages(exec(.f, ...))),
    error = function(e) NULL
  )
}
