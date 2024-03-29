% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ShadowPlot.R
\name{ShadowPlot}
\alias{ShadowPlot}
\title{Plot a Shadow Bar Plot}
\usage{
ShadowPlot(
  frm,
  condvar,
  refinevar,
  title,
  ...,
  monochrome = TRUE,
  palette = "Dark2",
  fillcolor = "darkblue",
  ncol = 1
)
}
\arguments{
\item{frm}{data frame to get values from.}

\item{condvar}{name of the primary conditioning variable (a categorical variable, controls x-axis).}

\item{refinevar}{name of the second or refining conditioning variable (also a categorical variable, controls faceting).}

\item{title}{title to place on plot.}

\item{...}{no unnamed argument, added to force named binding of later arguments.}

\item{monochrome}{logical: if TRUE, all facets filled with same color}

\item{palette}{character: if monochrome==FALSE, name of brewer color palette (can be NULL)}

\item{fillcolor}{character: if monochrome==TRUE, name of fill color for bars}

\item{ncol}{numeric: number of columns in facet_wrap.}
}
\value{
a ggplot2 bar chart counting examples grouped by condvar, faceted by refinevar.
}
\description{
Plot a bar chart of row counts conditioned on the categorical variable \code{condvar},
faceted on a second categorical variable, \code{refinevar}. Each faceted plot
also shows a "shadow plot" of the totals conditioned on \code{condvar} alone.
}
\details{
This plot enables comparisons of subpopulation totals across both
\code{condvar} and \code{refinevar} simultaneously.

By default, the facet plots are arranged in a single column. This can be changed
with the optional \code{ncol} argument.

If \code{palette} is NULL, and \code{monochrome} is FALSE, plot colors will be chosen from the default ggplot2 palette. Setting \code{palette} to NULL
allows the user to choose a non-Brewer palette, for example with \code{\link[ggplot2:scale_manual]{scale_fill_manual}}.
For consistency with previous releases, \code{ShadowPlot} defaults to \code{monochrome = TRUE}, while
\code{\link{ShadowHist}} defaults to \code{monochrome = FALSE}.

Please see here for some interesting discussion \url{https://drsimonj.svbtle.com/plotting-background-data-for-groups-with-ggplot2}.
}
\examples{

if (requireNamespace('data.table', quietly = TRUE)) {
	# don't multi-thread during CRAN checks
		data.table::setDTthreads(1)
}

ShadowPlot(mtcars, "carb", "cyl",
           title = "Number of example cars by carb and cyl counts")

if (FALSE) {
# colorcode the facets
ShadowPlot(mtcars, "carb", "cyl",
           monochrome = FALSE,
           title = "Number of example cars by carb and cyl counts")
}

}
