Generate fake data
==================


N &lt;- 40

1.  1.  predictor variables

a &lt;- runif(N) b &lt;- runif(N) c &lt;- runif(N) y &lt;-
rnorm(N,mean=a+4\*b+c,sd=1) dat &lt;- data.frame(y,a,b,c) </source-file>

Do a linear model
=================

lm.R </source-file>

summary(lm(y\~a+b+c,data=dat)) </source-file>

Bayesian analysis
=================

With bayesglm
-------------

series.Rout bayesglm.R </source-file>

library("arm") summary(bayesglm(y\~a+b+c,data=dat)) </source-file>

With BUGS/JAGS
--------------

We need priors for the four regression parameters, and for the error
variance. The BUGS/JAGS framework does not let us use improper priors,
so we have to pick things that we think are "wide" enough.

For the error variance, we also have to pick something that's always
positive.

Finally, BUGS/JAGS thinks in terms of "precision"
\$\$\\tau=1/\\sigma\^2\$\$, which is confusing, but you can get used to
it. It's best to start by guessing what you think a "large" standard
deviation would be, then taking \$\$1/\\sigma\^2\$\$ to get the relevant
value of \$\$\\tau\$\$. A plausible rule of thumb might be 10 times the
expected value of your parameter. For example, if you expected that the
difference between masses of two species might be 100g, you could use a
prior with a standard deviation of 1000g or a precision of
\$\$10\^{-6}\$\$. The normal priors below have low precision, so they
have high variance.

rjags
-----

series.Rout bayes.R </source-file>


`   for (i in 1:N){`\
`       y[i] ~ dnorm(pred[i], tau)`\
`       pred[i] <- ma*a[i] + mb*b[i] + mc*c[i] + int`\
`   }`\
`   ma ~ dnorm(0, .0001)`\
`   mb ~ dnorm(0, .0001)`\
`   mc ~ dnorm(0, .0001)`\
`   int ~ dnorm(0, .0001)`\
`   tau ~ dgamma(.001, .001)`

} </source-file>

R2jags
------

bayes\_r2jags.Rout: bayes.bug series.Rout bayes\_r2jags.R </source-file>

library('R2jags') jags1 &lt;- jags(model.file='bayes.bug',

`             parameters=c("ma","mb","mc","int"),`\
`             data = list('a' = a, 'b' = b, 'c' = c, 'N'=N, 'y'=y),`\
`             n.chains = 4,`\
`             inits=NULL)`


-   You can use `inits=NULL` to have JAGS pick the initial values
    randomly from the priors. For more complex models you might want to
    pick starting values for the chains yourself (see the
    `?jags` documentation).

### Examine the chains and output

bayes\_r2jags.RData </source-file>

library('coda') library('emdbook') \#\# for lump.mcmc.list() and
as.mcmc.bugs() library('coefplot2') bb &lt;- jags1\$BUGSoutput \#\#
extract the "BUGS output" component mm &lt;- as.mcmc.bugs(bb) \#\#
convert it to an "mcmc" object that coda can handle plot(jags1) \#\#
large-format graph

1.  1.  plot(mm) \#\# trace + density plots, same as above

xyplot(mm,layout=c(2,3)) \#\# prettier trace plot
densityplot(mm,layout=c(2,3)) \#\# prettier density plot
coefplot2(jags1) \#\# estimate + credible interval plot </source-file>

The `lump.mcmc.list` function from the `emdbook` package can be useful
for converting a set of MCMC chains into a single long chain.






Further notes
-------------

### Categorical variables

Implementing models with categorical variables (say, a t-test or an
ANOVA) is a little bit more tedious than the multiple regression
analysis shown above. There are two basic strategies:

1.  pass the categorical variable as a vector of numeric codes (i.e.
    pass `as.numeric(f)` rather than `f` to JAGS in your `data` list),
    and make your parameters a simple vector of the means corresponding
    to each level, e.g. you could have a vector of parameters `catparam`
    and specify the predicted value as `pred[i]` `=` `catparam[f[i]]`
2.  construct a design matrix using the `model.matrix` function in R and
    pass the whole model matrix (`X`)to JAGS. Then, to get the predicted
    value for each observation, just add up the relevant columns of the
    model matrix: e.g. `pred[i]` `=`
    `beta[1]*X[i,1]+beta[2]*X[i,2]+beta[3]*X[i,3]`. You can also use the
    built-in `inprod` (inner product) function: `pred[i]` `=`
    `inprod(X[i,],beta)`

The second approach is a little bit harder to understand but generalizes
to more complicated situations, and gives you answers that will more
closely match the analogous analyses in R (e.g. using `lm`).

### Built-in Bayesian modeling techniques

-   `bayesglm` from the `arm` package

bayes\_r2jags.RData coda2.Rout </source-file>

library('emdbook') \#\# for lump.mcmc.list() and as.mcmc.bugs() mmL
&lt;- lump.mcmc.list(mm) \#\# convert to a single long chain
colMeans(mmL) \#\# which one is biggest? b ...

1.  1.  test the probability that it is really the biggest

mean((mmL\[,"mb"\] &gt; mmL\[,"ma"\]) & (mmL\[,"mb"\] &gt;
mmL\[,"mc"\]))

1.  1.  or (alternatively -- this would be good if you had lots
        of categories)

meanschain &lt;- mmL\[,-(1:2)\] maxval &lt;-
apply(meanschain,1,which.max) mean(maxval==2) </source-file>
