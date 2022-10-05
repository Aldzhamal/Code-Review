import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => <Object>[];
}

class SettingsInitial extends SettingsState {}

class AppVersionGotAndSwitchState extends SettingsState {
  const AppVersionGotAndSwitchState({
    required this.version,
    required this.isEnabledNotify,
    required this.isEnabledAdvertisingCache,
    required this.isEnabledApkFiles,
    required this.isEnabledAutoClean,
    required this.isEnabledResidualFiles,
    required this.isVisibleCache,
    required this.cleanAtLeastValue,
    required this.scanEveryValue,
    required this.isEnabledDarkTheme,
  });

  final String version;
  final String scanEveryValue;
  final String cleanAtLeastValue;
  final bool isEnabledNotify;
  final bool isEnabledAutoClean;
  final bool isVisibleCache;
  final bool isEnabledResidualFiles;
  final bool isEnabledApkFiles;
  final bool isEnabledAdvertisingCache;
  final bool isEnabledDarkTheme;

  @override
  List<Object> get props => <Object>[
        version,
        isEnabledNotify,
        isEnabledAutoClean,
        isVisibleCache,
        isEnabledResidualFiles,
        isEnabledApkFiles,
        isEnabledAdvertisingCache,
        scanEveryValue,
        cleanAtLeastValue,
        isEnabledDarkTheme,
      ];
}

class VisibleCacheSwitchedOn extends SettingsState {
  const VisibleCacheSwitchedOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class ResidualFilesSwitchedOn extends SettingsState {
  const ResidualFilesSwitchedOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class AutoCleanSwitchedOn extends SettingsState {
  const AutoCleanSwitchedOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class ApkFilesSwitchedOn extends SettingsState {
  const ApkFilesSwitchedOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class AdvertisingCacheSwitchedOn extends SettingsState {
  const AdvertisingCacheSwitchedOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class NotificationSwitchedON extends SettingsState {
  const NotificationSwitchedON({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class MessageSent extends SettingsState {
  const MessageSent({required this.responseMessage});

  final String responseMessage;

  @override
  List<Object> get props => <Object>[responseMessage];
}

class PrivacyPolicyShown extends SettingsState {
  const PrivacyPolicyShown({required this.updateKey, required this.policy});

  final Key updateKey;
  final String policy;

  @override
  List<Object> get props => <Object>[updateKey, policy];
}

class ScanEveryValueGot extends SettingsState {
  const ScanEveryValueGot({required this.value});

  final String value;

  @override
  List<Object> get props => <Object>[value];
}

class CleanAtLeastGot extends SettingsState {
  const CleanAtLeastGot({required this.value});

  final String value;

  @override
  List<Object> get props => <Object>[value];
}

class DarkThemeSwitched extends SettingsState {
  const DarkThemeSwitched({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}
