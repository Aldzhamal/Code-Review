import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/app_theme.dart';
import 'package:cleaner_code_review/features/presentation/resources/routes/app_routes.dart';
import 'package:cleaner_code_review/features/presentation/resources/routes/route_name.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CleanerCodeReview extends StatelessWidget {
  const CleanerCodeReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => AdaptiveTheme(
        light: getIt<AppTheme>().lightThemeData,
        dark: getIt<AppTheme>().darkThemeData,
        initial: AdaptiveThemeMode.dark,
        builder: (ThemeData theme, ThemeData darkTheme) => MaterialApp(
          title: StringsRes.appName,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme,
          darkTheme: darkTheme,
          navigatorKey: getIt<Navigation>().navigatorKey,
          initialRoute: RouteName.splash,
          routes: getIt<AppRoutes>().routes,
        ),
      ),
    );
  }
}
