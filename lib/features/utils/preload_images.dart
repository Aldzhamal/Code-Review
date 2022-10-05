import 'package:cleaner_code_review/features/presentation/resources/icons_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> _preloadPNG(Image image, BuildContext context) => precacheImage(
      image.image,
      context,
    );

Future<void> preloadPNG(BuildContext context) async {
  await Future.wait([
    _preloadPNG(Image.asset(IconsRes.logo), context),
    _preloadPNG(Image.asset(IconsRes.startCache), context),
    _preloadPNG(Image.asset(IconsRes.startTrash), context),
    _preloadPNG(Image.asset(IconsRes.startBattery), context),
  ]);
}

Future<void> _preloadSvg(String path) => precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, path),
      null,
    );

Future<void> preloadSVG() async {
  await Future.wait([
    _preloadSvg(IconsRes.settings),
    _preloadSvg(IconsRes.battery),
    _preloadSvg(IconsRes.cache),
    _preloadSvg(IconsRes.trash),
  ]);
}
