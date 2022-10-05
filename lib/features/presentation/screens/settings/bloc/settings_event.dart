import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => <Object>[];
}

class GetAppVersion extends SettingsEvent {
  const GetAppVersion();

  @override
  List<Object> get props => <Object>[];
}

class SwitchNotificationOn extends SettingsEvent {
  const SwitchNotificationOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class SwitchVisibleCacheOn extends SettingsEvent {
  const SwitchVisibleCacheOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class SwitchResidualFilesOn extends SettingsEvent {
  const SwitchResidualFilesOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class SwitchAutoCleanOn extends SettingsEvent {
  const SwitchAutoCleanOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class SwitchApkFilesOn extends SettingsEvent {
  const SwitchApkFilesOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class SwitchAdvertisingCacheOn extends SettingsEvent {
  const SwitchAdvertisingCacheOn({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}

class NavigateToContactUsScreens extends SettingsEvent {
  const NavigateToContactUsScreens();

  @override
  List<Object> get props => <Object>[];
}

class SendMessage extends SettingsEvent {
  const SendMessage({required this.body});

  final String body;

  @override
  List<Object> get props => <Object>[body];
}

class ShowPrivacyPolicy extends SettingsEvent {
  const ShowPrivacyPolicy();

  @override
  List<Object> get props => <Object>[];
}

class SetScanEveryValue extends SettingsEvent {
  const SetScanEveryValue({required this.value});

  final String value;

  @override
  List<Object> get props => <Object>[value];
}

class SetCleanAtLeast extends SettingsEvent {
  const SetCleanAtLeast({required this.value});

  final String value;

  @override
  List<Object> get props => <Object>[value];
}

class SwitchDarkTheme extends SettingsEvent {
  const SwitchDarkTheme({required this.isEnabled});

  final bool isEnabled;

  @override
  List<Object> get props => <Object>[isEnabled];
}
