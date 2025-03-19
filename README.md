# map_elevation

[![pub package](https://img.shields.io/pub/v/map_elevation.svg)](https://pub.dartlang.org/packages/map_elevation)

A widget to display elevation of a track (polyline)

[![Demo screenshot](https://github.com/OwnWeb/map_elevation/blob/master/statics/demo.gif?raw=true)](https://github.com/OwnWeb/map_elevation/blob/master/statics/demo.gif?raw=true)

## Features
- Draw elevation graph
- Dispatch a notification with hover point on graph
- Add colors for high elevation gradients
- Add colors depending on parameters associated to POI.
- Ability to add child over graph

## Getting Started

``` dart
NotificationListener<ElevationHoverNotification>(
    onNotification: (ElevationHoverNotification notification) {
      setState(() {
        hoverPoint = notification.position;
      });

      return true;
    },
    child: Elevation(
      getElevationPoints(),
      color: Colors.grey,
      parameterUsedToColor: colorParameter.value,
      parameterValuesAndColorsMap: colorParameter.colorValueMap
    )
)
```