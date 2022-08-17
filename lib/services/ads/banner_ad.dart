import 'package:custom_services/services/ads/ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdView extends StatefulWidget {
  final AdService service;

  const BannerAdView({Key? key, required this.service}) : super(key: key);

  @override
  State<BannerAdView> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAdView> {
  BannerAd? _ad;
  double _width = 0;
  double _height = 10;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var ad = widget.service.getBannerAd();

      if (ad != null) {
        double width;
        double height;

        if (ad.size is FluidAdSize) {
          // load actual ad size
          var sizes = await ad.getPlatformAdSize();
          width = sizes!.width.toDouble();
          height = sizes.height.toDouble();
        } else {
          width = ad.size.width.toDouble();
          height = ad.size.height.toDouble();
        }

        setState(() {
          _ad = ad;
          _width = width;
          _height = height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ad == null) return Container();

    return Container(
      width: _width,
      height: _height,
      child: AdWidget(ad: _ad!),
    );
  }
}
