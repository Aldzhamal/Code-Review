import 'package:cleaner_code_review/features/utils/AdHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class InterstitialAds {
  InterstitialAd? _interstitialAd;

  Future<void> loadInterstitialAd() => InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {},
            );
          },
          onAdFailedToLoad: (LoadAdError err) {
            debugPrint('Failed to load an interstitial ad: ${err.message}');
          },
        ),
      );

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd?.show();
    }
  }
}
