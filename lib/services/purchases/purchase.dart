import 'package:in_app_purchase/in_app_purchase.dart' as iap;

class PurchaseInfo {
  String productId;
  String? purchaseId;
  String token;

  PurchaseInfo.of(iap.PurchaseDetails details)
      : productId = details.productID,
        purchaseId = details.purchaseID,
        token = details.verificationData.serverVerificationData;
}
