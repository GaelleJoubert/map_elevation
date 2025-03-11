import 'elevation_point.dart';
import 'package:latlong2/latlong.dart' as lg;

Map<int, double> getParameterDistributionPercentage(
    {required List<ElevationPoint> points,
    required int parameter,
    required List<int> parameterValues,
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
      if (points[i].parameters["type"] == parameter) {
        distribution[points[i].parameters["sub_type"]!] =
            distribution[points[i].parameters["sub_type"]!]! + 1;
        lastSetParameter = points[i].parameters["sub_type"];
      } else {
        if (!singlePointsCounting && lastSetParameter != null)
          distribution[lastSetParameter] = distribution[lastSetParameter]! + 1;
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
