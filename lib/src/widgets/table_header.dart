import 'package:flutter/material.dart';

/// Width reserved for the trend column so headers and rows stay aligned.
const double kTrendColumnWidth = 24;

/// The header row of a [MedalTable].
class TableHeader extends StatelessWidget {
  final TextStyle? headerTextStyle;
  final BoxDecoration? headerBoxDecoration;
  final String leadingTitle;
  final String labelTitle;

  /// One or more value column titles.
  final List<String> valueTitles;

  final int leadingFlex;
  final int labelFlex;
  final int valueFlex;

  /// Whether a trend column is present and space should be reserved for it.
  final bool showTrend;

  const TableHeader({
    super.key,
    required this.headerTextStyle,
    required this.headerBoxDecoration,
    required this.leadingTitle,
    required this.labelTitle,
    required this.valueTitles,
    this.leadingFlex = 1,
    this.labelFlex = 2,
    this.valueFlex = 2,
    this.showTrend = false,
  });

  /// Single header cell that expands to fill its share of the row.
  Widget _cell(String title, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: headerTextStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: headerBoxDecoration,
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        children: [
          _cell(leadingTitle, leadingFlex),
          _cell(labelTitle, labelFlex),
          Expanded(
            flex: valueFlex,
            child: Row(
              children: [
                for (final title in valueTitles)
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: headerTextStyle,
                    ),
                  ),
              ],
            ),
          ),
          if (showTrend) const SizedBox(width: kTrendColumnWidth),
        ],
      ),
    );
  }
}
