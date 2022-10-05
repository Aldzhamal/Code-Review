import 'package:cleaner_code_review/features/presentation/resources/routes/route_name.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/home_screen.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/pages/contact_us_screen.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/settings_screen.dart';
import 'package:cleaner_code_review/features/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  final Map<String, Widget Function(BuildContext context)> routes =
      <String, Widget Function(BuildContext context)>{
    RouteName.splash: (BuildContext context) => const SplashScreen(),
    RouteName.home: (BuildContext context) => const HomeScreen(),
    RouteName.settings: (BuildContext context) => const SettingsScreen(),
    RouteName.contactUsScreen: (BuildContext context) => const ContactUsScreen(),
  };
}
