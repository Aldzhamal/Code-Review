import 'package:cleaner_code_review/core/data_holder/languages.dart';
import 'package:cleaner_code_review/core/services/getIt.dart';
import 'package:cleaner_code_review/core/services/interstitial_ads.dart';
import 'package:cleaner_code_review/core/services/local_notification.dart';
import 'package:cleaner_code_review/features/application/application.dart';
import 'package:cleaner_code_review/features/presentation/resources/colors_res.dart';
import 'package:cleaner_code_review/features/presentation/resources/strings_res.dart';
import 'package:cleaner_code_review/features/utils/preload_images.dart';
import 'package:cleaner_code_review/features/utils/storage_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: ColorsRes.accent));
    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableBuildModes = [];
    MobileAds.instance.initialize();

    setupGitIt();
    getIt<Storage>().init();
    await getIt<LocalNotification>().initialize();

    await preloadSVG();
    await getIt<InterstitialAds>().loadInterstitialAd();

    runApp(EasyLocalization(
      supportedLocales: langs,
      path: StringsRes.pathLanguages,
      assetLoader: const RootBundleAssetLoader(),
      useOnlyLangCode: true,
      fallbackLocale: const Locale('en'),
      child: const CleanerCodeReview(),
    ));
  });
}
