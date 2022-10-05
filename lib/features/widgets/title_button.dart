import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TitleButton extends StatelessWidget {
  const TitleButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onTap,
    this.titleSize = TextSizes.sp20,
    this.titleWeight = FontWeight.w500,
    this.decoration = TextDecoration.none,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Color color;
  final double titleSize;
  final FontWeight titleWeight;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: TextView(
        title: title,
        size: titleSize.sp,
        weight: titleWeight,
        color: color,
        align: TextAlign.center,
        decoration: decoration,
      ),
    );
  }
}
