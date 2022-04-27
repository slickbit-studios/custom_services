import 'package:custom_services/services/purchases/product.dart';
import 'package:custom_services/services/purchases/purchase.dart';
import 'package:flutter/widgets.dart';

import 'service.dart';

class PurchaseServiceDummy extends PurchaseService {
  static Future<List<ProductDetails>> loadPurchases(Set<String> ids) async {
    return [];
  }

  @override
  Future<void> restore() async {}

  @override
  Future<bool> openCheckout(BuildContext context, Product product) async =>
      false;

  @override
  Future<VerificationStatus> verifyPurchase(PurchaseInfo purchase) async =>
      VerificationStatus.ERROR;

  @override
  bool canBuy(Product product) => false;
}
