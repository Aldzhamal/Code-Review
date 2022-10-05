import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cleaner_code_review/core/data_holder/home_data.dart';
import 'package:cleaner_code_review/core/enums/enums.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_bloc.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_state.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/components/nav_button.dart';
import 'package:cleaner_code_review/features/utils/extension.dart';
import 'package:cleaner_code_review/features/widgets/start_button.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CleanCachePage extends StatefulWidget {
  const CleanCachePage({
    Key? key,
    required this.cacheValue,
    required this.themeMode,
  }) : super(key: key);

  final int cacheValue;
  final AdaptiveThemeMode themeMode;

  @override
  CleanCachePageState createState() => CleanCachePageState();
}

class CleanCachePageState extends State<CleanCachePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Timer? _timer;
  int _cleanValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        listener: _blocListener,
        builder: (BuildContext context, HomeState state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Spacer(),
              if (getIt<HomeData>().isCacheCleanStarted)
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      IconsRes.cacheCleaning,
                      width: Dimensions.cacheContainer.h,
                      height: Dimensions.cacheContainer.h,
                      controller: _controller,
                    ),
                    TextView(
                      title: '${_cleanValue.abs()} kb',
                      weight: FontWeight.w700,
                      size: TextSizes.sp27.sp,
                      align: TextAlign.center,
                      color: widget.themeMode == AdaptiveThemeMode.dark
                          ? ColorsRes.primaryText
                          : ColorsRes.primaryBlackText,
                    ),
                  ],
                )
              else
                StartButton(
                  onTap: () =>
                      context.read<HomeBloc>().add(const StartCleanCache()),
                  icon: IconsRes.startCache,
                ),
              SizedBox(
                height: Dimensions.margin20.h,
              ),
              TextView(
                title: getIt<HomeData>().isCacheCleaned
                    ? StringsRes.isFine
                    : getIt<HomeData>().isCacheCleanStarted
                        ? ''
                        : cacheText(_cleanValue),
                weight: FontWeight.w400,
                size: TextSizes.sp20.sp,
                align: TextAlign.center,
                color: getIt<HomeData>().isCacheCleaned
                    ? ColorsRes.lightBlueText
                    : widget.themeMode == AdaptiveThemeMode.dark
                        ? ColorsRes.primaryText
                        : ColorsRes.primaryBlackText,
              ),
              const Spacer(),
              NavButton(
                title: StringsRes.boostBatteryNav,
                icon: IconsRes.battery,
                onTap: () => context.read<HomeBloc>().add(
                      const ChangePage(
                        pageNum: 0,
                        pageType: HomePageType.battery,
                      ),
                    ),
              ),
              SizedBox(
                height: Dimensions.margin20.h,
              ),
              NavButton(
                title: StringsRes.cleanTrashNav,
                icon: IconsRes.trash,
                onTap: () => context.read<HomeBloc>().add(
                      const ChangePage(
                        pageNum: 2,
                        pageType: HomePageType.cleanTrash,
                      ),
                    ),
              ),
            ],
          );
        });
  }

  void _blocListener(final BuildContext context, final HomeState state) {
    if (state is CleanCacheStarted) {
      getIt<HomeData>().isCacheCleanStarted = true;
      _controller
        ..forward()
        ..repeat();
      _startTimer(context: context);
    } else if (state is CleanCacheFinished) {
      _controller.reset();
      _cleanValue = 0;
      _timer?.cancel();
      getIt<HomeData>().isCacheCleaned = true;
         if (_isInterstitialAdReady) {
              _interstitialAd?.show();
            }
    } else if (state is CacheCountCleaning) {
      _cleanValue = state.cache;
    }
  }

  void _startTimer({required BuildContext context}) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (Timer timer) {
        if (_cleanValue <= 0) {
          context.read<HomeBloc>().add(const FinishCleanCache());
        } else {
          context.read<HomeBloc>().add(CleaningCacheCount(cache: _cleanValue));
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
