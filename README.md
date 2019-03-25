# MapDfGenerator


MapDfGenerator is a package that wrap 4 solutions to last time's lab.


team_X <- function(file, tolerance) where X is the solution for team X used, file is a file path to a shape file and tolerance is the value used for thinning the polygon

The return value is a data frame of the geographic information of the polygons and the additional information (such as name of the country, name of the territory/state, ...)


## Authors


| Author | team choosed from last lab | function name |
| ------ | ------ | ------ |
| Atousa Zarindast | team 10 | shpBigToSmall() |
| Yudi Zhang | team 11| team_11() |
| Zerui Zhang | team 12 | team_12() |
| Ying Zheng | team 5 | team_5() |


##  Installation  

```
# Install devtools from CRAN
install.packages("devtools")

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("zeruiz/MapDfGenerator")
```

## Usage examples 

```
library(MapDfGenerator)
team11_result <-team_11("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)
team5_result <-team_5("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)
team12_result <-team_12("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1)
team10_result <-shpBigToSmall("./data/gadm36_AUS_shp/gadm36_AUS_1.shp", 0.1) 
```





 
