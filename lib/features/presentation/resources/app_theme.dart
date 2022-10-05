import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppTheme {
  ThemeData get lightThemeData => ThemeData(
        primaryColor: ColorsRes.primary,
        scaffoldBackgroundColor: ColorsRes.backGroundLight,
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(ColorsRes.frame),
          thumbVisibility: MaterialStateProperty.all(true),
          crossAxisMargin: Dimensions.margin3,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorsRes.backGroundLight,
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: Dimensions.appBarHeight.h,
          titleTextStyle: TextStyle(
            color: ColorsRes.primaryBlackText,
            fontFamily: StringsRes.fontFamily,
            fontSize: TextSizes.sp17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: ColorsRes.accent,
        ),
        fontFamily: StringsRes.fontFamily,
      );

  ThemeData get darkThemeData => ThemeData(
    primaryColor: ColorsRes.primary,
    scaffoldBackgroundColor: ColorsRes.backGround,
    scrollbarTheme: const ScrollbarThemeData().copyWith(
      thumbColor: MaterialStateProperty.all(ColorsRes.frame),
      thumbVisibility: MaterialStateProperty.all(true),
      crossAxisMargin: Dimensions.margin3,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsRes.backGround,
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: Dimensions.appBarHeight.h,
      titleTextStyle: TextStyle(
        color: ColorsRes.primaryText,
        fontFamily: StringsRes.fontFamily,
        fontSize: TextSizes.sp17.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsRes.accent,
    ),
    fontFamily: StringsRes.fontFamily,
  );
}
