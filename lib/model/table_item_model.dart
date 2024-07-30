import 'package:flutter/material.dart';

class TableItemModel {
  /// Value of the element
  dynamic value;

  /// Title of the element
  String title;

  /// Action to be taken when the element is pressed
  VoidCallback? onItemPressed;

  /// Leading widget of the element
  Widget? leading;

  TableItemModel(
      {required this.title,
      required this.value,
      this.onItemPressed,
      this.leading});
}

/// Default leading widgets in the table
List<Widget> defaultMedalLeading = [
  const CircleAvatar(
    backgroundColor: Color(0xffFEE101),
    child: Icon(
      Icons.looks_one,
      color: Colors.white,
    ),
  ),
  const CircleAvatar(
    backgroundColor: Color(0xffA7A7AD),
    child: Icon(
      Icons.looks_two,
      color: Colors.white,
    ),
  ),
  const CircleAvatar(
    backgroundColor: Color(0xffA77044),
    child: Icon(
      Icons.looks_3,
      color: Colors.white,
    ),
  ),
];
