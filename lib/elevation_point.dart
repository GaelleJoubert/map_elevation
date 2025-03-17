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

  ///Return true if the point has a parameter of the given type
  bool hasParameterType(int parameterType) {
    bool foundType = false;
    this.parameters.forEach((element) {
      if (element["type"] == parameterType) {
        foundType = true;
        return;
      }
    });
    return foundType;
  }

  ///For a given parameter type, upgrade the sub_type value if the parameter is already present, or add it if it is not
  addOrUpgradeParameter(int type, int subType) {
    bool foundType = this.hasParameterType(type);
    if (!foundType) {
      this.parameters.add({"type": type, "sub_type": subType});
    } else {
      this.parameters.forEach((element) {
        if (element["type"] == type) {
          element["sub_type"] = subType;
          return;
        }
      });
    }
  }
}
