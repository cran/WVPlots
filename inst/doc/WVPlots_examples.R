## ----echo=FALSE---------------------------------------------------------------
knitr::opts_chunk$set(fig.width=6, fig.height=6)
if (requireNamespace('data.table', quietly = TRUE)) {
	# don't multi-thread during CRAN checks
	data.table::setDTthreads(1)
}

## -----------------------------------------------------------------------------
set.seed(34903490)
x = rnorm(50)
y = 0.5*x^2 + 2*x + rnorm(length(x))
frm = data.frame(
  x = x,
  y = y,
  yC = y>=as.numeric(quantile(y,probs=0.8)),
  stringsAsFactors = FALSE)
frm$absY <- abs(frm$y)
frm$posY = frm$y > 0

## -----------------------------------------------------------------------------
WVPlots::ScatterHist(frm, "x", "y", title="Example Fit")

## -----------------------------------------------------------------------------
WVPlots::ScatterHist(frm, "x", "y", smoothmethod="lm", 
                     title="Example Linear Fit", estimate_sig = TRUE)

## -----------------------------------------------------------------------------
WVPlots::ScatterHist(frm, "x", "y", smoothmethod="identity", 
                     title="Example Relation Plot", estimate_sig = TRUE)

## -----------------------------------------------------------------------------
set.seed(34903490)
fmScatterHistC = data.frame(
  x=rnorm(50),
  y=rnorm(50),
  stringsAsFactors = FALSE)
fmScatterHistC$cat <- fmScatterHistC$x+fmScatterHistC$y>0
WVPlots::ScatterHistC(fmScatterHistC, "x", "y", "cat", title="Example Conditional Distribution")

## -----------------------------------------------------------------------------
set.seed(34903490)
frmScatterHistN = data.frame(
  x=rnorm(50),
  y=rnorm(50),
  stringsAsFactors = FALSE)
frmScatterHistN$z <- frmScatterHistN$x+frmScatterHistN$y
WVPlots::ScatterHistN(frmScatterHistN, "x", "y", "z", title="Example Joint Distribution")

## -----------------------------------------------------------------------------
WVPlots::BinaryYScatterPlot(frm, "x", "posY", use_glm=FALSE,
                            title="Example 'Probability of Y' Plot (ggplot2 smoothing)")

WVPlots::BinaryYScatterPlot(frm, "x", "posY", use_glm=TRUE, 
                            title="Example 'Probability of Y' Plot (GLM smoothing)")

## -----------------------------------------------------------------------------
if(requireNamespace("hexbin", quietly = TRUE)) {
  set.seed(5353636)
  
  df = rbind(data.frame(x=rnorm(1000, mean = 1), 
                        y=rnorm(1000, mean = 1, sd = 0.5 ),
                        stringsAsFactors = FALSE),
             data.frame(x = rnorm(1000, mean = -1, sd = 0.5), 
                        y = rnorm(1000, mean = -1, sd = 0.5),
                        stringsAsFactors = FALSE),
             stringsAsFactors = FALSE)
  
  print(WVPlots::HexBinPlot(df, "x", "y", "Two gaussians"))
}


## -----------------------------------------------------------------------------
set.seed(34903490)
y = abs(rnorm(20)) + 0.1
x = abs(y + 0.5*rnorm(20))

frm = data.frame(
  model=x, 
  value=y,
  stringsAsFactors = FALSE)

frm$costs=1
frm$costs[1]=5
frm$rate = with(frm, value/costs)

frm$isValuable = (frm$value >= as.numeric(quantile(frm$value, probs=0.8)))


## -----------------------------------------------------------------------------
WVPlots::GainCurvePlot(frm, "model", "value", title="Example Continuous Gain Curve")

## -----------------------------------------------------------------------------

gainx = 0.10  # get the top 10% most valuable points as sorted by the model

# make a function to calculate the label for the annotated point
labelfun = function(gx, gy) {
  pctx = gx*100
  pcty = gy*100
  
  paste("The top ", pctx, "% most valuable points by the model\n",
        "are ", pcty, "% of total actual value", sep='')
}

WVPlots::GainCurvePlotWithNotation(frm, "model", "value", 
                                   title="Example Gain Curve with annotation", 
                          gainx=gainx,labelfun=labelfun) 



## -----------------------------------------------------------------------------
WVPlots::GainCurvePlotC(frm, "model", "costs", "value", title="Example Continuous Gain CurveC")

## -----------------------------------------------------------------------------
set.seed(34903490)

# data with two different regimes of behavior
frm <- rbind(
  data.frame(
    model = rnorm(1000),
    isValuable = sample(c(TRUE, FALSE), prob = c(0.02, 0.98), size = 1000, replace = TRUE)),
  data.frame(
    model = rnorm(200) + 5,
    isValuable = sample(c(TRUE, FALSE), size = 200, replace = TRUE))
)

WVPlots::ROCPlot(frm, "model", "isValuable", TRUE, title="Example ROC plot")

## -----------------------------------------------------------------------------
set.seed(34903490)

x1 = rnorm(50)
x2 = rnorm(length(x1))
y = 0.2*x2^2 + 0.5*x2 + x1 + rnorm(length(x1))
frmP = data.frame(
  x1=x1,
  x2=x2,
  yC = y>=as.numeric(quantile(y,probs=0.8)),
  stringsAsFactors = FALSE)
# WVPlots::ROCPlot(frmP, "x1", "yC", TRUE, title="Example ROC plot")
# WVPlots::ROCPlot(frmP, "x2", "yC", TRUE, title="Example ROC plot")
WVPlots::ROCPlotPair(frmP, "x1", "x2", "yC", TRUE, title="Example ROC pair plot")

## -----------------------------------------------------------------------------
set.seed(2342458)

make_data <- function(nrows) {
    d <- data.frame(x = rnorm(nrows))
    d['y'] = sin(d['x']) + 0.25*rnorm(n = nrows)
    d['x2'] = rnorm(n = nrows)
    d['yc'] = d[['y']]>0.5
    return(d)
}


training <- make_data(500)
test <- make_data(200)

model <- glm(yc ~ x + x2, data=training, family=binomial)

training$pred <- predict(model, newdata=training, type="response")
test$pred <- predict(model, newdata=test, type="response")

WVPlots::ROCPlotPair2(nm1 = "Training", # model 1
                      frame1 = training,
                      xvar1 = "pred",  truthVar1 = "yc", truthTarget1 = TRUE,
                      nm2 ="Test", # model 2
                      frame2 = test,
                      xvar2 = "pred", truthVar2 = "yc", truthTarget2 = TRUE,
                      title = "Model performance, training vs test",
                      estimate_sig = FALSE)

## -----------------------------------------------------------------------------
set.seed(34903490)
x1 = rnorm(50)
x2 = rnorm(length(x1))
x3 = rnorm(length(x1))
y = 0.2*x2^2 + 0.5*x2 + x1 + rnorm(length(x1))
frm_m = data.frame(
   x1 = x1,
   x2 = x2,
   x3 = x3,
   yC = y >= as.numeric(quantile(y,probs=0.8)))
WVPlots::ROCPlotPairList(
   frame = frm_m,
   xvar_names = c("x1", "x2", "x3"),
   truthVar = "yC", truthTarget = TRUE,
   title = "Example ROC list plot")

## -----------------------------------------------------------------------------
WVPlots::PRTPlot(frm, "model", "isValuable", TRUE, title="Example Precision-Recall plot")

## -----------------------------------------------------------------------------
# replicate PRTPlot. Looks a little different because ThresholdPlot does different smoothing
WVPlots::ThresholdPlot(frm, "model", "isValuable", title="Reproduce PRTPlot",
              truth_target=TRUE, # default
              metrics = c("precision", "recall"))

# default: sensitivity/specificity
WVPlots::ThresholdPlot(frm, "model", "isValuable", 
                       title="Sensitivity and Specificity as a Function of Threshold")


## -----------------------------------------------------------------------------
WVPlots::ThresholdPlot(frm, "model", "isValuable", title="ROC 'unrolled'",
              metrics = c("true_positive_rate", "false_positive_rate"))

## -----------------------------------------------------------------------------
WVPlots::DoubleDensityPlot(frm, "model", "isValuable", title="Example double density plot")

## -----------------------------------------------------------------------------
WVPlots::DoubleHistogramPlot(frm, "model", "isValuable", title="Example double histogram plot")

## -----------------------------------------------------------------------------
set.seed(34903490)

# discrete variable: letters of the alphabet
# frequencies of letters in English
# source: http://en.algoritmy.net/article/40379/Letter-frequency-English
letterFreqs = c(8.167, 1.492, 2.782, 4.253, 12.702, 2.228,
                2.015, 6.094, 6.966, 0.153, 0.772, 4.025, 2.406, 6.749, 7.507, 1.929,
                0.095, 5.987, 6.327, 9.056, 2.758, 0.978, 2.360, 0.150, 1.974, 0.074)
letterFreqs = letterFreqs/100
letterFrame = data.frame(
  letter = letters, 
  freq=letterFreqs, 
  stringsAsFactors = FALSE)

# now let's generate letters according to their letter frequencies
N = 1000
randomDraws = data.frame(
  draw=1:N, 
  letter=sample(letterFrame$letter, size=N, replace=TRUE, prob=letterFrame$freq), 
  stringsAsFactors = FALSE)

WVPlots::ClevelandDotPlot(randomDraws, "letter", title = "Example Cleveland-style dot plot")
WVPlots::ClevelandDotPlot(randomDraws, "letter", limit_n = 10,  title = "Top 10 most frequent letters")
WVPlots::ClevelandDotPlot(randomDraws, "letter", sort=0, title="Example Cleveland-style dot plot, unsorted")
WVPlots::ClevelandDotPlot(randomDraws, "letter", sort=1, stem=FALSE, title="Example with increasing sort order + coord_flip, no stem") + ggplot2::coord_flip()


## -----------------------------------------------------------------------------
set.seed(34903490)
N = 1000
ncar_vec = 0:5
prob = c(1.5, 3, 3.5, 2, 1, 0.75); prob = prob/sum(prob)

df = data.frame(
  num_cars = sample(ncar_vec, size = N, replace = TRUE, prob=prob),
  stringsAsFactors = FALSE)
WVPlots::ClevelandDotPlot(df, "num_cars", sort = 0, title = "Distribution of household vehicle ownership")
              


## -----------------------------------------------------------------------------
set.seed(354534)
N = 100

# rough proportions of eye colors
eprobs = c(0.37, 0.36, 0.16, 0.11)

eye_color  = sample(c("Brown", "Blue", "Hazel", "Green"), size = N, replace = TRUE, prob = eprobs)
sex = sample(c("Male", "Female"), size = N, replace = TRUE)

# A data frame of eye color by sex
dframe = data.frame(
  eye_color = eye_color, 
  sex = sex,
  stringsAsFactors = FALSE)

WVPlots::ShadowPlot(dframe, "eye_color", "sex", title = "Shadow plot of eye colors by sex")


## -----------------------------------------------------------------------------
set.seed(354534)
N = 100

dframe = data.frame(
  x = rnorm(N), 
  gp = "region 2", 
  stringsAsFactors = FALSE)
dframe$gp = with(dframe, ifelse(x < -0.5, "region 1", 
                                ifelse(x > 0.5, "region 3", gp)))

WVPlots::ShadowHist(dframe, "x", "gp", title = "X values by region")


## -----------------------------------------------------------------------------
WVPlots::ShadowHist(dframe, "x", "gp", title = "X values by region", monochrome=TRUE) 

## -----------------------------------------------------------------------------
colormap = c("#1F968BFF", "#29AF7FFF", "#55C667FF")

WVPlots::ShadowHist(dframe, "x", "gp", title = "X values by region", palette=NULL) +
  ggplot2::scale_fill_manual(values=colormap)


## -----------------------------------------------------------------------------
classes = c("a", "b", "c")
means = c(2, 4, 3)
names(means) = classes
label = sample(classes, size=1000, replace=TRUE)
meas = means[label] + rnorm(1000)
frm2 = data.frame(label=label,
                  meas = meas,
                  stringsAsFactors = FALSE)

WVPlots::ScatterBoxPlot(frm2, "label", "meas", pt_alpha=0.2, title="Example Scatter/Box plot")
WVPlots::ScatterBoxPlotH(frm2, "meas", "label",  pt_alpha=0.2, title="Example Scatter/Box plot")

## -----------------------------------------------------------------------------
frmx = data.frame(x = rbinom(1000, 20, 0.5),
                  stringsAsFactors = FALSE)
WVPlots::DiscreteDistribution(frmx, "x","Discrete example")

## -----------------------------------------------------------------------------
set.seed(52523)
d <- data.frame(wt=100*rnorm(100),
                stringsAsFactors = FALSE)
WVPlots::PlotDistCountNormal(d,'wt','example')
WVPlots::PlotDistDensityNormal(d,'wt','example')

## -----------------------------------------------------------------------------
set.seed(13951)
trial_size = 20  # one trial is 20 flips
ntrial = 100     # run 100 trials
true_frate = 0.4  # true heads probability
fdata = data.frame(n_heads = rbinom(ntrial, trial_size, true_frate),
                   stringsAsFactors = FALSE)

title = paste("Distribution of head counts, trial size =", trial_size)
# compare to empirical p
WVPlots::PlotDistCountBinomial(fdata, "n_heads", trial_size, title)

## -----------------------------------------------------------------------------
# compare to theoretical p of 0.5
WVPlots::PlotDistCountBinomial(fdata, "n_heads", trial_size, title,
                      p = 0.5)

## -----------------------------------------------------------------------------
set.seed(349521)
N = 100  # number of cohorts
psucc = 0.15  # true success rate in population
group_size = round(runif(N, min=25, 50))  # sizes of observed sample groups
nsucc = rbinom(N, group_size, psucc)   # successes in each group
hdata = data.frame(n_success=nsucc, 
                   group_size=group_size,
                   stringsAsFactors = FALSE)

# observed rate of successes in each group
hdata$rate_success = with(hdata, n_success/group_size)

title = "Observed prevalence of success in population"

WVPlots::PlotDistHistBeta(hdata, "rate_success", title) 
WVPlots::PlotDistDensityBeta(hdata, "rate_success", title)


## -----------------------------------------------------------------------------
y = c(1,2,3,4,5,10,15,18,20,25)
x = seq_len(length(y))
df = data.frame(x=x,
                y=y,
                stringsAsFactors = FALSE)

WVPlots::ConditionalSmoothedScatterPlot(df, "x", "y", NULL, title="centered smooth, one group")
WVPlots::ConditionalSmoothedScatterPlot(df, "x", "y", NULL, title="left smooth, one group", align="left")
WVPlots::ConditionalSmoothedScatterPlot(df, "x", "y", NULL, title="right smooth, one group", align="right")

n = length(x)
df = rbind(data.frame(x=x, y=y+rnorm(n), gp="times 1", stringsAsFactors = FALSE),
           data.frame(x=x, y=0.5*y + rnorm(n), gp="times 1/2", stringsAsFactors = FALSE),
           data.frame(x=x, y=2*y + rnorm(n), gp="times 2", stringsAsFactors = FALSE),
           stringsAsFactors = FALSE)

WVPlots::ConditionalSmoothedScatterPlot(df, "x", "y", "gp", title="centered smooth, multigroup")
WVPlots::ConditionalSmoothedScatterPlot(df, "x", "y", "gp", title="left smooth, multigroup", align="left")
WVPlots::ConditionalSmoothedScatterPlot(df, "x", "y", "gp", title="right smooth, multigroup", align="right")

## -----------------------------------------------------------------------------
set.seed(52523)
d = data.frame(meas=rnorm(100), stringsAsFactors = FALSE)
threshold = -1.5
WVPlots::ShadedDensity(d, "meas", threshold, 
                       title="Example shaded density plot, left tail")
WVPlots::ShadedDensity(d, "meas", -threshold, tail="right", 
                       title="Example shaded density plot, right tail")


## -----------------------------------------------------------------------------
set.seed(52523)
d = data.frame(meas=rnorm(100), stringsAsFactors = FALSE)
# first and third quartiles of the data (central 50%)
boundaries = quantile(d$meas, c(0.25, 0.75))
WVPlots::ShadedDensityCenter(d, "meas", boundaries, 
                       title="Example center-shaded density plot")


