library map_elevation;

export 'elevation_legend.dart';
export 'elevation_point.dart';
export 'elevation_functions.dart';

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lg;

import 'elevation_point.dart';

/// Elevation statefull widget
class Elevation extends StatefulWidget {
  /// List of points to draw on elevation widget
  /// Lat and Long are required to emit notification on hover
  /// A Parameter argument can be added to color the graph, See [ElevationPoint.parameters]
  final List<ElevationPoint> points;

  /// Background color of the elevation graph
  final Color? color;

  /// Map of of the values the parameter can take and the color associated
  /// Note : If you just want to color your graph according to the elevation, you can simply pass :
  /// ElevationGradientColors.toMap()
  final Map<int, Color>? parameterValuesAndColorsMap;

  ///The value of the parameter used to color the graph, if null, it means the elevation is used to color the graph
  final int? parameterUsedToColor;

  /// Color of the scale
  final Color? scaleColor;

  /// Color of the dashed altitudes lines
  final Color? dashedAltitudesColor;

  /// Style of the scale items label
  final TextStyle? scaleTextStyle;

  /// Total distance of route
  final num? totalDistance;

  final double? progression;

  /// [WidgetBuilder] like Function to add child over the graph
  final Function(BuildContext context, Size size)? child;

  /// Unit used to display the altitude/distance
  // final PreferredUnit unit;
  // final List<List<ElevationPoint>>? groupedElevationPoints;

  Elevation(this.points,
      {this.color,
      this.parameterValuesAndColorsMap,
      this.child,
      this.parameterUsedToColor,
      this.scaleColor,
      this.dashedAltitudesColor,
      this.scaleTextStyle,
      this.totalDistance,
      this.progression});

  @override
  State<StatefulWidget> createState() => _ElevationState();
}

class _ElevationState extends State<Elevation> {
  double? _hoverLinePosition;
  double? _hoveredAltitude;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints bc) {
      Offset _lbPadding = Offset(35, 6);
      _ElevationPainter elevationPainter = _ElevationPainter(widget.points,
          paintColor: widget.color ?? Colors.transparent,
          parameter: widget.parameterUsedToColor,
          parametersColors: widget.parameterValuesAndColorsMap,
          scaleTextStyle: widget.scaleTextStyle,
          scaleColor: widget.scaleColor,
          dashedAltitudesColor: widget.dashedAltitudesColor,
          totalDistance: widget.totalDistance,
          lbPadding: _lbPadding);

      return GestureDetector(
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            final pointFromPosition = elevationPainter
                .getPointFromPosition(details.globalPosition.dx);

            if (pointFromPosition != null) {
              ElevationHoverNotification(pointFromPosition)..dispatch(context);
              setState(() {
                _hoverLinePosition = details.globalPosition.dx;
                _hoveredAltitude = pointFromPosition.altitude;
              });
            }
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            ElevationHoverNotification(null)..dispatch(context);
            setState(() {
              _hoverLinePosition = null;
            });
          },
          child: Stack(children: <Widget>[
            CustomPaint(
              painter: elevationPainter,
              size: Size(bc.maxWidth, bc.maxHeight),
            ),
            if (widget.child != null && widget.child is Function)
              Container(
                margin: EdgeInsets.only(left: _lbPadding.dx),
                width: bc.maxWidth - _lbPadding.dx,
                height: bc.maxHeight - _lbPadding.dy,
                child: Builder(
                    builder: (BuildContext context) => widget.child!(
                        context,
                        Size(bc.maxWidth - _lbPadding.dx,
                            bc.maxHeight - _lbPadding.dy))),
              ),
            if (_hoverLinePosition != null)
              Positioned(
                left: _hoverLinePosition,
                top: 0,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: bc.maxHeight,
                        width: 1,
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                      if (_hoveredAltitude != null)
                        Text(
                          _hoveredAltitude!.round().toString(),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        )
                    ]),
              )
          ]));
    });
  }
}

class _ElevationPainter extends CustomPainter {
  /// List of points to draw on elevation widget
  List<ElevationPoint> points;
  late List<double> _relativeAltitudes;

  /// Main color used to paint under the elevation line in the graph
  Color paintColor;
  TextStyle? scaleTextStyle;
  Color? scaleColor;
  Color? dashedAltitudesColor;
  Offset lbPadding;
  late int _min, _max;
  late double widthOffset;
  num? totalDistance;

  /// Map of of the values the parameter can take and the color associated
  Map<int, Color>? parametersColors;

  /// The parameter chosen to color the graph, if null, it means the elevation is used to color the graph
  int? parameter;

  _ElevationPainter(
    this.points, {
    required this.paintColor,
    this.lbPadding = Offset.zero,
    this.parametersColors,
    this.parameter,
    this.scaleTextStyle,
    this.dashedAltitudesColor,
    this.totalDistance,
    this.scaleColor,
  }) {
    _min = (points.map((point) => point.altitude).toList().reduce(min) / 100)
            .floor() *
        100;
    _max = (points.map((point) => point.altitude).toList().reduce(max) / 100)
            .ceil() *
        100;

    _relativeAltitudes =
        points.map((point) => (point.altitude - _min) / (_max - _min)).toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);

    final paint = Paint()
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = BlendMode.src
      ..style = PaintingStyle.fill
      ..color = paintColor;
    final axisPaint = Paint()
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = BlendMode.src
      ..style = PaintingStyle.stroke;

    //Painter when elevation is used to color the graph
    if (parametersColors != null && parameter == null) {
      List<Color> gradientColors = [paintColor];

      for (int i = 1; i < points.length; i++) {
        double dX = lg.Distance().distance(points[i], points[i - 1]);
        double dZ = (points[i].altitude - points[i - 1].altitude);

        double gradient = 100 * dZ / dX;
        if (gradient > 30) {
          gradientColors.add(parametersColors![30]!);
        } else if (gradient > 20) {
          gradientColors.add(parametersColors![20]!);
        } else if (gradient > 10) {
          gradientColors.add(parametersColors![10]!);
        } else {
          gradientColors.add(paintColor);
        }
      }

      paint.shader = ui.Gradient.linear(
          Offset(lbPadding.dx, 0),
          Offset(size.width, 0),
          gradientColors,
          _calculateColorsStop(gradientColors));
    }

    //Painter when a parameter is used to color the graph
    if (parametersColors != null && parameter != null) {
      List<Color> gradientColors = [paintColor];
      Color? colorTypeSet;
      for (int i = 1; i < points.length; i++) {
        // Check if the point has the wanted parameter type
        if (points[i].parameters.isNotEmpty) {
          for (int j = 0; j < points[i].parameters.length; j++) {
            if (points[i].parameters[j]["type"] == parameter) {
              //we get the correct color according to the subtype
              gradientColors
                  .add(parametersColors![points[i].parameters[j]["sub_type"]]!);
              //save color for the next points
              colorTypeSet =
                  parametersColors![points[i].parameters[j]["sub_type"]];
            } else {
              //If the type don't match the wanted parameter, we use the last color set
              gradientColors.add(colorTypeSet ?? paintColor);
            }
          }
        } else {
          //If the point has no type, we use the last color set (if it has been set
          gradientColors.add(colorTypeSet ?? paintColor);
        }
      }
      paint.shader = ui.Gradient.linear(
          Offset(lbPadding.dx, 0),
          Offset(size.width, 0),
          gradientColors,
          _calculateColorsStop(gradientColors));
    }

    canvas.saveLayer(rect, Paint());

    widthOffset = (size.width - lbPadding.dx) / _relativeAltitudes.length;

    final path = Path()
      ..moveTo(lbPadding.dx, _getYForAltitude(_relativeAltitudes[0], size));
    _relativeAltitudes.asMap().forEach((int index, double altitude) {
      path.lineTo(
          index * widthOffset + lbPadding.dx, _getYForAltitude(altitude, size));
    });
    path.lineTo(size.width, size.height - lbPadding.dy);
    path.lineTo(lbPadding.dx, size.height - lbPadding.dy);

    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(lbPadding.dx, 0),
        Offset(lbPadding.dx, size.height - lbPadding.dy), axisPaint);

    int roundedAltitudeDiff = _max.ceil() - _min.floor();
    int axisStep = max(100, (roundedAltitudeDiff / 5).round());

    List<double>.generate((roundedAltitudeDiff / axisStep).round(),
        (i) => (axisStep * i + _min).toDouble()).forEach((altitude) {
      double relativeAltitude = (altitude - _min) / (_max - _min);
      canvas.drawLine(
          Offset(lbPadding.dx, _getYForAltitude(relativeAltitude, size)),
          Offset(lbPadding.dx + 10, _getYForAltitude(relativeAltitude, size)),
          axisPaint);
      TextPainter(
          text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 10),
              text: altitude.toInt().toString()),
          textDirection: TextDirection.ltr)
        ..layout()
        ..paint(
            canvas, Offset(5, _getYForAltitude(relativeAltitude, size) - 5));
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  double _getYForAltitude(double altitude, Size size) =>
      size.height - altitude * size.height - lbPadding.dy;

  ElevationPoint? getPointFromPosition(double position) {
    int index = ((position - lbPadding.dx) / widthOffset).round();

    if (index >= points.length || index < 0) return null;

    return points[index];
  }

  List<double> _calculateColorsStop(List gradientColors) {
    final colorsStopInterval = 1.0 / gradientColors.length;
    return List.generate(
        gradientColors.length, (index) => index * colorsStopInterval);
  }
}

/// [Notification] emitted when graph is hovered
class ElevationHoverNotification extends Notification {
  /// Hovered point coordinates
  final ElevationPoint? position;

  ElevationHoverNotification(this.position);
}

/// Elevation gradient colors
/// Not color is used when gradient is < 10% (graph background color is used [Elevation.color])
class ElevationGradientColors {
  /// Used when elevation gradient is > 10%
  final Color gt10;

  /// Used when elevation gradient is > 20%
  final Color gt20;

  /// Used when elevation gradient is > 30%
  final Color gt30;

  ElevationGradientColors(
      {required this.gt10, required this.gt20, required this.gt30});

  Map<int, Color> toMapValues() {
    return {10: gt10, 20: gt20, 30: gt30};
  }

  Map<String, Color> toMapLabel() {
    return {"Pente > 10%": gt10, "Pente > 20%": gt20, "Pente > 30%": gt30};
  }
}
