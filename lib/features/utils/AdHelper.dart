import 'dart:io';

import 'package:flutter/foundation.dart';

mixin AdHelper {
  //Todo(Issa): need to change
  static String get bannerAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978110'
          : 'ca-app-pub-3940256099942544/6300978115';
    }
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173710'
          : 'ca-app-pub-3940256099942544/1033173715';
    }
  }
}
