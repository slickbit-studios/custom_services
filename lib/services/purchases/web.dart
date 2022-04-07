import 'package:custom_services/services/purchases/exception.dart';
import 'package:custom_services/services/purchases/product.dart';

import 'service.dart';

class WebPurchaseService extends PurchaseService {
  static Future<List<ProductDetails>> loadPurchases(Set<String> ids) async {
    throw UnimplementedError('Web purchases not implemented yet'); // TODO
  }

  @override
  ProductDetails getDetails(Product product) {
    throw PurchaseException.notFound(product.id);
    // TODO: implement
  }

  @override
  Future<void> restore() async {
    // TODO: implement
  }

  @override
  Future<bool> openBuyDialog(Product product) {
    throw UnimplementedError('Web purchases not implemented yet');
    // TODO: implement
  }

  @override
  Future<VerificationStatus> verifyPurchase(PurchaseDetails purchase) {
    throw UnimplementedError('Web purchases not implemented yet');
    // TODO: implement
  }
}
