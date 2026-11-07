import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Direction of a rank's movement between periods.
///
/// Rendered as an arrow next to a row when [MedalTable.showTrend] is enabled.
enum TrendDirection {
  /// The rank improved (moved up).
  up,

  /// The rank dropped (moved down).
  down,

  /// The rank did not change.
  same,

  /// No trend information — nothing is rendered.
  none,
}

/// Default medal colors used for the top three ranks: gold, silver and bronze.
///
/// These are warm, metallic tones chosen to read as real medals while keeping
/// the white leading icon/number legible on top.
const List<Color> kDefaultMedalColors = <Color>[
  Color(0xffD4AF37), // gold   — metallic gold
  Color(0xff9BA1AB), // silver — cool metallic silver
  Color(0xffB26A2B), // bronze — deep copper bronze
];

/// Builds the screen-reader label of a row from its [item] and 1-based [rank].
///
/// Used by [MedalTable.semanticsLabelBuilder], e.g. to localize the label.
typedef MedalTableSemanticsLabelBuilder =
    String Function(TableItemModel item, int rank);

/// A single row of a [MedalTable].
///
/// The model is immutable; use [copyWith] to derive a modified copy.
@immutable
class TableItemModel {
  /// Title of the element, e.g. the team or entity name.
  final String title;

  /// Primary value shown in the value column.
  ///
  /// Ignored for display when [values] is provided. May be any type; it is
  /// rendered via [Object.toString]. When [MedalTable.sortByValue] is enabled
  /// rows are sorted by this field first, then by [values].
  final Object? value;

  /// Optional multiple values, rendered as several value columns.
  ///
  /// When provided, [MedalTable.valueTitles] supplies the column headers and
  /// its length must match this list's length. Takes precedence over [value]
  /// for display.
  final List<Object?>? values;

  /// Called when the row is tapped. When null the row is not interactive.
  final VoidCallback? onItemPressed;

  /// Custom leading widget.
  ///
  /// When null, a medal is shown for the top three ranks and a numbered badge
  /// for the rest.
  final Widget? leading;

  /// When non-null, the row background is painted with this color, overriding
  /// any alternating row color.
  final Color? highlightColor;

  /// Rank movement indicator, rendered when [MedalTable.showTrend] is true.
  final TrendDirection trend;

  const TableItemModel({
    required this.title,
    this.value,
    this.values,
    this.onItemPressed,
    this.leading,
    this.highlightColor,
    this.trend = TrendDirection.none,
  });

  /// Returns a copy of this item with the given fields replaced.
  ///
  /// A `null` argument keeps the current value. To remove an optional field,
  /// set its `clear…` flag instead, e.g. `copyWith(clearHighlightColor: true)`.
  TableItemModel copyWith({
    String? title,
    Object? value,
    List<Object?>? values,
    VoidCallback? onItemPressed,
    Widget? leading,
    Color? highlightColor,
    TrendDirection? trend,
    bool clearValue = false,
    bool clearValues = false,
    bool clearOnItemPressed = false,
    bool clearLeading = false,
    bool clearHighlightColor = false,
  }) {
    assert(!clearValue || value == null, 'Pass value or clearValue, not both.');
    assert(
      !clearValues || values == null,
      'Pass values or clearValues, not both.',
    );
    assert(
      !clearOnItemPressed || onItemPressed == null,
      'Pass onItemPressed or clearOnItemPressed, not both.',
    );
    assert(
      !clearLeading || leading == null,
      'Pass leading or clearLeading, not both.',
    );
    assert(
      !clearHighlightColor || highlightColor == null,
      'Pass highlightColor or clearHighlightColor, not both.',
    );
    return TableItemModel(
      title: title ?? this.title,
      value: clearValue ? null : value ?? this.value,
      values: clearValues ? null : values ?? this.values,
      onItemPressed: clearOnItemPressed
          ? null
          : onItemPressed ?? this.onItemPressed,
      leading: clearLeading ? null : leading ?? this.leading,
      highlightColor: clearHighlightColor
          ? null
          : highlightColor ?? this.highlightColor,
      trend: trend ?? this.trend,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableItemModel &&
        other.title == title &&
        other.value == value &&
        listEquals(other.values, values) &&
        other.onItemPressed == onItemPressed &&
        other.leading == leading &&
        other.highlightColor == highlightColor &&
        other.trend == trend;
  }

  @override
  int get hashCode => Object.hash(
    title,
    value,
    values == null ? null : Object.hashAll(values!),
    onItemPressed,
    leading,
    highlightColor,
    trend,
  );

  @override
  String toString() =>
      'TableItemModel(title: $title, value: ${values ?? value}, trend: $trend)';
}
