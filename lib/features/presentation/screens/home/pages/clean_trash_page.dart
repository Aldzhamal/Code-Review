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

class CleanTrashPage extends StatefulWidget {
  const CleanTrashPage({
    Key? key,
    required this.trashValue,
    required this.themeMode,
  }) : super(key: key);

  final int trashValue;
  final AdaptiveThemeMode themeMode;

  @override
  CleanTrashPageState createState() => CleanTrashPageState();
}

class CleanTrashPageState extends State<CleanTrashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Timer? _timer;
  int _trashValue = 0;

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
            if (getIt<HomeData>().isTrashCleanStarted)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset(
                    IconsRes.trashCleaning,
                    width: Dimensions.cacheContainer.h,
                    height: Dimensions.cacheContainer.h,
                    controller: _controller,
                  ),
                  TextView(
                    title: '${_trashValue.abs()} kb',
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
                  context.read<HomeBloc>().add(const StartCleanTrash()),
              icon: IconsRes.startTrash,
            ),
            SizedBox(
              height: Dimensions.margin20.h,
            ),
            TextView(
              title: getIt<HomeData>().isTrashCleaned
                  ? StringsRes.isGood
                  : getIt<HomeData>().isTrashCleanStarted
                  ? ''
                  : trashText(_trashValue),
              weight: FontWeight.w400,
              size: TextSizes.sp20.sp,
              align: TextAlign.center,
              color: getIt<HomeData>().isTrashCleaned
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
              title: StringsRes.cleanCacheNav,
              icon: IconsRes.cache,
              onTap: () => context.read<HomeBloc>().add(
                    const ChangePage(
                      pageNum: 1,
                      pageType: HomePageType.cleanCache,
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }

  void _blocListener(final BuildContext context, final HomeState state) {
    if (state is CleanTrashStarted) {
      getIt<HomeData>().isTrashCleanStarted = true;
      _controller
        ..forward()
        ..repeat();
      _startTimer(context: context);
    } else if (state is CleanTrashFinished) {
      _controller.reset();
      _trashValue = 0;
      _timer?.cancel();
      getIt<HomeData>().isTrashCleaned = true;
         if (_isInterstitialAdReady) {
              _interstitialAd?.show();
            }
    } else if (state is TrashCountCleaning) {
      _trashValue = state.trash;
    }
  }

  void _startTimer({required BuildContext context}) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (Timer timer) {
        if (_trashValue <= 0) {
          context.read<HomeBloc>().add(const FinishCleanTrash());
        } else {
          context.read<HomeBloc>().add(CleaningTrashCount(trash: _trashValue));
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
