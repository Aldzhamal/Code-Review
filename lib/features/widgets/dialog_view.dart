import 'dart:ui';

import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:cleaner_code_review/features/widgets/title_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogView extends StatelessWidget {
  const DialogView({
    Key? key,
    required this.contentText,
    required this.title,
  }) : super(key: key);

  final String contentText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        content: SingleChildScrollView(
          child: TextView(
            title: contentText,
            size: TextSizes.sp16.sp,
            weight: FontWeight.w500,
            color: ColorsRes.primaryText,
          ),
        ),
        title: TextView(
          title: title,
          size: TextSizes.sp23.sp,
          weight: FontWeight.w500,
          align: TextAlign.center,
          color: ColorsRes.primaryText,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TitleButton(
            title: 'OK',
            color: ColorsRes.accent,
            onTap: () => getIt<Navigation>().pop(),
          ),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(32.0.r),
        )),
      ),
    );
  }
}
