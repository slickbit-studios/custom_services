import 'package:custom_services/util/logger.dart';
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
  AdWithView? _bannerAd;

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

    _bannerLoading = true;

    var bannerAd = BannerAd(
      adUnitId: bannerAdId!,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as AdWithView;
          _bannerLoading = false;
        },
        onAdClosed: (ad) => _bannerAd = null,
        onAdClicked: (ad) => logger.warning(
          module: runtimeType,
          message: 'Banner ad tapped',
        ),
        onAdFailedToLoad: (ad, error) {
          _bannerLoading = false;
          logger.warning(
            module: runtimeType,
            message: 'Ad failed to load ${error.message}',
          );
        },
      ),
    );

    bannerAd.load();
  }

  AdWithView? getBannerAd() {
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

    var logger = Logger.instance;
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
            onAdClicked: (ad) => logger.warning(
              module: runtimeType,
              message: 'Banner ad tapped',
            ),
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          logger.warning(
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
    int bannerFrequency = 3000,
    bool interstitials = true,
    int interstitialFrequency = 3000,
  }) : super(
          bannerAdId: banners ? _banner : null,
          bannerFrequency: bannerFrequency,
          interstitialAdId: interstitials ? _interstitial : null,
          interstitialFrequency: interstitialFrequency,
        );
}

class AndroidTestAdService extends AdService {
  static const String _banner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _interstitial = 'ca-app-pub-3940256099942544/1033173712';

  AndroidTestAdService({
    bool banners = true,
    int bannerFrequency = 3000,
    bool interstitials = true,
    int interstitialFrequency = 3000,
  }) : super(
          bannerAdId: banners ? _banner : null,
          bannerFrequency: bannerFrequency,
          interstitialAdId: interstitials ? _interstitial : null,
          interstitialFrequency: interstitialFrequency,
        );
}
