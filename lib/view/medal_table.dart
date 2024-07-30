import 'package:flutter/material.dart';
import 'package:medal_table/model/table_item_model.dart';
import 'package:medal_table/view/widget/table_header.dart';
import 'package:medal_table/view/widget/table_item.dart';

class MedalTable extends StatelessWidget {
  /// Title of the first column of the table
  final String leadingTitle;

  /// Title of the second column of the table
  final String labelTitle;

  /// Title of the third column of the table
  final String valueTitle;

  /// Text style of lines
  final TextStyle? itemTextStyle;

  /// Text style of header
  final TextStyle? headerTextStyle;

  /// Option to hide the titles
  final bool hideHeader;

  /// Decoration of the header
  final BoxDecoration? headerDecoration;

  /// First line item
  final TableItemModel firstItem;

  /// Second line item
  final TableItemModel secondItem;

  /// Third line item
  final TableItemModel thirdItem;

  const MedalTable({
    Key? key,
    required this.firstItem,
    required this.secondItem,
    required this.thirdItem,
    required this.leadingTitle,
    required this.valueTitle,
    required this.labelTitle,
    this.itemTextStyle,
    this.headerTextStyle,
    this.hideHeader = false,
    this.headerDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hideHeader)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: TableHeader(
              leadingTitle: leadingTitle,
              labelTitle: labelTitle,
              valueTitle: valueTitle,
              headerBoxDecoration: headerDecoration,
              headerTextStyle: headerTextStyle,
            ),
          ),
        TableItem(
          tableItemModel: firstItem,
          itemTextStyle: itemTextStyle,
          defaultLeading: defaultMedalLeading[0],
        ),
        const SizedBox(height: 2),
        TableItem(
          tableItemModel: secondItem,
          itemTextStyle: itemTextStyle,
          defaultLeading: defaultMedalLeading[1],
        ),
        const SizedBox(height: 2),
        TableItem(
          tableItemModel: thirdItem,
          itemTextStyle: itemTextStyle,
          defaultLeading: defaultMedalLeading[2],
        ),
      ],
    );
  }
}
