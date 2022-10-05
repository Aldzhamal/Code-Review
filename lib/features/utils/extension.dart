import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:cleaner_code_review/core/data_holder/home_data.dart';
import 'package:cleaner_code_review/core/enums/enums.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:easy_localization/easy_localization.dart';


extension HomePage on HomePageType {
  String get pageTitle {
    switch (this) {
      case HomePageType.cleanTrash:
        return StringsRes.cleanTrash;
      case HomePageType.battery:
        return StringsRes.boostBattery;
      case HomePageType.cleanCache:
        return StringsRes.cleanCache;
    }
  }

  String get pageSubTitle {
    switch (this) {
      case HomePageType.cleanTrash:
        return StringsRes.trashSpace;
      case HomePageType.battery:
        return StringsRes.batteryLevel;
      case HomePageType.cleanCache:
        return StringsRes.cacheSpace;
    }
  }
}

extension TimerCount on int {
  void timerCount({required VoidCallback callback}) {
    Timer(Duration(milliseconds: this), callback);
  }
}

