import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class TextView extends StatelessWidget {
  const TextView({
    Key? key,
    required this.title,
    required this.size,
    required this.weight,
    this.color = ColorsRes.primaryText,
    this.align = TextAlign.center,
    this.lines,
    this.overflow,
    this.decoration,
  }) : super(key: key);

  final String title;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextAlign align;
  final int? lines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr(),
      textAlign: align,
      maxLines: lines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontFamily: StringsRes.fontFamily,
        fontSize: size,
        fontWeight: weight,
        decoration: decoration,
        decorationColor: Colors.black,
        decorationThickness: 2.0,
        decorationStyle: TextDecorationStyle.double,
      ),
    );
  }
}
