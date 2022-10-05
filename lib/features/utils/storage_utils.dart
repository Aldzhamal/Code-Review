import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  late final FlutterSecureStorage _storage;

  void init() {
    _storage = const FlutterSecureStorage();
  }

  Future<bool> getIsEnabledNotify() async {
    final String? isEnabled = await _storage.read(key: _isEnabledNotify);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsEnabledNotify(bool value) async {
    await _storage.write(
        key: _isEnabledNotify, value: value ? 'Enable' : 'Disable');
  }

  Future<bool> getIsEnabledAutoClean() async {
    final String? isEnabled = await _storage.read(key: _isEnabledAutoClean);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsEnabledAutoClean(bool value) async {
    await _storage.write(
        key: _isEnabledAutoClean, value: value ? 'Enable' : 'Disable');
  }

  Future<bool> getIsVisibleCache() async {
    final String? isEnabled = await _storage.read(key: _isVisibleCache);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsVisibleCache(bool value) async {
    await _storage.write(
        key: _isVisibleCache, value: value ? 'Enable' : 'Disable');
  }

  Future<bool> getIsEnabledResidualFiles() async {
    final String? isEnabled = await _storage.read(key: _isEnabledResidualFiles);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsEnabledResidualFiles(bool value) async {
    await _storage.write(
        key: _isEnabledResidualFiles, value: value ? 'Enable' : 'Disable');
  }

  Future<bool> getIsEnabledApkFiles() async {
    final String? isEnabled = await _storage.read(key: _isEnabledApkFiles);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsEnabledApkFiles(bool value) async {
    await _storage.write(
        key: _isEnabledApkFiles, value: value ? 'Enable' : 'Disable');
  }

  Future<bool> getIsEnabledAdvertisingCache() async {
    final String? isEnabled =
        await _storage.read(key: _isEnabledAdvertisingCache);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsEnabledAdvertisingCache(bool value) async {
    await _storage.write(
        key: _isEnabledAdvertisingCache, value: value ? 'Enable' : 'Disable');
  }

  Future<bool> getIsUserRatted() async {
    final String? isRatted = await _storage.read(key: _isUserRatted);
    return isRatted != null || (isRatted != null && isRatted == 'isRatted');
  }

  Future<void> setIsUserRatted(bool value) async {
    await _storage.write(
        key: _isUserRatted, value: value ? 'isRatted' : 'isNOTRatted');
  }

  Future<bool> getIsUserShared() async {
    final String? isRatted = await _storage.read(key: _isUserShared);
    return isRatted != null || (isRatted != null && isRatted == 'isRatted');
  }

  Future<void> setIsUserShared(bool value) async {
    await _storage.write(
        key: _isUserShared, value: value ? 'isRatted' : 'isNOTRatted');
  }

  Future<String?> getScanEveryValue() => _storage.read(key: _scanEvery);

  Future<void> setScanEveryValue(String value) =>
      _storage.write(key: _scanEvery, value: value);

  Future<String?> getCleanAtLeastValue() => _storage.read(key: _cleanAtLeast);

  Future<void> setCleanAtLeastValue(String value) =>
      _storage.write(key: _cleanAtLeast, value: value);

  Future<bool> getIsEnabledDarkTheme() async {
    final String? isEnabled = await _storage.read(key: _darkTheme);
    return isEnabled == null || (isEnabled != null && isEnabled == 'Enable');
  }

  Future<void> setIsEnabledDarkTheme(bool value) async {
    await _storage.write(key: _darkTheme, value: value ? 'Enable' : 'Disable');
  }
}

String get _isEnabledNotify => 'IsEnabledNotify';

String get _isUserRatted => 'IsUserRatted';

String get _isUserShared => 'IsUserShared';

String get _isEnabledAutoClean => 'IsEnabledAutoClean';

String get _isVisibleCache => 'IsVisibleCache';

String get _isEnabledResidualFiles => 'IsEnabledResidualFiles';

String get _isEnabledApkFiles => 'IsEnabledApkFiles';

String get _isEnabledAdvertisingCache => 'IsEnabledAdvertisingCache';

String get _scanEvery => 'ScanEvery';

String get _cleanAtLeast => 'CleanAtLeast';

String get _darkTheme => 'DarkTheme';
