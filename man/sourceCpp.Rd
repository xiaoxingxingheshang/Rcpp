\name{sourceCpp}
\alias{sourceCpp}
\title{
Source C++ Code from a File or String
}
\description{
\code{sourceCpp} parses the specified C++ file or source code and looks for functions marked with the \code{\link[=exportAttribute]{Rcpp::export}} attribute
and RCPP_MODULE declarations. A shared library is then built and its exported functions and Rcpp modules are made available in the specified environment.
}
\usage{
sourceCpp(file = "", code = NULL, env = globalenv(), embeddedR = TRUE, rebuild = FALSE, 
          cacheDir = getOption("rcpp.cache.dir", tempdir()), cleanupCacheDir = FALSE,
          showOutput = verbose, verbose = getOption("verbose"), dryRun = FALSE,
          windowsDebugDLL = FALSE)
}
\arguments{
  \item{file}{
    A character string giving the path name of a file
}
  \item{code}{
    A character string with source code. If supplied, the code is taken from this string instead of a file. 
}
  \item{env}{
    Environment where the R functions and modules should be made available.
}
  \item{embeddedR}{
    \code{TRUE} to run embedded R code chunks.
}
  \item{rebuild}{
    Force a rebuild of the shared library.
}
  \item{cacheDir}{
    Directory to use for caching shared libraries. If the underlying file or code passed to \code{sourceCpp} has not changed since the last invocation then a cached version of the shared library is used. The default value of \code{tempdir()} results in the cache being valid only for the current R session. Pass an alternate directory to preserve the cache across R sessions.
}
\item{cleanupCacheDir}{
    Cleanup all files in the cacheDir that were not a result of this compilation. Note that this will cleanup the cache from all other calls to sourceCpp with the same cacheDir. This option should therefore only be specified by callers that provide a unique cacheDir per scope (e.g. chunk labels in a weaved document).
}
  \item{showOutput}{
    \code{TRUE} to print \code{R CMD SHLIB} output to the console.
}
  \item{verbose}{
    \code{TRUE} to print detailed information about generated code to the console.
}
  \item{dryRun}{
    \code{TRUE} to do a dry run (showing commands that would be used rather than
actually executing the commands).
}
  \item{windowsDebugDLL}{
    \code{TRUE} to create a debug DLL on Windows (and ignored on other platforms).
}
}
\details{
    If the \code{code} parameter is provided then the \code{file} parameter is ignored.

    Functions exported using \code{sourceCpp} must meet several conditions, 
    including being defined in the global namespace and having return types 
    that are compatible with \code{Rcpp::wrap} and parameter types that are 
    compatible with \code{Rcpp::as}. 
    See the \code{\link[=exportAttribute]{Rcpp::export}} documentation for more details.
    
    Content of Rcpp Modules will be automatically loaded into the specified 
    environment using the \code{\link[=Module]{Module}} and 
    \code{\link[=populate]{populate}} functions. 
    
    If the source file has compilation dependencies on other 
    packages (e.g. \pkg{Matrix}, \pkg{RcppArmadillo}) then an 
    \code{\link[=dependsAttribute]{Rcpp::depends}} attribute 
    should be provided naming these dependencies. 
    
	It's possible to embed chunks of R code within a C++ source file by 
	including the R code within a block comment with the 
	prefix of \code{/*** R}. For example:
    
\preformatted{
/*** R

# Call the fibonacci function defined in C++
fibonacci(10)

*/
}

	Multiple R code chunks can be included in a C++ file. R code is sourced after the C++ compilation is completed so all functions and modules will be available to the R code.   
}

\value{
    Returns (invisibly) a list with two elements: 
    \tabular{ll}{
        \code{functions} \tab Names of exported functions\cr
        \code{modules} \tab Names of Rcpp modules\cr
    }
}

\note{
	The \code{sourceCpp} function will not rebuild the shared library if the source file has not changed since the last compilation.

    The \code{sourceCpp} function is designed for compiling a standalone source file whose only dependencies are R packages. If you are compiling more than one source file or have external dependencies then you should create an R package rather than using \code{sourceCpp}. Note that the \code{\link[=exportAttribute]{Rcpp::export}} attribute can also be used within packages via the \code{\link{compileAttributes}} function.
    
    If you are sourcing a C++ file from within the \code{src} directory of a package then the package's \code{LinkingTo} dependencies, \code{inst/include}, and \code{src} directories are automatically included in the compilation.
    
    If no \code{Rcpp::export} attributes or \code{RCPP_MODULE} declarations are found within the source file then a warning is printed to the console. You can disable this warning by setting the \code{rcpp.warnNoExports} option to \code{FALSE}.

}

\seealso{
\code{\link[=exportAttribute]{Rcpp::export}}, \code{\link[=dependsAttribute]{Rcpp::depends}}, \code{\link{cppFunction}}, \code{\link{evalCpp}}
}

\examples{
\dontrun{

sourceCpp("fibonacci.cpp")

sourceCpp(code='
  #include <Rcpp.h>

  // [[Rcpp::export]]
  int fibonacci(const int x) {
    if (x == 0) return(0);
    if (x == 1) return(1);
    return (fibonacci(x - 1)) + fibonacci(x - 2);
  }'
)

}
}
