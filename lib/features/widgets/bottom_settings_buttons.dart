import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtomSettingsButtons extends StatelessWidget {
  const ButtomSettingsButtons({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorsRes.navBackGround),
          fixedSize: MaterialStateProperty.all(
            Size(
              Dimensions.buttomSettingsButtonsWidth.w,
              Dimensions.buttomSettingsButtonsHeight.h,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0.r),
          )),
          overlayColor: MaterialStateProperty.all(ColorsRes.accent),
        ),
        child: TextView(
          title: title.toUpperCase(),
          size: TextSizes.sp25.sp,
          weight: FontWeight.w700,
          color: ColorsRes.primaryText,
          align: TextAlign.start,
        ),
      ),
    );
  }
}
