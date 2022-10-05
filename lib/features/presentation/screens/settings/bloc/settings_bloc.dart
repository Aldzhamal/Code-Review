import 'package:bloc/bloc.dart';
import 'package:cleaner_code_review/core/data_holder/menu_button_data.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_event.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/bloc/settings_state.dart';
import 'package:cleaner_code_review/features/presentation/screens/settings/pages/contact_us_screen.dart';
import 'package:cleaner_code_review/features/utils/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<GetAppVersion>(_onGetAppVersion);

    on<SwitchNotificationOn>(
        (SwitchNotificationOn event, Emitter<SettingsState> emit) async {
      emit(NotificationSwitchedON(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsEnabledNotify(event.isEnabled);
    });

    on<SwitchVisibleCacheOn>(
        (SwitchVisibleCacheOn event, Emitter<SettingsState> emit) async {
      emit(VisibleCacheSwitchedOn(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsVisibleCache(event.isEnabled);
    });

    on<SwitchResidualFilesOn>(
        (SwitchResidualFilesOn event, Emitter<SettingsState> emit) async {
      emit(ResidualFilesSwitchedOn(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsEnabledResidualFiles(event.isEnabled);
    });

    on<SwitchAutoCleanOn>(
        (SwitchAutoCleanOn event, Emitter<SettingsState> emit) async {
      emit(AutoCleanSwitchedOn(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsEnabledAutoClean(event.isEnabled);
    });

    on<SwitchApkFilesOn>(
        (SwitchApkFilesOn event, Emitter<SettingsState> emit) async {
      emit(ApkFilesSwitchedOn(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsEnabledApkFiles(event.isEnabled);
    });

    on<SwitchAdvertisingCacheOn>(
        (SwitchAdvertisingCacheOn event, Emitter<SettingsState> emit) async {
      emit(AdvertisingCacheSwitchedOn(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsEnabledAdvertisingCache(event.isEnabled);
    });

    on<NavigateToContactUsScreens>(
      (NavigateToContactUsScreens event, Emitter<SettingsState> emit) {
        _launchContactUsScreen();
      },
    );

    on<SendMessage>((SendMessage event, Emitter<SettingsState> emit) async {
      await send(event, emit);
    });

    on<ShowPrivacyPolicy>(
        (ShowPrivacyPolicy event, Emitter<SettingsState> emit) async {
      final String _pPolicy =
          await rootBundle.loadString('assets/text/privacy_policy.txt');

      emit(PrivacyPolicyShown(policy: _pPolicy, updateKey: UniqueKey()));
    });

    on<SetScanEveryValue>(
        (SetScanEveryValue event, Emitter<SettingsState> emit) async {
      emit(ScanEveryValueGot(value: event.value));
      await getIt<Storage>().setScanEveryValue(event.value);
    });

    on<SetCleanAtLeast>(
        (SetCleanAtLeast event, Emitter<SettingsState> emit) async {
      emit(CleanAtLeastGot(value: event.value));
      await getIt<Storage>().setCleanAtLeastValue(event.value);
    });

    on<SwitchDarkTheme>(
        (SwitchDarkTheme event, Emitter<SettingsState> emit) async {
      emit(DarkThemeSwitched(isEnabled: event.isEnabled));
      await getIt<Storage>().setIsEnabledDarkTheme(event.isEnabled);
    });
  }

  Future<void> _onGetAppVersion(
      GetAppVersion event, Emitter<SettingsState> emit) async {
    await PackageInfo.fromPlatform().then((PackageInfo value) async {
      emit(AppVersionGotAndSwitchState(
        version: value.version,
        isEnabledNotify: await getIt<Storage>().getIsEnabledNotify(),
        isEnabledAdvertisingCache:
            await getIt<Storage>().getIsEnabledAdvertisingCache(),
        isEnabledApkFiles: await getIt<Storage>().getIsEnabledApkFiles(),
        isEnabledAutoClean: await getIt<Storage>().getIsEnabledAutoClean(),
        isEnabledResidualFiles:
            await getIt<Storage>().getIsEnabledResidualFiles(),
        isVisibleCache: await getIt<Storage>().getIsVisibleCache(),
        scanEveryValue:
            await getIt<Storage>().getScanEveryValue() ?? scanList.first,
        cleanAtLeastValue:
            await getIt<Storage>().getCleanAtLeastValue() ?? cleanList.first,
        isEnabledDarkTheme: await getIt<Storage>().getIsEnabledDarkTheme(),
      ));
    });
  }

  Future<void> send(SendMessage event, Emitter<SettingsState> emit) async {
    final Email email = Email(
      body: event.body,
      recipients: <String>[StringsRes.recipientEmail],
    );
    String platformResponse = '';
    try {
      await FlutterEmailSender.send(email).then((dynamic value) {
        platformResponse = value != null
            ? StringsRes.messageHasBeenSent
            : StringsRes.messageNotSent;
      });
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }
    emit(MessageSent(responseMessage: platformResponse));
  }

  void _launchContactUsScreen() {
    getIt<Navigation>().toPageRouteProvider<ContactUsScreen, SettingsBloc>(
      page: const ContactUsScreen(),
      bloc: this,
    );
  }
}
