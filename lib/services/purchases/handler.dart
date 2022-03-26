import 'package:custom_services/services/purchases/purchase.dart';

class PurchaseHandler {
  void onPurchaseStarted(PurchaseInfo purchase) {}
  void onPurchaseCanceled(PurchaseInfo purchase) {}
  void onPurchaseError(PurchaseInfo purchase) {}
  void onPurchaseSuccess(PurchaseInfo purchase) {}
}
