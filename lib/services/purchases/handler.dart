import 'package:custom_services/services/purchases/service.dart';

class PurchaseHandler {
  void onPurchaseStarted(PurchaseDetails purchase) {}
  void onPurchaseCanceled(PurchaseDetails purchase) {}
  void onPurchaseSuccess(PurchaseDetails purchase) {}
  void onPurchaseError(PurchaseDetails purchase) {}
  void onPurchaseAlreadyUsed(PurchaseDetails purchase) {}
}
