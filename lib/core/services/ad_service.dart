import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Manages AdMob banner, interstitial, rewarded, and native ads.
///
/// Uses Google-provided test ad unit IDs by default.
/// Replace them with production IDs before release.
class AdService {
  AdService._();

  static final AdService instance = AdService._();

  // ──────────────────────────── Test Ad Unit IDs ────────────────
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testNativeId = 'ca-app-pub-3940256099942544/2247696110';

  // ──────────────────────────── State ───────────────────────────
  bool _initialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialShownThisSession = false;

  /// Whether the ad SDK has been initialized.
  bool get isInitialized => _initialized;

  // ──────────────────────────── Init ────────────────────────────

  /// Initializes the Mobile Ads SDK. Call once at app startup.
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      debugPrint('AdService: MobileAds SDK initialized');
    } catch (e) {
      debugPrint('AdService: init failed — $e');
    }
  }

  // ──────────────────────────── Banner ──────────────────────────

  /// Creates a [BannerAd] ready to be loaded.
  BannerAd createBannerAd({
    AdSize adSize = AdSize.banner,
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: _testBannerId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdService: Banner loaded');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdService: Banner failed to load — $error');
          ad.dispose();
          onAdFailedToLoad?.call(ad, error);
        },
        onAdImpression: (_) =>
            debugPrint('AdService: Banner impression recorded'),
      ),
    );
  }

  // ──────────────────────────── Interstitial ────────────────────

  /// Preloads an interstitial ad.
  Future<void> loadInterstitialAd() async {
    if (!_initialized) return;

    await InterstitialAd.load(
      adUnitId: _testInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: Interstitial loaded');
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('AdService: Interstitial dismissed');
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('AdService: Interstitial failed to show — $error');
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Interstitial failed to load — $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Shows the preloaded interstitial ad.
  ///
  /// Enforces a **once-per-session** guard so the user is not spammed.
  /// Returns `true` if the ad was shown.
  Future<bool> showInterstitialAd() async {
    if (_interstitialShownThisSession) {
      debugPrint('AdService: Interstitial already shown this session');
      return false;
    }
    if (_interstitialAd == null) {
      debugPrint('AdService: No interstitial loaded');
      return false;
    }
    _interstitialShownThisSession = true;
    await _interstitialAd!.show();
    return true;
  }

  // ──────────────────────────── Rewarded ────────────────────────

  /// Preloads a rewarded ad.
  Future<void> loadRewardedAd() async {
    if (!_initialized) return;

    await RewardedAd.load(
      adUnitId: _testRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdService: Rewarded ad loaded');
          _rewardedAd = ad;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('AdService: Rewarded ad dismissed');
              ad.dispose();
              _rewardedAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('AdService: Rewarded ad failed to show — $error');
              ad.dispose();
              _rewardedAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Rewarded ad failed to load — $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Shows the preloaded rewarded ad.
  ///
  /// [onUserEarnedReward] is called when the user earns a reward.
  /// Returns `true` if the ad was shown.
  Future<bool> showRewardedAd({
    required void Function(AdWithoutView ad, RewardItem reward)
        onUserEarnedReward,
  }) async {
    if (_rewardedAd == null) {
      debugPrint('AdService: No rewarded ad loaded');
      return false;
    }
    await _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
    return true;
  }

  // ──────────────────────────── Native ──────────────────────────

  /// Creates a [NativeAd] ready to be loaded.
  NativeAd createNativeAd({
    required String factoryId,
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    return NativeAd(
      adUnitId: _testNativeId,
      factoryId: factoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdService: Native ad loaded');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdService: Native ad failed to load — $error');
          ad.dispose();
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
  }

  // ──────────────────────────── Cleanup ─────────────────────────

  /// Disposes any loaded ads. Call on app shutdown if needed.
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  /// Resets the per-session interstitial guard (e.g. for testing).
  @visibleForTesting
  void resetSessionGuard() {
    _interstitialShownThisSession = false;
  }
}
