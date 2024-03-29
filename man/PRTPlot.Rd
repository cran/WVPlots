% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PRTPlot.R
\name{PRTPlot}
\alias{PRTPlot}
\title{Plot Precision-Recall or Enrichment-Recall as a function of threshold.}
\usage{
PRTPlot(
  frame,
  predVar,
  truthVar,
  truthTarget,
  title,
  ...,
  plotvars = c("precision", "recall"),
  thresholdrange = c(-Inf, Inf),
  linecolor = "black"
)
}
\arguments{
\item{frame}{data frame to get values from}

\item{predVar}{name of the column of predicted scores}

\item{truthVar}{name of the column of actual outcomes in frame}

\item{truthTarget}{value we consider to be positive}

\item{title}{title to place on plot}

\item{...}{no unnamed argument, added to force named binding of later arguments.}

\item{plotvars}{variables to plot, must be at least one of the measures listed below. Defaults to c("precision", "recall")}

\item{thresholdrange}{range of thresholds to plot.}

\item{linecolor}{line color for the plot}
}
\description{
Plot classifier performance metrics as a function of threshold.
}
\details{
For a classifier, the precision is what fraction of predicted positives
are true positives; the recall is what fraction of true positives the
classifier finds, and the enrichment is the ratio of classifier precision to
the average rate of positives. Plotting precision-recall or enrichment-recall
as a function of classifier score helps identify a score threshold that achieves
an acceptable tradeoff between precision and recall, or enrichment and recall.

In addition to precision/recall, \code{PRTPlot} can plot a number of other metrics:

\itemize{
  \item{precision: fraction of predicted positives that are true positives}
  \item{recall: fraction of true positives that were predicted to be true}
  \item{enrichment: ratio of classifier precision to prevalence of positive class}
  \item{sensitivity: the same as recall (also known as the true positive rate)}
  \item{specificity: fraction of true negatives to all negatives (or 1 - false_positive_rate)}
  \item{false_positive_rate: fraction of negatives predicted to be true over all negatives}
}

For example, plotting sensitivity/false_positive_rate as functions of threshold will "unroll" an ROC Plot.

Plots are in a single column, in the order specified by \code{plotvars}.
}
\examples{

if (requireNamespace('data.table', quietly = TRUE)) {
	# don't multi-thread during CRAN checks
		data.table::setDTthreads(1)
}

df <- iris
df$isVersicolor <- with(df, Species=='versicolor')
model = glm(isVersicolor ~ Petal.Length + Petal.Width + Sepal.Length + Sepal.Width,
            data=df, family=binomial)
df$pred = predict(model, newdata=df, type="response")

WVPlots::PRTPlot(df, "pred", "isVersicolor", TRUE, title="Example Precision-Recall threshold plot")

if (FALSE) {
WVPlots::PRTPlot(df, "pred", "isVersicolor", TRUE,
                 plotvars = c("sensitivity", "specificity", "false_positive_rate"),
                 title="Sensitivity/specificity/FPR as functions of threshold")
}

}
\seealso{
\code{\link{ThresholdPlot}}, \code{\link{ROCPlot}}
}
