import 'package:custom_services/services/purchases/handler.dart';
import 'package:custom_services/services/purchases/product.dart';
import 'package:custom_services/services/purchases/purchase.dart';
import 'package:flutter/widgets.dart';

export 'package:in_app_purchase/in_app_purchase.dart';

enum VerificationStatus { SUCCESS, ERROR, ALREADY_USED }

abstract class PurchaseService {
  final List<PurchaseHandler> _listeners;

  PurchaseService() : _listeners = [];

  List<PurchaseHandler> get listeners => List.unmodifiable(_listeners);

  void addListener(PurchaseHandler listener) {
    _listeners.add(listener);
  }

  void removeListener(PurchaseHandler listener) {
    _listeners.remove(listener);
  }

  bool canBuy(Product product);

  Future<void> restore();

  Future<bool> openCheckout(BuildContext context, Product product);

  /// To be defined in subclass. This method must verify the purchase via
  /// backend and return a bool value that represents if the purchase is valid
  Future<VerificationStatus> verifyPurchase(PurchaseInfo purchase);
}
