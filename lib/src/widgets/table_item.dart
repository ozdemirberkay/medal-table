import 'package:flutter/material.dart';

import '../models/table_item_model.dart';
import 'table_header.dart';

/// Icons for the medal ranks, in rank order.
const List<IconData> _medalIcons = <IconData>[
  Icons.looks_one,
  Icons.looks_two,
  Icons.looks_3,
];

/// A single data row of a [MedalTable].
class TableItem extends StatelessWidget {
  final TableItemModel item;

  /// 1-based rank used to pick the default medal / badge.
  final int rank;

  final TextStyle? itemTextStyle;
  final List<Color> medalColors;

  /// Resolved background color (highlight or alternating), or null.
  final Color? backgroundColor;

  /// Extra decoration applied to the row (merged over [backgroundColor]).
  final BoxDecoration? decoration;

  final int leadingFlex;
  final int labelFlex;
  final int valueFlex;
  final bool showTrend;
  final EdgeInsetsGeometry padding;

  /// Trend arrow colors; null falls back to the defaults.
  final Color? trendUpColor;
  final Color? trendDownColor;
  final Color? trendSameColor;

  /// Overrides the default screen-reader label when non-null.
  final MedalTableSemanticsLabelBuilder? semanticsLabelBuilder;

  const TableItem({
    super.key,
    required this.item,
    required this.rank,
    required this.itemTextStyle,
    required this.medalColors,
    required this.backgroundColor,
    required this.decoration,
    this.leadingFlex = 1,
    this.labelFlex = 2,
    this.valueFlex = 2,
    this.showTrend = false,
    this.padding = const EdgeInsets.symmetric(vertical: 2),
    this.trendUpColor,
    this.trendDownColor,
    this.trendSameColor,
    this.semanticsLabelBuilder,
  });

  List<Object?> get _values => item.values ?? <Object?>[item.value];

  /// A medal for ranks that have a medal color, a numbered badge otherwise.
  Widget _defaultLeading(BuildContext context) {
    if (rank <= _medalIcons.length && rank <= medalColors.length) {
      return CircleAvatar(
        backgroundColor: medalColors[rank - 1],
        child: Icon(_medalIcons[rank - 1], color: Colors.white),
      );
    }
    final ColorScheme colors = Theme.of(context).colorScheme;
    return CircleAvatar(
      backgroundColor: colors.surfaceContainerHighest,
      child: Text(
        '$rank',
        style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _valueText(Object? value) {
    return Text(
      value?.toString() ?? '',
      textAlign: TextAlign.center,
      style: itemTextStyle,
    );
  }

  Widget? _trendIcon(BuildContext context) {
    switch (item.trend) {
      case TrendDirection.up:
        return Icon(
          Icons.arrow_upward,
          size: 16,
          color: trendUpColor ?? Colors.green,
        );
      case TrendDirection.down:
        return Icon(
          Icons.arrow_downward,
          size: 16,
          color: trendDownColor ?? Colors.red,
        );
      case TrendDirection.same:
        return Icon(
          Icons.remove,
          size: 16,
          color: trendSameColor ?? Theme.of(context).colorScheme.outline,
        );
      case TrendDirection.none:
        return null;
    }
  }

  String _defaultSemanticsLabel() {
    return <String?>[
      'Rank $rank',
      item.title,
      for (final value in _values)
        if (value != null) value.toString(),
      if (showTrend)
        switch (item.trend) {
          TrendDirection.up => 'moving up',
          TrendDirection.down => 'moving down',
          TrendDirection.same => 'no change',
          TrendDirection.none => null,
        },
    ].nonNulls.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final Row row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: leadingFlex,
          child: item.leading ?? _defaultLeading(context),
        ),
        Expanded(
          flex: labelFlex,
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: itemTextStyle,
          ),
        ),
        Expanded(
          flex: valueFlex,
          child: Row(
            children: [
              for (final value in _values) Expanded(child: _valueText(value)),
            ],
          ),
        ),
        if (showTrend)
          SizedBox(
            width: kTrendColumnWidth,
            child: _trendIcon(context) ?? const SizedBox.shrink(),
          ),
      ],
    );

    final BoxDecoration? resolvedDecoration = decoration != null
        ? decoration!.copyWith(color: decoration!.color ?? backgroundColor)
        : (backgroundColor != null
              ? BoxDecoration(color: backgroundColor)
              : null);

    final bool tappable = item.onItemPressed != null;

    // Tappable rows paint their background with Ink, on the same Material
    // layer as the ripple, so the ripple is drawn on top instead of being
    // hidden behind an opaque Container.
    final Widget content = tappable
        ? Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: item.onItemPressed,
              borderRadius: resolvedDecoration?.borderRadius?.resolve(
                Directionality.maybeOf(context),
              ),
              child: Ink(
                decoration: resolvedDecoration,
                padding: padding,
                child: row,
              ),
            ),
          )
        : Container(
            decoration: resolvedDecoration,
            padding: padding,
            child: row,
          );

    // The row is announced once with a single label; the cells' own text is
    // excluded so screen readers don't read every value twice.
    return Semantics(
      container: true,
      excludeSemantics: true,
      button: tappable,
      label:
          semanticsLabelBuilder?.call(item, rank) ?? _defaultSemanticsLabel(),
      onTap: item.onItemPressed,
      child: content,
    );
  }
}
