import 'dart:io';

import 'package:custom_services/services/purchases/exception.dart';
import 'package:custom_services/services/purchases/product.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

import 'service.dart';

abstract class NativePurchaseService extends PurchaseService {
  final List<ProductDetails> _details;

  NativePurchaseService(this._details) {
    _purchase.purchaseStream.listen(_onPurchasesUpdated);
  }

  static InAppPurchase get _purchase => InAppPurchase.instance;

  static Future<List<ProductDetails>> loadPurchases(Set<String> ids) async {
    final bool available = await _purchase.isAvailable();
    if (!available) {
      throw PurchaseException.notReachable();
    }

    final res = await _purchase.queryProductDetails(ids);
    return res.productDetails;
  }

  @override
  Future<void> restore() async {
    return _purchase.restorePurchases();
  }

  @override
  Future<bool> openBuyDialog(Product product) async {
    ProductDetails details = getDetails(product);
    _purchase.getPlatformAddition();
    final PurchaseParam param = PurchaseParam(productDetails: details);

    if (Platform.isIOS) {
      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();
      for (var transaction in transactions) {
        await paymentWrapper.finishTransaction(transaction);
      }
    }

    if (product.type == ProductType.consumable) {
      return _purchase.buyConsumable(purchaseParam: param);
    } else {
      return _purchase.buyNonConsumable(purchaseParam: param);
    }
  }

  @override
  ProductDetails getDetails(Product product) {
    try {
      return _details.firstWhere((element) => element.id == product.id);
    } catch (_) {
      throw PurchaseException.notFound(product.id);
    }
  }

  void _onPurchasesUpdated(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      _onPurchaseUpdated(purchase);
    }
  }

  void _onPurchaseUpdated(PurchaseDetails purchase) async {
    try {
      if (purchase.status == PurchaseStatus.pending) {
        for (var listener in listeners) {
          listener.onPurchaseStarted(purchase);
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        for (var listener in listeners) {
          listener.onPurchaseCanceled(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        for (var listener in listeners) {
          listener.onPurchaseError(purchase);
        }
      } else if ([PurchaseStatus.purchased, PurchaseStatus.restored]
          .contains(purchase.status)) {
        VerificationStatus verification = await verifyPurchase(purchase);

        if ([VerificationStatus.SUCCESS, VerificationStatus.ALREADY_USED]
            .contains(verification)) {
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          } else {
            // consume on android
            final BillingResultWrapper billingResult =
                await (InAppPurchasePlatformAddition.instance!
                        as InAppPurchaseAndroidPlatformAddition)
                    .consumePurchase(purchase);

            if (billingResult.responseCode != BillingResponse.ok) {
              throw 'Failed to consume purchase';
            }
          }

          switch (verification) {
            case VerificationStatus.SUCCESS:
              for (var listener in listeners) {
                listener.onPurchaseSuccess(purchase);
              }
              return;
            case VerificationStatus.ERROR:
              for (var listener in listeners) {
                listener.onPurchaseError(purchase);
              }
              return;
            case VerificationStatus.ALREADY_USED:
              for (var listener in listeners) {
                listener.onPurchaseAlreadyUsed(purchase);
              }
              return;
          }
        } else {
          for (var listener in listeners) {
            listener.onPurchaseError(purchase);
          }
        }
      }
    } catch (err) {
      for (var listener in listeners) {
        listener.onPurchaseError(purchase);
      }
    }
  }
}
