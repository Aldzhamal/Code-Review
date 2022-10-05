import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

class TextSwitch extends StatelessWidget {
  const TextSwitch({
    super.key,
    required this.text,
    required this.onToggle,
    required this.status,
  });

  final String text;
  final Function(bool value) onToggle;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextView(
          size: TextSizes.sp22.sp,
          title: text,
          weight: FontWeight.w700,
        ),
        FlutterSwitch(
          width: Dimensions.switcWidth.w,
          height: Dimensions.switcHeight.h,
          valueFontSize: TextSizes.sp18.sp,
          activeText: 'ON',
          inactiveText: 'OFF',
          inactiveColor: ColorsRes.inactive,
          inactiveTextColor: ColorsRes.black,
          activeColor: ColorsRes.activeColorSwitch,
          activeTextColor: ColorsRes.black,
          toggleColor: ColorsRes.accent,
          value: status,
          borderRadius: 50.0.r,
          padding: 5.0,
          showOnOff: true,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
