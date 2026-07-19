import 'package:flutter/material.dart';

import '../models/table_item_model.dart';
import 'table_header.dart';

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
  });

  List<Object?> get _values => item.values ?? <Object?>[item.value];

  Widget _valueText(Object? value) {
    return Text(
      value?.toString() ?? '',
      textAlign: TextAlign.center,
      style: itemTextStyle,
    );
  }

  Widget? _trendIcon() {
    switch (item.trend) {
      case TrendDirection.up:
        return const Icon(Icons.arrow_upward, size: 16, color: Colors.green);
      case TrendDirection.down:
        return const Icon(Icons.arrow_downward, size: 16, color: Colors.red);
      case TrendDirection.same:
        return const Icon(Icons.remove, size: 16, color: Colors.grey);
      case TrendDirection.none:
        return null;
    }
  }

  String _semanticsLabel() {
    final values = _values.map((v) => v?.toString() ?? '').join(', ');
    return 'Rank $rank, ${item.title}, $values';
  }

  @override
  Widget build(BuildContext context) {
    final Row row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: leadingFlex,
          child: item.leading ?? buildDefaultLeading(rank, medalColors),
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
              for (final value in _values)
                Expanded(child: _valueText(value)),
            ],
          ),
        ),
        if (showTrend)
          SizedBox(
            width: kTrendColumnWidth,
            child: _trendIcon() ?? const SizedBox.shrink(),
          ),
      ],
    );

    final BoxDecoration? resolvedDecoration = decoration != null
        ? decoration!.copyWith(color: decoration!.color ?? backgroundColor)
        : (backgroundColor != null
              ? BoxDecoration(color: backgroundColor)
              : null);

    final Widget content = Container(
      decoration: resolvedDecoration,
      padding: padding,
      child: row,
    );

    final Widget interactive = item.onItemPressed != null
        ? Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: item.onItemPressed, child: content),
          )
        : content;

    return Semantics(
      button: item.onItemPressed != null,
      label: _semanticsLabel(),
      child: interactive,
    );
  }
}
