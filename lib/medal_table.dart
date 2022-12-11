import 'package:flutter/material.dart';

class MedalTable extends StatelessWidget {
  final String firstLabel;
  final String secondLabel;
  final String thirdLabel;
  final dynamic firstValue;
  final dynamic secondValue;
  final dynamic thirdValue;
  final VoidCallback? firstPressed;
  final VoidCallback? secondPressed;
  final VoidCallback? thirdPressed;
  final Widget? firstLeading;
  final Widget? secondLeading;
  final Widget? thirdLeading;
  final String? leadingTitle;
  final String? labelTitle;
  final String? valueTitle;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final TextStyle? headerTextStyle;
  final bool hideHeader;
  final BoxDecoration? headerDecoration;

  const MedalTable({
    Key? key,
    required this.firstLabel,
    required this.secondLabel,
    required this.thirdLabel,
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.firstPressed,
    this.secondPressed,
    this.thirdPressed,
    this.firstLeading,
    this.secondLeading,
    this.thirdLeading,
    this.valueTitle,
    this.leadingTitle,
    this.labelTitle,
    this.textStyle,
    this.headerTextStyle,
    this.backgroundColor,
    this.hideHeader = false,
    this.headerDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        children: [
          hideHeader
              ? const SizedBox()
              : Container(
                  decoration: headerDecoration,
                  padding: leadingTitle != null ||
                          labelTitle != null ||
                          valueTitle != null
                      ? const EdgeInsets.symmetric(vertical: 5, horizontal: 5)
                      : null,
                  margin: leadingTitle != null ||
                          labelTitle != null ||
                          valueTitle != null
                      ? const EdgeInsets.only(bottom: 5)
                      : null,
                  child: Row(
                    children: [
                      leadingTitle != null
                          ? Expanded(
                              child: Text(
                                leadingTitle!,
                                textAlign: TextAlign.left,
                                style: headerTextStyle,
                              ),
                            )
                          : const SizedBox(),
                      labelTitle != null
                          ? Expanded(
                              child: Text(
                                labelTitle!,
                                textAlign: TextAlign.center,
                                style: headerTextStyle,
                              ),
                            )
                          : const SizedBox(),
                      valueTitle != null
                          ? Expanded(
                              child: Text(
                                valueTitle!,
                                textAlign: TextAlign.right,
                                style: headerTextStyle,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: GestureDetector(
              onTap: firstPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  firstLeading ??
                      const CircleAvatar(
                        backgroundColor: Color(0xffFEE101),
                        child: Icon(
                          Icons.looks_one,
                          color: Colors.white,
                        ),
                      ),
                  Expanded(
                    child: Text(
                      firstLabel,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  firstValue != null
                      ? Text(
                          firstValue.toString(),
                          style: textStyle,
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: GestureDetector(
              onTap: secondPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  secondLeading ??
                      const CircleAvatar(
                        backgroundColor: Color(0xffA7A7AD),
                        child: Icon(
                          Icons.looks_two,
                          color: Colors.white,
                        ),
                      ),
                  Expanded(
                    child: Text(
                      secondLabel,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  secondValue != null
                      ? Text(
                          secondValue.toString(),
                          style: textStyle,
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: GestureDetector(
              onTap: thirdPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  thirdLeading ??
                      const CircleAvatar(
                        backgroundColor: Color(0xffA77044),
                        child: Icon(
                          Icons.looks_3,
                          color: Colors.white,
                        ),
                      ),
                  Expanded(
                    child: Text(
                      thirdLabel,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                  thirdValue != null
                      ? Text(
                          thirdValue.toString(),
                          style: textStyle,
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
