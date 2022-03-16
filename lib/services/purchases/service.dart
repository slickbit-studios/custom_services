import 'package:custom_services/services/purchases/exception.dart';
import 'package:custom_services/services/purchases/listener.dart';
import 'package:custom_services/services/purchases/product.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class PurchaseService {
  final List<ProductDetails> _details;
  final List<PurchaseListener> _listeners;

  PurchaseService(this._details) : _listeners = [] {
    purchase.purchaseStream.listen(_onPurchaseUpdated);
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

  void registerListener(PurchaseListener listener) {
    _listeners.add(listener);
  }

  void removeListener(PurchaseListener listener) {
    _listeners.remove(listener);
  }

  Future<bool> openBuyDialog(Product product) {
    ProductDetails details = _findDetails(product);
    final PurchaseParam param = PurchaseParam(productDetails: details);

    if (product.type == ProductType.consumable) {
      return purchase.buyConsumable(purchaseParam: param);
    } else {
      return purchase.buyNonConsumable(purchaseParam: param);
    }
  }

  ProductDetails _findDetails(Product product) {
    try {
      return _details.firstWhere((element) => element.id == product.id);
    } catch (_) {
      throw PurchaseException.notFound(product.id);
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        for (var listener in _listeners) {
          listener.onPurchaseStarted();
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        for (var listener in _listeners) {
          listener.onPurchaseCanceled();
        }
      } else if (purchase.status == PurchaseStatus.error) {
        for (var listener in _listeners) {
          listener.onPurchaseError();
        }
      } else if ([PurchaseStatus.purchased, PurchaseStatus.restored]
          .contains(purchase.status)) {
        if (!await verifyPurchase(purchase)) {
          for (var listener in _listeners) {
            listener.onPurchaseError();
            return;
          }
        }

        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }

        for (var listener in _listeners) {
          listener.onPurchaseSuccess();
        }
      }
    }
  }

  /// To be defined in subclass. This method must verify the purchase via
  /// backend and return a bool value that represents if the purchase is valid
  Future<bool> verifyPurchase(PurchaseDetails purchase);
}
