import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/screens/splash/bloc/splash_bloc.dart';
import 'package:cleaner_code_review/features/presentation/screens/splash/bloc/splash_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/splash/bloc/splash_state.dart';
import 'package:cleaner_code_review/features/utils/preload_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    preloadPNG(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (final BuildContext context) =>
          SplashBloc()..add(const NavigateToHome()),
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (BuildContext context, SplashState state) {},
        builder: (BuildContext context, SplashState state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    IconsRes.logo,
                    width: Dimensions.splashLogoWidth.w,
                    height: Dimensions.splashLogoHeight.h,
                  ),
                  SizedBox(
                    height: Dimensions.margin112.h,
                  ),
                  Lottie.asset(
                    IconsRes.loading,
                    width: Dimensions.loading.h,
                    height: Dimensions.loading.h,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
