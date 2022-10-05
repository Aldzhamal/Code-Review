import 'package:cleaner_code_review/features/utils/AdHelper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class BannerAds {
  BannerAd? _bannerAd;

  Future<void> loadBannerAds() => BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            _bannerAd = ad as BannerAd;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError err) {
            debugPrint('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        ),
      ).load();

  BannerAd? get bannerAd => _bannerAd;
}
