import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final TextStyle? headerTextStyle;
  final BoxDecoration? headerBoxDecoration;
  final String leadingTitle;
  final String labelTitle;
  final String valueTitle;
  const TableHeader({
    super.key,
    required this.headerTextStyle,
    required this.headerBoxDecoration,
    required this.leadingTitle,
    required this.labelTitle,
    required this.valueTitle,
  });

  /// Single header element widget
  Widget headerElement(String title, int flex) {
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
          headerElement(leadingTitle, 1),
          headerElement(labelTitle, 2),
          headerElement(valueTitle, 2),
        ],
      ),
    );
  }
}
