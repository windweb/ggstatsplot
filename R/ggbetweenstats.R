#' @title Box/Violin plots for between-subjects comparisons
#' @name ggbetweenstats
#'
#' @description
#'
#' A combination of box and violin plots along with jittered data points for
#' between-subjects designs with statistical details included in the plot as a
#' subtitle.
#'
#' @param plot.type Character describing the *type* of plot. Currently supported
#'   plots are `"box"` (for only boxplots), `"violin"` (for only violin plots),
#'   and `"boxviolin"` (for a combination of box and violin plots; default).
#' @param xlab Label for `x` axis variable. If `NULL` (default),
#'   variable name for `x` will be used.
#' @param ylab Labels for `y` axis variable. If `NULL` (default),
#'   variable name for `y` will be used.
#' @param pairwise.comparisons Logical that decides whether pairwise comparisons
#'   are to be displayed (default: `TRUE`). Please note that only
#'   **significant** comparisons will be shown by default. To change this
#'   behavior, select appropriate option with `pairwise.display` argument. The
#'   pairwise comparison dataframes are prepared using the
#'   `pairwise_comparisons` function. For more details
#'   about pairwise comparisons, see the documentation for that function.
#' @param p.adjust.method Adjustment method for *p*-values for multiple
#'   comparisons. Possible methods are: `"holm"` (default), `"hochberg"`,
#'   `"hommel"`, `"bonferroni"`, `"BH"`, `"BY"`, `"fdr"`, `"none"`.
#' @param pairwise.display Decides *which* pairwise comparisons to display.
#'   Available options are:
#'   - `"significant"` (abbreviation accepted: `"s"`)
#'   - `"non-significant"` (abbreviation accepted: `"ns"`)
#'   - `"all"`
#'
#'   You can use this argument to make sure that your plot is not uber-cluttered
#'   when you have multiple groups being compared and scores of pairwise
#'   comparisons being displayed.
#' @param bf.message Logical that decides whether to display Bayes Factor in
#'   favor of the *null* hypothesis. This argument is relevant only **for
#'   parametric test** (Default: `TRUE`).
#' @param results.subtitle Decides whether the results of statistical tests are
#'   to be displayed as a subtitle (Default: `TRUE`). If set to `FALSE`, only
#'   the plot will be returned.
#' @param title The text for the plot title.
#' @param subtitle The text for the plot subtitle. Will work only if
#'   `results.subtitle = FALSE`.
#' @param caption The text for the plot caption. This argument is relevant only
#'   if `bf.message = FALSE`.
#' @param outlier.color Default aesthetics for outliers (Default: `"black"`).
#' @param outlier.tagging Decides whether outliers should be tagged (Default:
#'   `FALSE`).
#' @param outlier.label Label to put on the outliers that have been tagged. This
#'   **can't** be the same as `x` argument.
#' @param outlier.shape Hiding the outliers can be achieved by setting
#'   `outlier.shape = NA`. Importantly, this does not remove the outliers,
#'   it only hides them, so the range calculated for the `y`-axis will be
#'   the same with outliers shown and outliers hidden.
#' @param outlier.label.args A list of additional aesthetic arguments to be
#'   passed to `ggrepel::geom_label_repel` for outlier label plotting.
#' @param outlier.coef Coefficient for outlier detection using Tukey's method.
#'   With Tukey's method, outliers are below (1st Quartile) or above (3rd
#'   Quartile) `outlier.coef` times the Inter-Quartile Range (IQR) (Default:
#'   `1.5`).
#' @param centrality.plotting Logical that decides whether centrality tendency
#'   measure is to be displayed as a point with a label (Default: `TRUE`).
#'   Function decides which central tendency measure to show depending on the
#'   `type` argument.
#'   - **mean** for parametric statistics
#'   - **median** for non-parametric statistics
#'   - **trimmed mean** for robust statistics
#'   - **MAP estimator** for Bayesian statistics
#'
#'   If you want default centrality parameter, you can specify this using
#'   `centrality.type` argument.
#' @param centrality.type Decides which centrality parameter is to be displayed.
#'   The default is to choose the same as `type` argument. You can specify this
#'   to be:
#'   - `"parameteric"` (for **mean**)
#'   - `"nonparametric"` (for **median**)
#'   - `robust` (for **trimmed mean**)
#'   - `bayes` (for **MAP estimator**)
#'
#'   Just as `type` argument, abbreviations are also accepted.
#' @param point.args A list of additional aesthetic arguments to be passed to
#'   the `geom_point` displaying the raw data.
#' @param violin.args A list of additional aesthetic arguments to be passed to
#'   the `geom_violin`.
#' @param ggplot.component A `ggplot` component to be added to the plot prepared
#'   by `{ggstatsplot}`. This argument is primarily helpful for `grouped_`
#'   variants of all primary functions. Default is `NULL`. The argument should
#'   be entered as a `{ggplot2}` function or a list of `{ggplot2}` functions.
#' @param package,palette Name of the package from which the given palette is to
#'   be extracted. The available palettes and packages can be checked by running
#'   `View(paletteer::palettes_d_names)`.
#' @param output Character that describes what is to be returned: can be
#'   `"plot"` (default) or `"subtitle"` or `"caption"`. Setting this to
#'   `"subtitle"` will return the expression containing statistical results. If
#'   you have set `results.subtitle = FALSE`, then this will return a `NULL`.
#'   Setting this to `"caption"` will return the expression containing details
#'   about Bayes Factor analysis, but valid only when `type = "parametric"` and
#'   `bf.message = TRUE`, otherwise this will return a `NULL`.
#' @param ... Currently ignored.
#' @inheritParams theme_ggstatsplot
#' @param centrality.point.args,centrality.label.args A list of additional aesthetic
#'   arguments to be passed to `geom_point` and
#'   `ggrepel::geom_label_repel` geoms, which are involved in mean plotting.
#' @param  ggsignif.args A list of additional aesthetic
#'   arguments to be passed to `ggsignif::geom_signif`.
#' @param ggtheme A `{ggplot2}` theme. Default value is
#'   `ggstatsplot::theme_ggstatsplot()`. Any of the `{ggplot2}` themes (e.g.,
#'   `theme_bw()`), or themes from extension packages are allowed (e.g.,
#'   `ggthemes::theme_fivethirtyeight()`, `hrbrthemes::theme_ipsum_ps()`, etc.).
#'   But note that sometimes these themes will remove some of the details that
#'   `{ggstatsplot}` plots typically contains. For example, if relevant,
#'   `ggbetweenstats()` shows details about multiple comparison test as a label
#'   on the secondary Y-axis. Some themes (e.g.
#'   `ggthemes::theme_fivethirtyeight()`) will remove the secondary Y-axis and
#'   thus the details as well.
#' @inheritParams statsExpressions::oneway_anova
#' @inheritParams statsExpressions::two_sample_test
#'
#' @inheritSection statsExpressions::centrality_description Centrality measures
#' @inheritSection statsExpressions::two_sample_test Two-sample tests
#' @inheritSection statsExpressions::oneway_anova One-way ANOVA
#' @inheritSection statsExpressions::pairwise_comparisons Pairwise comparison tests
#'
#' @seealso \code{\link{grouped_ggbetweenstats}}, \code{\link{ggwithinstats}},
#'  \code{\link{grouped_ggwithinstats}}
#'
#' @details For details, see:
#' <https://indrajeetpatil.github.io/ggstatsplot/articles/web_only/ggbetweenstats.html>
#'
#' @examples
#' \donttest{
#' if (require("PMCMRplus")) {
#'   # to get reproducible results from bootstrapping
#'   set.seed(123)
#'   library(ggstatsplot)
#'
#'   # simple function call with the defaults
#'   ggbetweenstats(mtcars, am, mpg)
#'
#'   # more detailed function call
#'   ggbetweenstats(
#'     data = morley,
#'     x = Expt,
#'     y = Speed,
#'     type = "robust",
#'     xlab = "The experiment number",
#'     ylab = "Speed-of-light measurement",
#'     pairwise.comparisons = TRUE,
#'     p.adjust.method = "fdr",
#'     outlier.tagging = TRUE,
#'     outlier.label = Run
#'   )
#' }
#' }
#' @export
ggbetweenstats <- function(data,
                           x,
                           y,
                           plot.type = "boxviolin",
                           type = "parametric",
                           pairwise.comparisons = TRUE,
                           pairwise.display = "significant",
                           p.adjust.method = "holm",
                           effsize.type = "unbiased",
                           bf.prior = 0.707,
                           bf.message = TRUE,
                           results.subtitle = TRUE,
                           xlab = NULL,
                           ylab = NULL,
                           caption = NULL,
                           title = NULL,
                           subtitle = NULL,
                           k = 2L,
                           var.equal = FALSE,
                           conf.level = 0.95,
                           nboot = 100L,
                           tr = 0.2,
                           centrality.plotting = TRUE,
                           centrality.type = type,
                           centrality.point.args = list(
                             size = 5,
                             color = "darkred"
                           ),
                           centrality.label.args = list(
                             size = 3,
                             nudge_x = 0.4,
                             segment.linetype = 4,
                             min.segment.length = 0
                           ),
                           outlier.tagging = FALSE,
                           outlier.label = NULL,
                           outlier.coef = 1.5,
                           outlier.shape = 19,
                           outlier.color = "black",
                           outlier.label.args = list(size = 3),
                           point.args = list(
                             position = ggplot2::position_jitterdodge(dodge.width = 0.60),
                             alpha = 0.4,
                             size = 3,
                             stroke = 0
                           ),
                           violin.args = list(
                             width = 0.5,
                             alpha = 0.2
                           ),
                           ggsignif.args = list(
                             textsize = 3,
                             tip_length = 0.01
                           ),
                           ggtheme = ggstatsplot::theme_ggstatsplot(),
                           package = "RColorBrewer",
                           palette = "Dark2",
                           ggplot.component = NULL,
                           output = "plot",
                           ...) {
  # data -----------------------------------

  # convert entered stats type to a standard notation
  type <- stats_type_switch(type)

  # make sure both quoted and unquoted arguments are allowed
  c(x, y) %<-% c(ensym(x), ensym(y))
  outlier.label <- if (!quo_is_null(enquo(outlier.label))) ensym(outlier.label)

  # creating a dataframe
  data %<>%
    select({{ x }}, {{ y }}, outlier.label = {{ outlier.label }}) %>%
    tidyr::drop_na(.) %>%
    mutate({{ x }} := droplevels(as.factor({{ x }})))

  # if outlier.label column is not present, just use the values from `y` column
  if (!"outlier.label" %in% names(data)) data %<>% mutate(outlier.label = {{ y }})

  # add a logical column indicating whether a point is or is not an outlier
  data %<>%
    .outlier_df(
      x             = {{ x }},
      y             = {{ y }},
      outlier.coef  = outlier.coef,
      outlier.label = outlier.label
    )

  # statistical analysis ------------------------------------------

  # test to run; depends on the no. of levels of the independent variable
  test <- ifelse(nlevels(data %>% pull({{ x }})) < 3, "t", "anova")

  if (results.subtitle) {
    # relevant arguments for statistical tests
    .f.args <- list(
      data         = data,
      x            = as_string(x),
      y            = as_string(y),
      effsize.type = effsize.type,
      conf.level   = conf.level,
      var.equal    = var.equal,
      k            = k,
      tr           = tr,
      paired       = FALSE,
      bf.prior     = bf.prior,
      nboot        = nboot
    )

    .f <- .f_switch(test)
    subtitle_df <- .eval_f(.f, !!!.f.args, type = type)
    subtitle <- if (!is.null(subtitle_df)) subtitle_df$expression[[1]]

    # preparing the Bayes factor message
    if (type == "parametric" && bf.message) {
      caption_df <- .eval_f(.f, !!!.f.args, type = "bayes")
      caption <- if (!is.null(caption_df)) caption_df$expression[[1]]
    }
  }

  # return early if anything other than plot
  if (output != "plot") {
    return(switch(output,
      "caption" = caption,
      subtitle
    ))
  }

  # plot -----------------------------------

  # first add only the points which are *not* outliers
  plot <- ggplot(data, mapping = aes({{ x }}, {{ y }})) +
    exec(geom_point, data = ~ filter(.x, !isanoutlier), aes(color = {{ x }}), !!!point.args)

  # if outliers are not being tagged, then add the points that were previously left out
  if (isFALSE(outlier.tagging)) {
    plot <- plot +
      exec(geom_point, data = ~ filter(.x, isanoutlier), aes(color = {{ x }}), !!!point.args)
  }

  # if outlier tagging is happening, decide how those points should be displayed
  if (plot.type == "violin" && isTRUE(outlier.tagging)) {
    plot <- plot +
      # add all outliers in
      geom_point(
        data   = ~ filter(.x, isanoutlier),
        size   = 3,
        stroke = 0,
        alpha  = 0.7,
        color  = outlier.color,
        shape  = outlier.shape
      )
  }

  # adding a boxplot
  if (plot.type %in% c("box", "boxviolin")) {
    if (isTRUE(outlier.tagging)) {
      .f <- stat_boxplot
      outlier_list <- list(
        outlier.shape = outlier.shape,
        outlier.size = 3,
        outlier.alpha = 0.7,
        outlier.color = outlier.color
      )
    } else {
      .f <- geom_boxplot
      outlier_list <- list(outlier.shape = NA, position = position_dodge(width = NULL))
    }

    # add a boxplot
    suppressWarnings(plot <- plot +
      exec(
        .fn   = .f,
        width = 0.3,
        alpha = 0.2,
        geom  = "boxplot",
        coef  = outlier.coef,
        !!!outlier_list
      ))
  }

  # add violin geom
  if (plot.type %in% c("violin", "boxviolin")) {
    plot <- plot + exec(geom_violin, !!!violin.args)
  }

  # outlier labeling -----------------------------

  # If `outlier.label` is not provided, outlier labels will just be values of
  # the `y` vector. If the outlier tag has been provided, just use the dataframe
  # already created.

  # applying the labels to tagged outliers with `ggrepel`
  if (isTRUE(outlier.tagging)) {
    plot <- plot +
      exec(
        .fn                = ggrepel::geom_label_repel,
        data               = ~ filter(.x, isanoutlier),
        mapping            = aes(x = {{ x }}, y = {{ y }}, label = outlier.label),
        min.segment.length = 0,
        inherit.aes        = FALSE,
        !!!outlier.label.args
      )
  }

  # centrality tagging -------------------------------------

  # add labels for centrality measure
  if (isTRUE(centrality.plotting)) {
    plot <- .centrality_ggrepel(
      plot                  = plot,
      data                  = data,
      x                     = {{ x }},
      y                     = {{ y }},
      k                     = k,
      type                  = stats_type_switch(centrality.type),
      tr                    = tr,
      centrality.point.args = centrality.point.args,
      centrality.label.args = centrality.label.args
    )
  }

  # ggsignif labels -------------------------------------

  if (isTRUE(pairwise.comparisons) && test == "anova") {
    # creating dataframe with pairwise comparison results
    mpc_df <- pairwise_comparisons(
      data            = data,
      x               = {{ x }},
      y               = {{ y }},
      type            = type,
      tr              = tr,
      paired          = FALSE,
      var.equal       = var.equal,
      p.adjust.method = p.adjust.method,
      k               = k
    )

    # adding the layer for pairwise comparisons
    plot <- .ggsignif_adder(
      plot             = plot,
      mpc_df           = mpc_df,
      data             = data,
      x                = {{ x }},
      y                = {{ y }},
      pairwise.display = pairwise.display,
      ggsignif.args    = ggsignif.args
    )

    # preparing the secondary label axis to give pairwise comparisons test details
    seclabel <- .pairwise_seclabel(
      unique(mpc_df$test),
      ifelse(type == "bayes", "all", pairwise.display)
    )
  } else {
    seclabel <- NULL
  }

  # annotations ------------------------

  .aesthetic_addon(
    plot             = plot,
    x                = data %>% pull({{ x }}),
    xlab             = xlab %||% as_name(x),
    ylab             = ylab %||% as_name(y),
    title            = title,
    subtitle         = subtitle,
    caption          = caption,
    seclabel         = seclabel,
    ggtheme          = ggtheme,
    package          = package,
    palette          = palette,
    ggplot.component = ggplot.component
  )
}


#' @title Violin plots for group or condition comparisons in between-subjects
#'   designs repeated across all levels of a grouping variable.
#' @name grouped_ggbetweenstats
#'
#' @description
#'
#' Helper function for `ggstatsplot::ggbetweenstats` to apply this function
#' across multiple levels of a given factor and combining the resulting plots
#' using `ggstatsplot::combine_plots`.
#'
#' @inheritParams ggbetweenstats
#' @inheritParams .grouped_list
#' @inheritParams combine_plots
#' @inheritDotParams ggbetweenstats -title
#'
#' @seealso \code{\link{ggbetweenstats}}, \code{\link{ggwithinstats}},
#'  \code{\link{grouped_ggwithinstats}}
#'
#' @inherit ggbetweenstats return references
#'
#' @examples
#' \donttest{
#' if (require("PMCMRplus")) {
#'   # to get reproducible results from bootstrapping
#'   set.seed(123)
#'   library(ggstatsplot)
#'   library(dplyr, warn.conflicts = FALSE)
#'   library(ggplot2)
#'
#'   # the most basic function call
#'   grouped_ggbetweenstats(
#'     data = filter(ggplot2::mpg, drv != "4"),
#'     x = year,
#'     y = hwy,
#'     grouping.var = drv
#'   )
#'
#'   # modifying individual plots using `ggplot.component` argument
#'   grouped_ggbetweenstats(
#'     data = filter(
#'       movies_long,
#'       genre %in% c("Action", "Comedy"),
#'       mpaa %in% c("R", "PG")
#'     ),
#'     x = genre,
#'     y = rating,
#'     grouping.var = mpaa,
#'     ggplot.component = scale_y_continuous(
#'       breaks = seq(1, 9, 1),
#'       limits = (c(1, 9))
#'     )
#'   )
#' }
#' }
#' @export
grouped_ggbetweenstats <- function(data,
                                   ...,
                                   grouping.var,
                                   output = "plot",
                                   plotgrid.args = list(),
                                   annotation.args = list()) {
  # creating a dataframe
  data %<>% .grouped_list(grouping.var = {{ grouping.var }})

  # creating a list of return objects
  p_ls <- purrr::pmap(
    .l = list(data = data, title = names(data), output = output),
    .f = ggstatsplot::ggbetweenstats,
    ...
  )

  # combining the list of plots into a single plot
  if (output == "plot") p_ls <- combine_plots(p_ls, plotgrid.args, annotation.args)

  p_ls
}
