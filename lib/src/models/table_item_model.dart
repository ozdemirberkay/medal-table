import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

/// A single row of a [MedalTable].
///
/// The model is immutable; use [copyWith] to derive a modified copy.
@immutable
class TableItemModel {
  /// Title of the element, e.g. the team or entity name.
  final String title;

  /// Primary value shown in the value column.
  ///
  /// Ignored when [values] is provided. May be any type; it is rendered via
  /// [Object.toString]. When [MedalTable.sortByValue] is enabled this is the
  /// field the rows are sorted by.
  final Object? value;

  /// Optional multiple values, rendered as several value columns.
  ///
  /// When provided, [MedalTable.valueTitles] supplies the column headers and
  /// its length should match this list's length. Takes precedence over
  /// [value].
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
  TableItemModel copyWith({
    String? title,
    Object? value,
    List<Object?>? values,
    VoidCallback? onItemPressed,
    Widget? leading,
    Color? highlightColor,
    TrendDirection? trend,
  }) {
    return TableItemModel(
      title: title ?? this.title,
      value: value ?? this.value,
      values: values ?? this.values,
      onItemPressed: onItemPressed ?? this.onItemPressed,
      leading: leading ?? this.leading,
      highlightColor: highlightColor ?? this.highlightColor,
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

/// Builds the default leading widget for a given [rank] (1-based).
///
/// Ranks 1–3 get a medal-colored avatar; the rest get a numbered badge.
/// [medalColors] must contain at least three colors for the medal ranks.
Widget buildDefaultLeading(int rank, List<Color> medalColors) {
  const List<IconData> medalIcons = <IconData>[
    Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
  ];
  if (rank >= 1 && rank <= 3 && medalColors.length >= 3) {
    return CircleAvatar(
      backgroundColor: medalColors[rank - 1],
      child: Icon(medalIcons[rank - 1], color: Colors.white),
    );
  }
  return CircleAvatar(
    backgroundColor: const Color(0xffE0E0E0),
    child: Text(
      '$rank',
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
