import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cleaner_code_review/core/enums/enums.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_bloc.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/bloc/home_state.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/components/settings_button.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/pages/boost_battery_page.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/pages/clean_cache_page.dart';
import 'package:cleaner_code_review/features/presentation/screens/home/pages/clean_trash_page.dart';
import 'package:cleaner_code_review/features/utils/extension.dart';
import 'package:cleaner_code_review/features/widgets/dialog_no_button.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 1,
    keepPage: false,
  );

  HomePageType _homePage = HomePageType.cleanCache;

  bool _isLoading = true;

  int _cacheValue = 0;
  int _trashValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (final BuildContext context) => HomeBloc()
        ..add(const CheckInternetConnection())
        ..add(const GetMemoryInfo()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: _blocListener,
        builder: (final BuildContext context, final HomeState state) {
          return Scaffold(
            body: !_isLoading
                ? SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: Dimensions.padding25.w,
                        right: Dimensions.padding25.w,
                        bottom: Dimensions.padding25.h,
                        top: Dimensions.padding15.h,
                      ),
                      child: ValueListenableBuilder<AdaptiveThemeMode>(
                          valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
                          builder: (_, AdaptiveThemeMode? mode, Widget? child) {
                          return FutureBuilder<AdaptiveThemeMode?>(
                              future: AdaptiveTheme.getThemeMode(),
                              builder: (BuildContext cont,
                                  AsyncSnapshot<AdaptiveThemeMode?> snapshot) {
                                final AdaptiveThemeMode _theme =
                                    snapshot.data ?? AdaptiveThemeMode.dark;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: SettingsButton(
                                        onTap: () => context
                                            .read<HomeBloc>()
                                            .add(const NavigateToSettings()),
                                      ),
                                    ),
                                    TextView(
                                      title: _homePage.pageTitle,
                                      size: TextSizes.sp27.sp,
                                      weight: FontWeight.w700,
                                      color: _theme == AdaptiveThemeMode.dark
                                          ? ColorsRes.primaryText
                                          : ColorsRes.primaryBlackText,
                                    ),
                                    SizedBox(
                                      height: Dimensions.margin20.h,
                                    ),
                                    TextView(
                                      title: _homePage.pageSubTitle,
                                      size: TextSizes.sp20.sp,
                                      weight: FontWeight.w400,
                                      color: _theme == AdaptiveThemeMode.dark
                                          ? ColorsRes.primaryText
                                          : ColorsRes.primaryBlackText,
                                    ),
                                    Expanded(
                                      child: PageView(
                                        controller: _pageController,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          BoostBatteryPage(
                                            themeMode: _theme,
                                          ),
                                          CleanCachePage(
                                            cacheValue: _cacheValue,
                                            themeMode: _theme,
                                          ),
                                          CleanTrashPage(
                                            trashValue: _trashValue,
                                            themeMode: _theme,
                                          ),
                                        ],
                                      ),
                                    ),

                                      if (_bannerAd != null)
                              Container(
                                    width: _bannerAd!.size.width.toDouble(),
                                    height: _bannerAd!.size.height.toDouble(),
                                    margin: EdgeInsets.symmetric(
                                        vertical: Dimensions.margin8.h),
                                    child: AdWidget(ad: _bannerAd!),
                              ),
                                  ],
                                );
                              });
                        }
                      ),
                    ),
                  )
                : Center(
                    child: Lottie.asset(
                      IconsRes.loading,
                      width: Dimensions.loading.h,
                      height: Dimensions.loading.h,
                    ),
                  ),
          );
        },
      ),
    );
  }

  void _blocListener(final BuildContext context, final HomeState state) {
    if (state is PageChanged) {
      _homePage = state.pageType;
      _pageController.jumpToPage(state.pageNum);
    } else if (state is ConnectionChecked) {
      showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cont) {
          return _dialog(onFinished: () {
            getIt<Navigation>().pop();
            context.read<HomeBloc>().add(const CheckInternetConnection());
          });
        },
      );
    } else if (state is MemoryInfoGot) {
      _cacheValue = state.cacheValue;
      _trashValue = state.trashValue;
      _isLoading = false;
      _bannerAd = getIt<BannerAds>().bannerAd;
    }
  }

  Widget _dialog({required VoidCallback onFinished}) => DialogNoButton(
        contentText: StringsRes.connectionError,
        contentImage: IconsRes.noConnection,
        onFinished: onFinished,
      );

  @override
  void dispose() {
     _bannerAd?.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
