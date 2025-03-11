import 'package:flutter/cupertino.dart';

class ElevationLegend extends StatelessWidget {
  /// Map of of the values the parameter can take and the color associated
  final Map<String, Color>? parameterLabelAndColorsMap;

  /// List of a second text we might add to the legend, must match the order of the parameterLabelAndColorsMap
  final List<String> secondLegendTextList;

  /// Number of columns in the legend, is set to 3 by default
  final int columns;

  /// TextStyle of the label
  final TextStyle labelTextStyle;

  /// TextStyle of the second text
  final TextStyle secondTextStyle;

  ///Padding of one legend element
  final EdgeInsetsGeometry padding;
  ElevationLegend(
      {super.key,
      this.parameterLabelAndColorsMap,
      this.columns = 3,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
      required this.secondLegendTextList,
      this.labelTextStyle = const TextStyle(fontWeight: FontWeight.bold),
      this.secondTextStyle = const TextStyle()});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0;
              i < (parameterLabelAndColorsMap!.length);
              i += ((parameterLabelAndColorsMap!.length / columns).ceil()))
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int j = 0;
                    j < (parameterLabelAndColorsMap!.length / columns).ceil();
                    j++)
                  if (i + j < parameterLabelAndColorsMap!.length)
                    _legendElement(
                      padding: padding,
                      color:
                          parameterLabelAndColorsMap!.values.elementAt(i + j),
                      label: parameterLabelAndColorsMap!.keys.elementAt(i + j),
                      secondText: secondLegendTextList.isNotEmpty
                          ? secondLegendTextList[i + j]
                          : null,
                      labelTextStyle: labelTextStyle,
                      secondTextStyle: secondTextStyle,
                    ),
              ],
            )
        ],
      ),
    );
  }
}

class _legendElement extends StatelessWidget {
  final Color color;
  final String label;
  final String? secondText;
  final TextStyle labelTextStyle;
  final TextStyle secondTextStyle;
  final EdgeInsetsGeometry padding;
  const _legendElement(
      {required this.color,
      required this.label,
      required this.secondText,
      required this.padding,
      required this.labelTextStyle,
      required this.secondTextStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(4),
            width: 20,
            height: 20,
            color: color,
          ),
          Text(
            label,
            style: labelTextStyle,
          ),
          if (secondText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                secondText!,
                style: secondTextStyle,
              ),
            ),
        ],
      ),
    );
  }
}
