import 'package:custom_services/util/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  final String? interstitialAdId;
  final String? bannerAdId;

  final int interstitialFrequency;
  final int bannerFrequency;

  int? _lastInterstitial;
  int? _lastBanner;

  InterstitialAd? _interstitialAd;
  Ad? _bannerAd;

  AdService({
    this.interstitialAdId,
    this.bannerAdId,
    this.interstitialFrequency = 3000,
    this.bannerFrequency = 3000,
  }) {
    MobileAds.instance.initialize();
  }

  void requestConsent() {
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadConsentForm();
        }
      },
      (FormError error) {
        Logger.instance.error(
          module: runtimeType,
          message: 'Error loading consent form${error.message}',
        );
      },
    );
  }

  void _loadConsentForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? formError) => _loadConsentForm());
        }
      },
      (FormError formError) {
        Logger.instance.error(
          module: runtimeType,
          message: 'Failed to load ad consent form: ${formError.message}',
        );
      },
    );
  }

  void loadBannerAd({AdSize size = AdSize.banner}) {
    assert(bannerAdId != null, 'Requested banner ad but no ad id is set');

    var logger = Logger.instance;

    var bannerAd = BannerAd(
      adUnitId: bannerAdId!,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => _bannerAd = ad,
        onAdClosed: (ad) => _bannerAd = null,
        onAdClicked: (ad) => logger.warning(
          module: runtimeType,
          message: 'Banner ad tapped',
        ),
        onAdFailedToLoad: (ad, error) => logger.warning(
          module: runtimeType,
          message: 'Ad failed to load ${error.message}',
        ),
      ),
    );

    bannerAd.load();
  }

  Ad? getBannerAd() {
    int now = DateTime.now().millisecondsSinceEpoch;

    if (_bannerAd == null) {
      loadBannerAd();
      return null;
    }

    if (_lastBanner != null && _lastBanner! + bannerFrequency > now) {
      return null;
    }

    var ad = _bannerAd;
    _bannerAd = null;

    _lastBanner = now;
    return ad;
  }

  void loadInterstitialAd() {
    assert(
      interstitialAdId != null,
      'Requested interstitial but missing ad id',
    );

    var logger = Logger.instance;

    InterstitialAd.load(
      adUnitId: interstitialAdId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => _bannerAd = null,
            onAdClicked: (ad) => logger.warning(
              module: runtimeType,
              message: 'Banner ad tapped',
            ),
          );
        },
        onAdFailedToLoad: (error) => logger.warning(
          module: runtimeType,
          message: 'Ad failed to load ${error.message}',
        ),
      ),
    );
  }

  InterstitialAd? getInterstitialAd() {
    int now = DateTime.now().millisecondsSinceEpoch;

    if (_interstitialAd == null) {
      loadInterstitialAd();
      return null;
    }

    if (_interstitialAd != null &&
        _lastInterstitial! + interstitialFrequency > now) {
      return null;
    }

    var ad = _interstitialAd;
    _interstitialAd = null;

    _lastInterstitial = now;
    return ad;
  }
}

class IosTestAdService extends AdService {
  IosTestAdService({
    int interstitialFrequency = 3000,
    int bannerFrequency = 3000,
  }) : super(
          bannerAdId: 'ca-app-pub-3940256099942544/2934735716',
          bannerFrequency: bannerFrequency,
          interstitialAdId: 'ca-app-pub-3940256099942544/4411468910',
          interstitialFrequency: interstitialFrequency,
        );
}

class AndroidTestAdService extends AdService {
  AndroidTestAdService({
    int interstitialFrequency = 3000,
    int bannerFrequency = 3000,
  }) : super(
          bannerAdId: 'ca-app-pub-3940256099942544/6300978111',
          bannerFrequency: bannerFrequency,
          interstitialAdId: 'ca-app-pub-3940256099942544/1033173712',
          interstitialFrequency: interstitialFrequency,
        );
}
