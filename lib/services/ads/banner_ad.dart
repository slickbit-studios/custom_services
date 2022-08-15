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
  AdWithView? _ad;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var ad = widget.service.getBannerAd();
      if (ad != null) {
        setState(() => _ad = ad);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ad == null) return Container();

    return AdWidget(ad: _ad!);
  }
}
