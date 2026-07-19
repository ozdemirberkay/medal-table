import 'package:flutter/material.dart';

import 'models/table_item_model.dart';
import 'widgets/table_header.dart';
import 'widgets/table_item.dart';

/// A ranking ("medal") table.
///
/// Renders an arbitrary number of [items] as ranked rows. The top three ranks
/// receive gold, silver and bronze medals; the rest get a numbered badge.
///
/// ```dart
/// MedalTable(
///   leadingTitle: 'Rank',
///   labelTitle: 'Team',
///   valueTitle: 'UCL Titles',
///   sortByValue: true,
///   items: const [
///     TableItemModel(title: 'Real Madrid', value: 15),
///     TableItemModel(title: 'Milan', value: 7),
///     TableItemModel(title: 'Liverpool', value: 6),
///     TableItemModel(title: 'Bayern', value: 6),
///   ],
/// )
/// ```
class MedalTable extends StatelessWidget {
  /// Rows of the table, in display order unless [sortByValue] is set.
  final List<TableItemModel> items;

  /// Title of the leading (rank) column.
  final String leadingTitle;

  /// Title of the label (name) column.
  final String labelTitle;

  /// Title of the single value column.
  ///
  /// Ignored when [valueTitles] is provided.
  final String valueTitle;

  /// Titles for multiple value columns.
  ///
  /// When set, each item should provide a matching [TableItemModel.values]
  /// list of the same length.
  final List<String>? valueTitles;

  /// Text style for data rows.
  final TextStyle? itemTextStyle;

  /// Text style for the header row.
  final TextStyle? headerTextStyle;

  /// Hides the header row when true.
  final bool hideHeader;

  /// Decoration for the header container.
  final BoxDecoration? headerDecoration;

  /// Sorts [items] by [TableItemModel.value] before assigning ranks.
  final bool sortByValue;

  /// Sort direction used when [sortByValue] is true. Defaults to descending
  /// (highest value ranked first).
  final bool descending;

  /// Colors for the top three medals (gold, silver, bronze).
  final List<Color> medalColors;

  /// Background color for odd rows (rank 1, 3, 5 …).
  final Color? oddRowColor;

  /// Background color for even rows (rank 2, 4, 6 …).
  final Color? evenRowColor;

  /// Extra decoration applied to every data row.
  final BoxDecoration? rowDecoration;

  /// Vertical gap between consecutive rows.
  final double rowSpacing;

  /// Flex of the leading (rank) column.
  final int leadingFlex;

  /// Flex of the label (name) column.
  final int labelFlex;

  /// Flex of the value column.
  final int valueFlex;

  /// Renders a per-row trend arrow based on [TableItemModel.trend].
  final bool showTrend;

  /// When set, rows scroll within this height while the header stays fixed.
  final double? maxHeight;

  /// Padding applied inside each data row.
  final EdgeInsetsGeometry itemPadding;

  const MedalTable({
    super.key,
    required this.items,
    required this.leadingTitle,
    required this.labelTitle,
    required this.valueTitle,
    this.valueTitles,
    this.itemTextStyle,
    this.headerTextStyle,
    this.hideHeader = false,
    this.headerDecoration,
    this.sortByValue = false,
    this.descending = true,
    this.medalColors = kDefaultMedalColors,
    this.oddRowColor,
    this.evenRowColor,
    this.rowDecoration,
    this.rowSpacing = 2,
    this.leadingFlex = 1,
    this.labelFlex = 2,
    this.valueFlex = 2,
    this.showTrend = false,
    this.maxHeight,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 2),
  });

  /// Compares two values for sorting, falling back to string comparison for
  /// mixed or non-comparable types.
  int _compareValues(Object? a, Object? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    if (a is num && b is num) return a.compareTo(b);
    if (a is Comparable && b is Comparable && a.runtimeType == b.runtimeType) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b.toString());
  }

  List<TableItemModel> _orderedItems() {
    if (!sortByValue) return items;
    final List<TableItemModel> sorted = List<TableItemModel>.of(items);
    sorted.sort((a, b) {
      final int result = _compareValues(a.value, b.value);
      return descending ? -result : result;
    });
    return sorted;
  }

  Color? _backgroundFor(TableItemModel item, int rank) {
    if (item.highlightColor != null) return item.highlightColor;
    if (oddRowColor == null && evenRowColor == null) return null;
    return rank.isOdd ? oddRowColor : evenRowColor;
  }

  @override
  Widget build(BuildContext context) {
    final List<TableItemModel> ordered = _orderedItems();
    final List<String> resolvedValueTitles = valueTitles ?? <String>[valueTitle];

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < ordered.length; i++) {
      final int rank = i + 1;
      final TableItemModel item = ordered[i];
      rows.add(
        TableItem(
          item: item,
          rank: rank,
          itemTextStyle: itemTextStyle,
          medalColors: medalColors,
          backgroundColor: _backgroundFor(item, rank),
          decoration: rowDecoration,
          leadingFlex: leadingFlex,
          labelFlex: labelFlex,
          valueFlex: valueFlex,
          showTrend: showTrend,
          padding: itemPadding,
        ),
      );
      if (i < ordered.length - 1 && rowSpacing > 0) {
        rows.add(SizedBox(height: rowSpacing));
      }
    }

    final Widget rowsColumn = Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );

    final Widget rowsArea = maxHeight != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight!),
            child: SingleChildScrollView(child: rowsColumn),
          )
        : rowsColumn;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hideHeader)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: TableHeader(
              leadingTitle: leadingTitle,
              labelTitle: labelTitle,
              valueTitles: resolvedValueTitles,
              headerBoxDecoration: headerDecoration,
              headerTextStyle: headerTextStyle,
              leadingFlex: leadingFlex,
              labelFlex: labelFlex,
              valueFlex: valueFlex,
              showTrend: showTrend,
            ),
          ),
        rowsArea,
      ],
    );
  }
}
