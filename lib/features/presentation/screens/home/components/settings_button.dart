import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.settings.h,
      width: Dimensions.settings.h,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32.0.r),
        splashColor: Colors.transparent,
        highlightColor: ColorsRes.accent,
        child: Center(
          child: SvgPicture.asset(
            IconsRes.settings,
            width: Dimensions.settingsIcon.h,
            height: Dimensions.settingsIcon.h,
            color: ColorsRes.settingIcon,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
