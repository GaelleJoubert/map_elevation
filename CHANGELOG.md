## 3.0.0
* Example app : Update Min SDK version to 21, migrate to Android Embedding V2
* Update dependencies : latlong2 to 0.9.0,

* **New Feature**  You can color the graph based on other parameter than just the elevation
* `ElevationPoint` has a field `parameters` that can be used to store additional data
* New parameter `parameterUsedToColor` to select the parameter used for coloring the graph
* **New Feature**  You can display a legend Widget
* **New Feature**  You can compute the percentage of the graph that is above a certain value (for elevation and other parameters)
* **New Feature** New parameter `unit` to select the unit used to display the axis legend
* **New Feature** New parameter `groupElevationPoints` to draw the graph for segmented elevation points (useful for example for a track with multiple segments)
* **New Feature** New parameter `scaleColor`, `scaleTextStyle` and `dashedAltitudesColor` to custom the style
* **New Feature** New parameter `totalDistance` to display a distance axis.
* **Breaking:** 
* the parameter `elevationGradientColors` is now a `parameterValuesAndColorsMap`
* Bump Min sdk to 2.17.0




## 2.0.0


* Null safety
* **Breaking:** `Elevation.color` param is now required

## 1.2.0

* Use `latlong2` instead of `latlong`, allowing use of `flutter_map` 0.13.1. Thanks to [https://github.com/moovida](@moovida)!
* Update licence from GNU to MIT (see [https://apple.stackexchange.com/questions/6109/is-it-possible-to-have-gpl-software-in-the-mac-app-store](this stackoverflow thread))

## 1.1.0

* Make ElevationPoint extends LatLng @moovida

## 1.0.2

* Update README

## 1.0.1

* Format code

## [1.0.0]

* Initial release
