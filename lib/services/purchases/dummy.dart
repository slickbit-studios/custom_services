import 'package:custom_services/services/purchases/exception.dart';
import 'package:custom_services/services/purchases/product.dart';

import 'service.dart';

class PurchaseServiceDummy extends PurchaseService {
  static Future<List<ProductDetails>> loadPurchases(Set<String> ids) async {
    return [];
  }

  @override
  ProductDetails getDetails(Product product) {
    throw PurchaseException.notFound(product.id);
  }

  @override
  Future<void> restore() async {}

  @override
  Future<bool> openBuyDialog(Product product) async => false;

  @override
  Future<VerificationStatus> verifyPurchase(PurchaseDetails purchase) async =>
      VerificationStatus.ERROR;
}
