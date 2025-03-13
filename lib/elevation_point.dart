import 'package:latlong2/latlong.dart' as lg;

/// Geographic point with elevation
class ElevationPoint extends lg.LatLng {
  /// Altitude (in meters)
  double altitude;

  /// Map of Parameters associated to the point
  /// This field must be build the following way :
  /// {"type": X, "sub_type": Y}
  /// The value assoicated to "type" is an identifier of the parameter type
  /// The value assoicated to "sub_type" is the value this parameter can take
  /// When calling the Elevation widget, you can pass to the "parameterUsedForDisplay" argument the value of the parameter you want to color the graph with (this value must be the same as the one in the "type" field)

  List<Map<String, int>> parameters;

  ElevationPoint(double latitude, double longitude, this.altitude,
      {List<Map<String, int>>? parameters})
      : parameters = parameters ?? [{}],
        super(latitude, longitude);

  lg.LatLng get latLng => this;
}
