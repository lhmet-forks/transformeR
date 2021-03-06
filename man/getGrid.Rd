% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{getGrid}
\alias{getGrid}
\title{Get regular grid definition}
\usage{
getGrid(gridData)
}
\arguments{
\item{gridData}{A grid data object coming from \code{loadGridData} (package \pkg{loadeR}) or \code{\link{interpGrid}}
or the function \code{loadECOMS} of package \pkg{loadeR.ECOMS}.}
}
\value{
A list of two named components, \code{x} and \code{y}, consisting of a vector of length two each one, defining
the x/y lower and upper bounds. The grid-cell resolution is given by the attributes \code{'resX'} and
 \code{'resY'} respectively.
}
\description{
Get the (regular) grid definition from an existing (gridded) dataset
}
\details{
In case of irregular grid definitions, the function forces the grid to regularity.
The returned grid object inherits the attributes from the input \code{xyCoords} definition.
}
\examples{
# Regular grid
data("NCEP_Iberia_hus850")
str(getGrid(NCEP_Iberia_hus850))
# Regular rotated grid with correpondence with a non regular grid in the 
# lat/lon domain.
data("CORDEX_Iberia_tas")
str(getGrid(CORDEX_Iberia_tas))
# Station data
data("VALUE_Iberia_tas")
str(getGrid(VALUE_Iberia_tas))

# Interpolate NCEP onto the System4 grid:
data("CFS_Iberia_pr")
NCEP_interpolated <- interpGrid(NCEP_Iberia_hus850, getGrid(CFS_Iberia_pr), "bilinear")
# Note the warnings because of the non-overlapping domain extents (longitudes)
plotClimatology(climatology(NCEP_Iberia_hus850), backdrop.theme = "countries")
plotClimatology(climatology(NCEP_interpolated), backdrop.theme = "countries")
str(getGrid(NCEP_interpolated))
str(getGrid(CFS_Iberia_pr))

# The other way round, using nearest neighbour interpolation:
CFS_interpolated <- interpGrid(CFS_Iberia_pr, getGrid(NCEP_Iberia_hus850))
plotClimatology(climatology(CFS_interpolated), backdrop.theme = "countries")
# In this case, the mismatch in domain extent occurs in the longitudes and latitudes
}
\seealso{
Other get.helpers: \code{\link{get2DmatCoordinates}},
  \code{\link{getCoordinates}}, \code{\link{getDim}},
  \code{\link{getGridProj}},
  \code{\link{getGridVerticalLevels}},
  \code{\link{getRefDates}}, \code{\link{getSeason}},
  \code{\link{getShape}}, \code{\link{getStationID}},
  \code{\link{getTimeResolution}},
  \code{\link{getVarNames}}, \code{\link{getWT}},
  \code{\link{getYearsAsINDEX}}, \code{\link{setGridProj}},
  \code{\link{typeofGrid}}, \code{\link{which.leap}}
}
\author{
S. Herrera and J. Bedia
}
\concept{get.helpers}
