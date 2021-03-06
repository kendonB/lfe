% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{chainsubset}
\alias{chainsubset}
\title{Chain subset conditions}
\usage{
chainsubset(..., out.vars)
}
\arguments{
\item{...}{Logical conditions to be chained.}

\item{out.vars}{character. Variables not in data.frame, only needed if you use variables which
are not in the frame.  If \code{out.vars} is not specified, it is assumed to match all variables
starting with a dot ('.').}
}
\value{
Expression that can be \code{eval}'ed to yield a logical subset mask.
}
\description{
Chain subset conditions
}
\details{
A set of logical conditions are chained, not and'ed. That is, each argument to
\code{chainsubset} is used as a filter to create a smaller dataset. Each subsequent
argument filters further.
For independent conditions this will be the same as and'ing them. I.e.
\code{chainsubset(x < 0 , y < 0)} will yield  the same subset as \code{(x < 0) & (y < 0)}.
However, for e.g. aggregate filters like \code{chainsubset(x < mean(x), y < mean(y))}
we first find all the observations with \code{x < mean(x)}, then among these we
find the ones with \code{y < mean(y)}.  The \code{mean(y)} is now conditional on
\code{x < mean(x)}.
}
\examples{
N <- 10000
dat <- data.frame(y=rnorm(N), x=rnorm(N),id=factor(sample(N/100,N,replace=TRUE)))
# It's not the same as and'ing the conditions:
ss <- chainsubset(x < mean(y), y < 3*mean(x))
sum(eval(ss,dat))
sum(evalq(x < mean(y) & y < 3*mean(x), dat))
ss2 <- chainsubset(x < mean(y), y < a*mean(x), out.vars='a')
a <- 3; sum(eval(ss2, dat))
a <- 2; sum(eval(ss2, dat))
# Among observations with x < y, find entire id's with more than
# one fifth of their x's larger than 1/2
ss3 <- chainsubset( x < y, tapply(x,id,function(.xx) {sum(.xx > 1/2) > length(.xx)/5} )[id])
 sum(eval(ss3,dat))
}

