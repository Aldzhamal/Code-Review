import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cleaner_code_review/core/data_holder/menu_button_data.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/dimensions.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/text_sizes.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_bloc.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_state.dart';
import 'package:cleaner_code_review/features/widgets/bottom_settings_buttons.dart';
import 'package:cleaner_code_review/features/widgets/dialog_view.dart';
import 'package:cleaner_code_review/features/widgets/text_dropdown_button.dart';
import 'package:cleaner_code_review/features/widgets/text_switch.dart';
import 'package:cleaner_code_review/features/widgets/text_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEnabledNotification = true;
  bool _isEnabledAutoClean = true;
  bool _isVisibleCache = true;
  bool _isEnabledResidualFiles = true;
  bool _isEnabledApkFiles = true;
  bool _isEnabledAdvertisingCache = true;
  bool _isEnabledDrakTheme = true;

  String _appVersion = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (final BuildContext context) =>
          SettingsBloc()..add(const GetAppVersion()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: _blocListener,
        builder: (final BuildContext context, final SettingsState state) {
          return FutureBuilder<AdaptiveThemeMode?>(
              future: AdaptiveTheme.getThemeMode(),
              builder: (BuildContext cont,
                  AsyncSnapshot<AdaptiveThemeMode?> snapshot) {
                final AdaptiveThemeMode _theme =
                    snapshot.data ?? AdaptiveThemeMode.dark;
                return Scaffold(
                  appBar: AppBar(
                    title: TextView(
                      title: StringsRes.settings,
                      size: TextSizes.sp23.sp,
                      weight: FontWeight.w700,
                      color: _theme == AdaptiveThemeMode.dark
                          ? ColorsRes.primaryText
                          : ColorsRes.primaryBlackText,
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: _theme == AdaptiveThemeMode.dark
                            ? ColorsRes.primaryText
                            : ColorsRes.primaryBlackText,
                      ),
                      onPressed: () => getIt<Navigation>().pop(),
                    ),
                  ),
                  body: SafeArea(
                    child: Scrollbar(
                      thickness: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: Dimensions.margin20.h,
                              left: Dimensions.margin20.h,
                              top: Dimensions.margin29.w),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: Dimensions.topSettingsContainerWidth.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorsRes.navBackGround,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.padding22.h,
                                        vertical: Dimensions.padding14.w,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          TextSwitch(
                                            text: StringsRes.darkTheme,
                                            onToggle: (bool value) => context
                                                .read<SettingsBloc>()
                                                .add(SwitchDarkTheme(
                                                    isEnabled: value)),
                                            status: _isEnabledDrakTheme,
                                          ),
                                          SizedBox(height: Dimensions.margin20.h),
                                          TextSwitch(
                                            text: StringsRes.automationClean
                                                .toUpperCase(),
                                            onToggle: (bool value) => context
                                                .read<SettingsBloc>()
                                                .add(SwitchAutoCleanOn(
                                                    isEnabled: value)),
                                            status: _isEnabledAutoClean,
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextDropdownButton(
                                      text: StringsRes.scanEvery,
                                      list: scanList,
                                      dropdownValue: _scanEvery,
                                      onValueChanged: (String? value) {
                                        context.read<SettingsBloc>().add(
                                            SetScanEveryValue(
                                                value: value ?? _scanEvery));
                                      },
                                    ),
                                    TextDropdownButton(
                                      list: cleanList,
                                      text: StringsRes.cleanAtLeast,
                                      dropdownValue: _cleanAtLeast,
                                      onValueChanged: (String? value) {
                                        context
                                            .read<SettingsBloc>()
                                            .add(SetCleanAtLeast(
                                              value: value ?? _cleanAtLeast,
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.margin29.h),
                              Container(
                                width: Dimensions.containerSettingsWidth.w,
                                height: Dimensions.containerSettingsHeight.h,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimensions.radius),
                                  color: ColorsRes.navBackGround,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.padding22.h,
                                    vertical: Dimensions.padding22.w,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextSwitch(
                                        text: StringsRes.notifications
                                            .toUpperCase(),
                                        onToggle: (bool value) => context
                                            .read<SettingsBloc>()
                                            .add(SwitchNotificationOn(
                                                isEnabled: value)),
                                        status: _isEnabledNotification,
                                      ),
                                      TextSwitch(
                                        text:
                                            StringsRes.visibleCache.toUpperCase(),
                                        onToggle: (bool value) => context
                                            .read<SettingsBloc>()
                                            .add(SwitchVisibleCacheOn(
                                                isEnabled: value)),
                                        status: _isVisibleCache,
                                      ),
                                      TextSwitch(
                                        text: StringsRes.residualFiles
                                            .toUpperCase(),
                                        onToggle: (bool value) => context
                                            .read<SettingsBloc>()
                                            .add(SwitchResidualFilesOn(
                                                isEnabled: value)),
                                        status: _isEnabledResidualFiles,
                                      ),
                                      TextSwitch(
                                        text: StringsRes.apkFiles.toUpperCase(),
                                        onToggle: (bool value) => context
                                            .read<SettingsBloc>()
                                            .add(SwitchApkFilesOn(
                                                isEnabled: value)),
                                        status: _isEnabledApkFiles,
                                      ),
                                      TextSwitch(
                                        text: StringsRes.advertisingCache
                                            .toUpperCase(),
                                        onToggle: (bool value) => context
                                            .read<SettingsBloc>()
                                            .add(SwitchAdvertisingCacheOn(
                                                isEnabled: value)),
                                        status: _isEnabledAdvertisingCache,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimensions.margin29.h),
                              ButtomSettingsButtons(
                                onTap: () => context
                                    .read<SettingsBloc>()
                                    .add(const NavigateToContactUsScreens()),
                                title: StringsRes.writeToDevelopers.toUpperCase(),
                              ),
                              SizedBox(height: Dimensions.margin16.h),
                              ButtomSettingsButtons(
                                onTap: () => Share.share(StringsRes.playStoreUrl),
                                title: StringsRes.shareApplication.toUpperCase(),
                              ),
                              SizedBox(height: Dimensions.padding32.h),
                              TextView(
                                title: '${StringsRes.version.tr()} $_appVersion',
                                size: TextSizes.sp20.sp,
                                weight: FontWeight.w500,
                                color: ColorsRes.subText,
                              ),
                              SizedBox(height: Dimensions.margin14.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void _blocListener(final BuildContext context, final SettingsState state) {
    if (state is AppVersionGotAndSwitchState) {
      _appVersion = state.version;
      _isEnabledNotification = state.isEnabledNotify;
      _isEnabledAutoClean = state.isEnabledAutoClean;
      _isVisibleCache = state.isVisibleCache;
      _isEnabledResidualFiles = state.isEnabledResidualFiles;
      _isEnabledApkFiles = state.isEnabledApkFiles;
      _isEnabledAdvertisingCache = state.isEnabledAdvertisingCache;
      _scanEvery = state.scanEveryValue;
      _cleanAtLeast = state.cleanAtLeastValue;
      _isEnabledDrakTheme = state.isEnabledDarkTheme;
    } else if (state is NotificationSwitchedON) {
      _isEnabledNotification = state.isEnabled;
    } else if (state is PrivacyPolicyShown) {
      showDialog<dynamic>(
        context: context,
        builder: (BuildContext cont) {
          return DialogView(
            title: '',
            contentText: state.policy,
          );
        },
      );
    } else if (state is VisibleCacheSwitchedOn) {
      _isVisibleCache = state.isEnabled;
    } else if (state is ResidualFilesSwitchedOn) {
      _isEnabledResidualFiles = state.isEnabled;
    } else if (state is AutoCleanSwitchedOn) {
      _isEnabledAutoClean = state.isEnabled;
    } else if (state is ApkFilesSwitchedOn) {
      _isEnabledApkFiles = state.isEnabled;
    } else if (state is AdvertisingCacheSwitchedOn) {
      _isEnabledAdvertisingCache = state.isEnabled;
    } else if (state is ScanEveryValueGot) {
      _scanEvery = state.value;
    } else if (state is CleanAtLeastGot) {
      _cleanAtLeast = state.value;
    } else if (state is DarkThemeSwitched) {
      _isEnabledDrakTheme = state.isEnabled;
      if (_isEnabledDrakTheme) {
        AdaptiveTheme.of(context).setDark();
      } else {
        AdaptiveTheme.of(context).setLight();
      }
    }
  }
}
