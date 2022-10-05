import 'dart:ui';

import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/utils/extension.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';


class DialogNoButton extends StatelessWidget {
  const DialogNoButton({
    Key? key,
    required this.contentText,
    required this.contentImage,
    required this.onFinished,
  }) : super(key: key);

  final String contentText;
  final String contentImage;
  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) {
    2000.timerCount(callback: onFinished);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: SizedBox(
          width: Dimensions.dialogWidth.w,
          height: Dimensions.dialogHeight.h,
          child: WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: _content,

              insetPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(32.0.r),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _content => Column(
    children: <Widget>[
      SizedBox(
        height: Dimensions.margin10.h,
      ),
      Lottie.asset(
        contentImage,
        width: Dimensions.dialogImage.h,
        height: Dimensions.dialogImage.h,
        fit: BoxFit.fill,
      ),
      const Spacer(),
      TextView(
        title: contentText,
        size: TextSizes.sp23.sp,
        weight: FontWeight.w500,
        color: ColorsRes.primaryText,
      ),
      SizedBox(
        height: Dimensions.margin36.h,
      ),
    ],
  );
}
