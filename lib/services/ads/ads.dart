import 'package:custom_services/services/crash_report/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  final String? interstitialAdId;
  final String? bannerAdId;

  final int interstitialFrequency;
  final int bannerFrequency;

  int? _lastInterstitial;
  int? _lastBanner;

  bool _bannerLoading = false;
  bool _interstitialLoading = false;

  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  AdService({
    this.interstitialAdId,
    this.bannerAdId,
    this.interstitialFrequency = 30,
    this.bannerFrequency = 30,
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
        ServiceLogger.instance.error(
          module: runtimeType,
          message: 'Error loading consent form: ${error.message}',
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
        ServiceLogger.instance.error(
          module: runtimeType,
          message: 'Failed to load ad consent form: ${formError.message}',
        );
      },
    );
  }

  void loadBannerAd({AdSize size = AdSize.fluid}) {
    assert(bannerAdId != null, 'Requested banner ad but no ad id is set');

    _bannerLoading = true;

    var bannerAd = BannerAd(
      adUnitId: bannerAdId!,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          _bannerLoading = false;
        },
        onAdClosed: (ad) => _bannerAd = null,
        onAdClicked: (ad) => ServiceLogger.instance.warning(
          module: runtimeType,
          message: 'Banner ad tapped',
        ),
        onAdFailedToLoad: (ad, error) {
          _bannerLoading = false;
          ServiceLogger.instance.warning(
            module: runtimeType,
            message: 'Ad failed to load ${error.message}',
          );
        },
      ),
    );

    bannerAd.load();
  }

  BannerAd? getBannerAd() {
    if (bannerAdId == null) return null;

    int now = DateTime.now().millisecondsSinceEpoch;

    // ensure initial frequency delay
    _lastBanner ??= now;

    // load if banner is currently null
    if (_bannerAd == null && !_bannerLoading) {
      loadBannerAd();
      return null;
    }

    // check if next banner can be shown
    if (_lastBanner! + bannerFrequency * 1000 > now) {
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

    _interstitialLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitialAd = ad;

          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => _bannerAd = null,
            onAdClicked: (ad) => ServiceLogger.instance.warning(
              module: runtimeType,
              message: 'Banner ad tapped',
            ),
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          ServiceLogger.instance.warning(
            module: runtimeType,
            message: 'Ad failed to load ${error.message}',
          );
        },
      ),
    );
  }

  InterstitialAd? getInterstitialAd() {
    if (interstitialAdId == null) return null;

    int now = DateTime.now().millisecondsSinceEpoch;

    // ensure initial frequency delay
    _lastInterstitial ??= now;

    // load if interstitial is currently null
    if (_interstitialAd == null && !_interstitialLoading) {
      loadInterstitialAd();
      return null;
    }

    // check if next interstitial can be shown
    if (_lastInterstitial! + interstitialFrequency * 1000 > now) {
      return null;
    }

    var ad = _interstitialAd;
    _interstitialAd = null;

    _lastInterstitial = now;
    return ad;
  }
}

class IosTestAdService extends AdService {
  static const String _banner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _interstitial = 'ca-app-pub-3940256099942544/4411468910';

  IosTestAdService({
    bool banners = true,
    super.bannerFrequency,
    bool interstitials = true,
    super.interstitialFrequency,
  }) : super(
          bannerAdId: banners ? _banner : null,
          interstitialAdId: interstitials ? _interstitial : null,
        );
}

class AndroidTestAdService extends AdService {
  static const String _banner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _interstitial = 'ca-app-pub-3940256099942544/1033173712';

  AndroidTestAdService({
    bool banners = true,
    super.bannerFrequency,
    bool interstitials = true,
    super.interstitialFrequency,
  }) : super(
          bannerAdId: banners ? _banner : null,
          interstitialAdId: interstitials ? _interstitial : null,
        );
}
