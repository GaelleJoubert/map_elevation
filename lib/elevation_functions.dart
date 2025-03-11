import 'elevation_point.dart';

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
