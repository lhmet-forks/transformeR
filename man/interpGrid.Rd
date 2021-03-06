% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interpGrid.R
\name{interpGrid}
\alias{interpGrid}
\title{Grid interpolation}
\usage{
interpGrid(grid, new.coordinates = list(x = NULL, y = NULL),
  method = c("nearest", "bilinear"), bilin.method = "fields",
  parallel = FALSE, max.ncores = 16, ncores = NULL, ...)
}
\arguments{
\item{grid}{An input grid to be interpolated/regridded.}

\item{new.coordinates}{Definition of the new grid (or points) coordinates, in the form of a list with the x and y components, in this order.
If new coordinates correspond to an irregular grid (e.g. point locations), lengths for x and y must be the same: Each position in x and y correspond to
a new location (a pair of coordinates).}

\item{method}{Method for interpolation. Currently implemented methods are either \code{"bilinear"},
for bilinear interpolation, and \code{"nearest"}, for nearest-neighbor interpolation (default).}

\item{bilin.method}{Algorithm chosen for bilinear interpolation. Two options available: \code{"akima"} uses \code{\link[akima]{interp}} and
\code{"fields"} (default) the \code{\link[fields]{interp.surface.grid}} algorithm. In case any missing values exist in the input data matrix, 
the \code{"fields"} option, able to handle missing values, need to be used. Otherwise, the \code{"akima"} option performs much faster.}

\item{parallel}{Logical. Should parallel execution be used?}

\item{max.ncores}{Integer. Upper bound for user-defined number of cores.}

\item{ncores}{Integer number of cores used in parallel computation. Self-selected number of
cores is used when \code{ncpus = NULL} (the default), or when \code{maxcores} exceeds the default \code{ncores} value.}

\item{...}{Further arguments for bilinear interpolation that are passed to function \code{\link[akima]{interp}} 
from package \pkg{\link[akima]{akima}}.}
}
\value{
An interpolated object preserving the structure of the input
}
\description{
Interpolation of grids (gridded data or stations) into a user-defined grid using nearest-neighbour or bilinear weights.
}
\details{
The output has special attributes in the \code{xyCoords} element that indicate that the object
 has been interpolated. These attributes are \code{interpolation}, which indicates the method used and
 \code{resX} and \code{resY}, for the grid-cell resolutions in the X and Y axes respectively.
 It is also possible to pass the interpolator the grid of a previously existing grid dataset using the
 \code{\link{getGrid}} method. See examples.
}
\note{
To avoid unnecessary NA values, the function will not extrapolate using a new grid outside the
current extent of the dataset, returning an error message.
}
\section{Parallel Processing}{


Parallel processing is enabled using the \pkg{parallel} package. 
Parallelization is undertaken by a FORK-type parallel socket cluster formed by \code{ncores}.
If \code{ncores} is not specified (default), \code{ncores} will be one less than the autodetected number of cores.
The maximum number of cores used for parallel processing can be set with the \code{max.ncores} argument, 
although this will be reset to the auto-detected number of cores minus 1 if this number is exceeded. Note that not all 
code, but just some critical loops within the function are parallelized.

In practice, parallelization does not always result in smaller execution times, due to the parallel overhead.
However, parallel computing may potentially provide a significant speedup for the 
particular case of large multimember datasets or large grids.
 
Parallel computing is currently not available for Windows machines.
}

\examples{
# boreal winter (DJF) precipitation data for the Iberian Peninsula and the period 1983-2002
data(EOBS_Iberia_pr)
plotClimatology(climatology(EOBS_Iberia_pr))
# Bilinear interpolation to a regular grid of 0.5 degree 
# resolution centered in the Iberian Peninsula
t1 <- interpGrid(EOBS_Iberia_pr, new.coordinates = list(x = seq(-10,5,.5),
                                                        y = seq(36,44,.5)),
                 method = "bilinear",
                 bilin.method = "akima")
plotClimatology(climatology(t1), backdrop.theme = "countries")
# New attributes indicate that the data have been interpolated:
attributes(t1$xyCoords)

# Using the coordinate information of another grid via getGrid()
data(NCEP_Iberia_pr)
t2 <- interpGrid(EOBS_Iberia_pr, new.coordinates = getGrid(NCEP_Iberia_pr),
                 method = "nearest")
plotClimatology(climatology(t2), backdrop.theme = "countries")

#From station data to grid
data(VALUE_Iberia_pr)
plotClimatology(climatology(VALUE_Iberia_pr), backdrop.theme = "countries")
t3 <- interpGrid(VALUE_Iberia_pr, new.coordinates = getGrid(EOBS_Iberia_pr),
                 method = "bilinear")
plotClimatology(climatology(t3), backdrop.theme = "countries")

#From grid to station data
t4 <- interpGrid(EOBS_Iberia_pr, new.coordinates = getGrid(VALUE_Iberia_pr),
                 method = "nearest")
plotClimatology(climatology(t4), backdrop.theme = "countries")
t5 <- interpGrid(EOBS_Iberia_pr, 
               new.coordinates = list(x = c(-6.7, -4.5, 2.5), 
                                      y = c(41.8, 40, 39)))
plotClimatology(climatology(t5), backdrop.theme = "countries")

#From grid to a single point or station
t6 <- interpGrid(grid = EOBS_Iberia_pr, 
                 new.coordinates = list(x = -6.7, y = 41.8))
str(t6$Data)
}
\author{
J. Bedia, S. Herrera, M. de Felice, M. Iturbide
}
