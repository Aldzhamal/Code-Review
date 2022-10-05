import 'package:cleaner_code_review/core/data_holder/home_data.dart';
import 'package:cleaner_code_review/core/services/banner_ads.dart';
import 'package:cleaner_code_review/core/services/interstitial_ads.dart';
import 'package:cleaner_code_review/core/services/local_notification.dart';
import 'package:cleaner_code_review/core/services/navigation.dart';
import 'package:cleaner_code_review/features/presentation/resources/app_theme.dart';
import 'package:cleaner_code_review/features/presentation/resources/routes/app_routes.dart';
import 'package:cleaner_code_review/features/utils/storage_utils.dart';
import 'package:get_it/get_it.dart';


GetIt getIt = GetIt.instance;

void setupGitIt() {
  getIt
    ..registerLazySingleton<Navigation>(() => Navigation())
    ..registerLazySingleton<AppRoutes>(() => AppRoutes())
    ..registerLazySingleton<AppTheme>(() => AppTheme())
    ..registerLazySingleton<HomeData>(() => HomeData())
    ..registerLazySingleton<LocalNotification>(() => LocalNotification())
    ..registerLazySingleton<InterstitialAds>(() => InterstitialAds())
    ..registerLazySingleton<BannerAds>(() => BannerAds())
    ..registerLazySingleton<Storage>(() => Storage());
}
