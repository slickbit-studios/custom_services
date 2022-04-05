import 'package:custom_services/services/purchases/exception.dart';
import 'package:custom_services/services/purchases/handler.dart';
import 'package:custom_services/services/purchases/product.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

export 'package:in_app_purchase/in_app_purchase.dart';

enum VerificationStatus { SUCCESS, ERROR, ALREADY_USED }

abstract class PurchaseService {
  final List<ProductDetails> _details;
  final List<PurchaseHandler> _listeners;

  PurchaseService(this._details) : _listeners = [] {
    purchase.purchaseStream.listen(_onPurchasesUpdated);
  }

  static InAppPurchase get purchase => InAppPurchase.instance;

  static Future<List<ProductDetails>> loadPurchases(Set<String> ids) async {
    final bool available = await purchase.isAvailable();
    if (!available) {
      throw PurchaseException.notReachable();
    }

    final res = await purchase.queryProductDetails(ids);
    return res.productDetails;
  }

  void addListener(PurchaseHandler listener) {
    _listeners.add(listener);
  }

  void removeListener(PurchaseHandler listener) {
    _listeners.remove(listener);
  }

  Future<void> restore() async {
    return purchase.restorePurchases();
  }

  Future<bool> openBuyDialog(Product product) {
    ProductDetails details = getDetails(product);
    purchase.getPlatformAddition();
    final PurchaseParam param = PurchaseParam(productDetails: details);

    if (product.type == ProductType.consumable) {
      return purchase.buyConsumable(purchaseParam: param);
    } else {
      return purchase.buyNonConsumable(purchaseParam: param);
    }
  }

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
        for (var listener in _listeners) {
          listener.onPurchaseStarted(purchase);
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        for (var listener in _listeners) {
          listener.onPurchaseCanceled(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        for (var listener in _listeners) {
          listener.onPurchaseError(purchase);
        }
      } else if ([PurchaseStatus.purchased, PurchaseStatus.restored]
          .contains(purchase.status)) {
        VerificationStatus verification = await verifyPurchase(purchase);

        if ([VerificationStatus.SUCCESS, VerificationStatus.ALREADY_USED]
            .contains(verification)) {
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          }

          switch (verification) {
            case VerificationStatus.SUCCESS:
              for (var listener in _listeners) {
                listener.onPurchaseSuccess(purchase);
              }
              return;
            case VerificationStatus.ERROR:
              for (var listener in _listeners) {
                listener.onPurchaseError(purchase);
              }
              return;
            case VerificationStatus.ALREADY_USED:
              for (var listener in _listeners) {
                listener.onPurchaseAlreadyUsed(purchase);
              }
              return;
          }
        } else {
          for (var listener in _listeners) {
            listener.onPurchaseError(purchase);
          }
        }
      }
    } catch (err) {
      for (var listener in _listeners) {
        listener.onPurchaseError(purchase);
      }
    }
  }

  /// To be defined in subclass. This method must verify the purchase via
  /// backend and return a bool value that represents if the purchase is valid
  Future<VerificationStatus> verifyPurchase(PurchaseDetails purchase);
}
