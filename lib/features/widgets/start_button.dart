import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartButton extends StatelessWidget {
  const StartButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(500.0.r),
        splashColor: ColorsRes.accent.withOpacity(0.5),
        highlightColor: Colors.grey.withOpacity(0.09),
        child: Image.asset(
          icon,
          width: Dimensions.startButton.w,
          height: Dimensions.startButton.w,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
