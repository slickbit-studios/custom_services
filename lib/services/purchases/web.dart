import 'package:custom_services/services/purchases/product.dart';

import 'service.dart';

class WebPurchaseService extends PurchaseService {
  static Future<List<ProductDetails>> loadPurchases(Set<String> ids) async {
    throw UnimplementedError('Web purchases not implemented yet'); // TODO
  }

  @override
  ProductDetails getDetails(Product product) {
    throw UnimplementedError('Web purchases not implemented yet'); // TODO
  }

  @override
  Future<void> restore() async {
    throw UnimplementedError('Web purchases not implemented yet'); // TODO
  }

  @override
  Future<bool> openBuyDialog(Product product) {
    throw UnimplementedError('Web purchases not implemented yet'); // TODO
  }

  @override
  Future<VerificationStatus> verifyPurchase(PurchaseDetails purchase) {
    throw UnimplementedError('Web purchases not implemented yet'); // TODO
  }
}
