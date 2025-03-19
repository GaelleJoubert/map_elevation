import 'elevation_point.dart';
import 'package:latlong2/latlong.dart' as lg;

/// Return the distribution of the values a parameter can take in a list of ElevationPoint, in the form of a Map with the percentage of each value
/// {value1: percentage1, value2: percentage2, ...}
Map<int, double> getParameterDistributionPercentage(
    {required List<ElevationPoint> points,

    /// The value of the parameter. It's the value of the "type" field in the parameters list of the ElevationPoint
    required int parameter,

    /// The values the parameter can take. It's the value of the "sub_type" field in the parameters list of the ElevationPoint
    required List<int> parameterValues,

    /// If set to true, we only count the points that have the parameter. If set to false, we count all the points after a parameter is set, until we find another parameter
    bool singlePointsCounting = false}) {
  Map<int, double> distribution = {};
  //We assign the parameter values to the distribution map
  for (int i = 0; i < parameterValues.length; i++) {
    distribution[parameterValues[i]] = 0;
  }
  //We fill the distribution map
  // If singlePointCounting is set to false: We don't count just the point that have the parameter, we also count all the point after it, until we find another parameter
  int? lastSetParameter;
  for (int i = 0; i < points.length; i++) {
    if (points[i].parameters.isNotEmpty) {
      for (int j = 0; j < points[i].parameters.length; j++) {
        if (points[i].parameters[j]["type"] == parameter) {
          distribution[points[i].parameters[j]["sub_type"]!] =
              distribution[points[i].parameters[j]["sub_type"]!]! + 1;
          lastSetParameter = points[i].parameters[j]["sub_type"];
        } else {
          if (!singlePointsCounting && lastSetParameter != null)
            distribution[lastSetParameter] =
                distribution[lastSetParameter]! + 1;
        }
      }
    } else {
      if (!singlePointsCounting && lastSetParameter != null)
        distribution[lastSetParameter] = distribution[lastSetParameter]! + 1;
    }
  }
  //We calculate the percentage
  for (int i = 0; i < parameterValues.length; i++) {
    distribution[parameterValues[i]] =
        distribution[parameterValues[i]]! / points.length;
  }
  return distribution;
}

/// Return the distribution of the values a parameter can take in a list of ElevationPoint, in the form of a List of String with the percentage of each value
List<String> getParameterDistributionPercentageString(
    {required List<ElevationPoint> points,
    required int parameter,
    required List<int> parameterValues,
    bool singlePointsCounting = false}) {
  Map<int, double> distribution = getParameterDistributionPercentage(
      points: points,
      parameter: parameter,
      parameterValues: parameterValues,
      singlePointsCounting: singlePointsCounting);
  List<String> distributionString = [];
  for (int i = 0; i < parameterValues.length; i++) {
    distributionString.add(
        "${(distribution[parameterValues[i]]! * 100).toStringAsFixed(2)}%");
  }
  return distributionString;
}

/// Return the distribution of the elevation gradient in a list of ElevationPoint, in the form of a Map with the percentage of each value
/// {10: percentage1, 20: percentage2, 30: percentage3}
Map<int, double> getElevationDistributionPercentage(
    {required List<ElevationPoint> points}) {
  Map<int, double> distribution = {};

  //We assign the parameter values to the distribution map
  distribution[10] = 0;
  distribution[20] = 0;
  distribution[30] = 0;

  //We fill the distribution map
  for (int i = 1; i < points.length; i++) {
    double dX = lg.Distance().distance(points[i], points[i - 1]);
    double dZ = (points[i].altitude - points[i - 1].altitude);
    double gradient = 100 * dZ / dX;
    if (gradient > 30) {
      distribution[30] = distribution[30]! + 1;
    } else if (gradient > 20) {
      distribution[20] = distribution[20]! + 1;
    } else if (gradient > 10) {
      distribution[10] = distribution[10]! + 1;
    }
  }

  //We calculate the percentage

  distribution[10] = distribution[10]! / points.length;
  distribution[20] = distribution[20]! / points.length;
  distribution[30] = distribution[30]! / points.length;

  return distribution;
}

/// Return the distribution of the elevation gradient in a list of ElevationPoint, in the form of a List of String with the percentage of each value
List<String> getElevationDistributionPercentageString(
    {required List<ElevationPoint> points}) {
  Map<int, double> distribution =
      getElevationDistributionPercentage(points: points);
  List<String> distributionString = [];
  distributionString.add("${(distribution[10]! * 100).toStringAsFixed(2)}%");
  distributionString.add("${(distribution[20]! * 100).toStringAsFixed(2)}%");
  distributionString.add("${(distribution[30]! * 100).toStringAsFixed(2)}%");
  return distributionString;
}
