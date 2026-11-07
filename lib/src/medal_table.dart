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
///
/// Without [maxHeight] the table is as tall as all of its rows. When it is
/// placed in a space of limited height, either set [maxHeight] to scroll the
/// rows under a fixed header, or put the table inside a scroll view.
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
  /// When set, each item must provide a matching [TableItemModel.values]
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

  /// Sorts [items] before assigning ranks.
  ///
  /// Rows are compared by [TableItemModel.value] first; rows with an equal
  /// value are then compared by [TableItemModel.values], column by column
  /// (e.g. gold, then silver, then bronze). Rows that are still equal keep
  /// their original order, and rows without a value are always ranked last.
  final bool sortByValue;

  /// Sort direction used when [sortByValue] is true. Defaults to descending
  /// (highest value ranked first).
  final bool descending;

  /// Gives tied rows the same rank, skipping the ranks that follow
  /// (1, 2, 3, 3, 5) — tied rows then also share a medal.
  ///
  /// Rows are tied when they are adjacent and have equal
  /// [TableItemModel.value] and [TableItemModel.values]. When false (the
  /// default) every row gets its own rank (1, 2, 3, 4, 5).
  final bool sharedRanks;

  /// Colors for the medals of ranks 1–3 (gold, silver, bronze).
  ///
  /// Only as many ranks as there are colors (at most three) get a medal; the
  /// others get a numbered badge. Pass an empty list to show badges only.
  final List<Color> medalColors;

  /// Background color for odd rows (1st, 3rd, 5th … row).
  final Color? oddRowColor;

  /// Background color for even rows (2nd, 4th, 6th … row).
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

  /// Color of the [TrendDirection.up] arrow. Defaults to green.
  final Color? trendUpColor;

  /// Color of the [TrendDirection.down] arrow. Defaults to red.
  final Color? trendDownColor;

  /// Color of the [TrendDirection.same] marker. Defaults to the theme's
  /// [ColorScheme.outline].
  final Color? trendSameColor;

  /// When set, rows scroll within this height while the header stays fixed.
  ///
  /// Rows are then built lazily, so only the visible ones are created.
  final double? maxHeight;

  /// Padding applied inside each data row.
  final EdgeInsetsGeometry itemPadding;

  /// Builds the label screen readers announce for each row.
  ///
  /// Defaults to an English label such as "Rank 1, Real Madrid, 15"; provide
  /// this to localize or reword it.
  final MedalTableSemanticsLabelBuilder? semanticsLabelBuilder;

  const MedalTable({
    super.key,
    required this.items,
    required this.leadingTitle,
    required this.labelTitle,
    this.valueTitle = '',
    this.valueTitles,
    this.itemTextStyle,
    this.headerTextStyle,
    this.hideHeader = false,
    this.headerDecoration,
    this.sortByValue = false,
    this.descending = true,
    this.sharedRanks = false,
    this.medalColors = kDefaultMedalColors,
    this.oddRowColor,
    this.evenRowColor,
    this.rowDecoration,
    this.rowSpacing = 2,
    this.leadingFlex = 1,
    this.labelFlex = 2,
    this.valueFlex = 2,
    this.showTrend = false,
    this.trendUpColor,
    this.trendDownColor,
    this.trendSameColor,
    this.maxHeight,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 2),
    this.semanticsLabelBuilder,
  });

  /// Compares two non-null values, falling back to string comparison for
  /// mixed or non-comparable types.
  int _compareValues(Object a, Object b) {
    if (a is num && b is num) return a.compareTo(b);
    if (a is Comparable && b is Comparable && a.runtimeType == b.runtimeType) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b.toString());
  }

  /// Compares two values in ranking order, honoring [descending]. A negative
  /// result means [a] ranks higher. Missing values always rank last.
  int _compareForRank(Object? a, Object? b) {
    if (a == null || b == null) {
      if (a == null && b == null) return 0;
      return a == null ? 1 : -1;
    }
    final int result = _compareValues(a, b);
    return descending ? -result : result;
  }

  /// Compares two items in ranking order: by [TableItemModel.value], then by
  /// [TableItemModel.values] column by column. Zero means the items are tied.
  int _compareItems(TableItemModel a, TableItemModel b) {
    final int byValue = _compareForRank(a.value, b.value);
    if (byValue != 0) return byValue;
    final List<Object?> aValues = a.values ?? const <Object?>[];
    final List<Object?> bValues = b.values ?? const <Object?>[];
    for (int i = 0; i < aValues.length && i < bValues.length; i++) {
      final int result = _compareForRank(aValues[i], bValues[i]);
      if (result != 0) return result;
    }
    return 0;
  }

  List<TableItemModel> _orderedItems() {
    if (!sortByValue) return items;
    // List.sort is not stable, so ties fall back to the original position to
    // keep equal rows in the order they were given.
    final List<int> order = List<int>.generate(items.length, (int i) => i);
    order.sort((int a, int b) {
      final int result = _compareItems(items[a], items[b]);
      return result != 0 ? result : a.compareTo(b);
    });
    return <TableItemModel>[for (final int i in order) items[i]];
  }

  /// 1-based ranks for [ordered], sharing ranks between ties if
  /// [sharedRanks] is set.
  List<int> _ranksFor(List<TableItemModel> ordered) {
    final List<int> ranks = <int>[];
    for (int i = 0; i < ordered.length; i++) {
      final bool tied =
          sharedRanks &&
          i > 0 &&
          _compareItems(ordered[i - 1], ordered[i]) == 0;
      ranks.add(tied ? ranks[i - 1] : i + 1);
    }
    return ranks;
  }

  /// Background for the row at 1-based [position].
  Color? _backgroundFor(TableItemModel item, int position) {
    if (item.highlightColor != null) return item.highlightColor;
    return position.isOdd ? oddRowColor : evenRowColor;
  }

  static int _valueCount(TableItemModel item) => item.values?.length ?? 1;

  /// Throws in debug mode when rows don't have as many values as there are
  /// value columns, which would otherwise silently misalign the columns.
  bool _debugCheckValueColumns(
    List<TableItemModel> ordered,
    List<String> resolvedValueTitles,
  ) {
    if (ordered.isEmpty) return true;
    // Without a header there are no titles to match, but rows must still
    // line up with each other.
    final int expected = hideHeader
        ? _valueCount(ordered.first)
        : resolvedValueTitles.length;
    for (final TableItemModel item in ordered) {
      final int count = _valueCount(item);
      if (count == expected) continue;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('MedalTable value columns are misaligned.'),
        ErrorDescription(
          hideHeader
              ? 'The row "${item.title}" has $count value(s), but the row '
                    '"${ordered.first.title}" has $expected.'
              : 'The row "${item.title}" has $count value(s), but the header '
                    'has $expected value column(s).',
        ),
        ErrorHint(
          'Give every TableItemModel.values list the same length as '
          'MedalTable.valueTitles.',
        ),
      ]);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<TableItemModel> ordered = _orderedItems();
    final List<int> ranks = _ranksFor(ordered);
    final List<String> resolvedValueTitles =
        valueTitles ?? <String>[valueTitle];
    assert(_debugCheckValueColumns(ordered, resolvedValueTitles));

    Widget buildRow(int index) {
      final TableItemModel item = ordered[index];
      return TableItem(
        item: item,
        rank: ranks[index],
        itemTextStyle: itemTextStyle,
        medalColors: medalColors,
        backgroundColor: _backgroundFor(item, index + 1),
        decoration: rowDecoration,
        leadingFlex: leadingFlex,
        labelFlex: labelFlex,
        valueFlex: valueFlex,
        showTrend: showTrend,
        padding: itemPadding,
        trendUpColor: trendUpColor,
        trendDownColor: trendDownColor,
        trendSameColor: trendSameColor,
        semanticsLabelBuilder: semanticsLabelBuilder,
      );
    }

    final Widget rowsArea = maxHeight != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight!),
            child: ListView.separated(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.zero,
              itemCount: ordered.length,
              itemBuilder: (BuildContext context, int index) => buildRow(index),
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: rowSpacing),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < ordered.length; i++) ...[
                if (i > 0 && rowSpacing > 0) SizedBox(height: rowSpacing),
                buildRow(i),
              ],
            ],
          );

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
