\name{DeducerRDSAnalyst-package}
\alias{DeducerRDSAnalyst-package}
\docType{package}
\title{
Graphical User Interface to the RDS package for Respondent-Driven Sampling.
}
\description{
\pkg{DeducerRDSAnalyst} is a graphical user interface to the \pkg{RDS} 
package to analyse data collect via 
respondent-driven sampling designs. 
For a list of functions type: help(package='DeducerRDSAnalyst')

For a complete list of the functions, use \code{library(help="DeducerRDSAnalyst")} 
or read the rest of the manual.
% For a simple demonstration, use \code{demo(packages="DeducerRDSAnalyst")}.

When publishing results obtained using this package the original authors
are to be cited as:

Gile, Krista J. and Handcock, Mark S. 2010 
\emph{DeducerRDSAnalyst: Analyzing Samples from Hard-to-Reach Populations}
\cr
\url{http://hpmrg.org}.

All programs derived from this package must cite it.
For complete citation information, use\cr
\code{citation(package="DeducerRDSAnalyst")}.
}
\details{
%Recent advances in the statistical modeling of random networks have had an
%impact on the empirical study of social networks. Statistical exponential
%family models (Strauss and Ikeda 1990) are a generalization of the Markov
%random network models introduced by Frank and Strauss (1986), which in turn
%derived from developments in spatial statistics (Besag, 1974). These models
%recognize the complex dependencies within relational data structures.  To
%date, the use of stochastic network models for networks has been limited by
%three interrelated factors: the complexity of realistic models, the lack of
%simulation tools for inference and validation, and a poor understanding of the
%inferential properties of nontrivial models.
%
%This manual introduces software tools for the representation, visualization,
%and analysis of network data that address each of these previous shortcomings.
%The package relies on the \code{\link[network]{network}} package which allows networks to be
%represented in \R. The \pkg{DeducerRDSAnalyst} package allows maximum likelihood estimates of
%exponential random network models to be calculated using Markov Chain Monte
%Carlo.  The package also provides tools for plotting networks, simulating
%networks and assessing model goodness-of-fit.

For detailed information on how to download and install the software,
go to the \pkg{DeducerRDSAnalyst} website:
\url{http://hpmrg.org}.
A tutorial, support newsgroup, references and links to further resources are provided there.
}
\author{
Krista J. Gile \email{gile@math.umass.edu},\cr
Mark S. Handcock \email{handcock@stat.ucla.edu}

Maintainer: Mark S. Handcock \email{handcock@stat.ucla.edu}
}

\references{

Gile, Krista J. (2008)
\emph{Inference from Partially-Observed Network Data},
Ph.D. Thesis, Department of Statistics, University of Washington.

Gile, Krista J. and Handcock, Mark S. (2010)
\emph{Respondent-Driven Sampling: An Assessment of Current Methodology},
To appear, Sociological methodology, 40. 

Gile, Krista J. and Handcock, Mark S. (2009)
 \pkg{DeducerRDSAnalyst}: {A} Package to Estimate Population Size from Respondent Driven
Sampling Data.
 Statnet Project, Seattle, WA.
 Version 1, \url{http://hpmrg.org}.

Handcock MS (2003b).
 \pkg{degreenet}: Models for Skewed Count Distributions Relevant
  to Networks.
 Statnet Project, Seattle, WA.
 Version 1.0, \url{http://hpmrgproject.org}.

Handcock, Mark S.,  Gile, Krista J. and Mar, Corinne M. (2009)
\emph{Estimating the Size of a Hard-to-Reach Population using Respondent-Driven Sampling Data}, manuscript.
}

\keyword{ package }
\keyword{ models }
