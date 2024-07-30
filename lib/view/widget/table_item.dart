import 'package:flutter/material.dart';
import 'package:medal_table/model/table_item_model.dart';

class TableItem extends StatelessWidget {
  final TableItemModel tableItemModel;
  final TextStyle? itemTextStyle;
  final Widget defaultLeading;
  const TableItem(
      {super.key,
      required this.tableItemModel,
      required this.itemTextStyle,
      required this.defaultLeading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tableItemModel.onItemPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: tableItemModel.leading ?? defaultLeading,
          ),
          Expanded(
            flex: 2,
            child: Text(
              tableItemModel.title,
              textAlign: TextAlign.center,
              style: itemTextStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: tableItemModel.value != null
                ? Text(
                    tableItemModel.value.toString(),
                    style: itemTextStyle,
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
