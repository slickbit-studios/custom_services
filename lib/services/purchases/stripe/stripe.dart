import 'package:custom_services/services/purchases/product.dart';
import 'package:custom_services/services/purchases/purchase.dart';
import 'package:custom_services/services/purchases/stripe/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stripe_checkout/stripe_checkout.dart';

import '../service.dart';

const _stripeProvider = 'stripe';

abstract class StripePurchaseService extends PurchaseService {
  final String publishableKey;

  StripePurchaseService({required this.publishableKey});

  @override
  Future<bool> openCheckout(BuildContext context, Product product) async {
    var purchase = PurchaseInfo(
      provider: _stripeProvider,
      productId: product.id,
      status: PurchaseStatus.pending,
    );

    onPurchaseUpdated(purchase);

    var session = await createSession(product.id);

    var response = await redirectToCheckout(
      context: context,
      sessionId: session.id,
      publishableKey: publishableKey,
      successUrl: kIsWeb ? Uri.base.toString() : null,
      canceledUrl: kIsWeb ? Uri.base.toString() : null,
    );

    if (response != null) {
      // TODO check
    }

    return false;
  }

  @protected
  void onPurchaseUpdated(PurchaseInfo purchase) async {
    try {
      if (purchase.status == PurchaseStatus.pending) {
        for (var listener in listeners) {
          listener.onPurchaseStarted(purchase);
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        for (var listener in listeners) {
          listener.onPurchaseCanceled(purchase);
        }
      } else if ([PurchaseStatus.purchased, PurchaseStatus.restored]
          .contains(purchase.status)) {
        VerificationStatus verification = await verifyPurchase(purchase);

        if ([VerificationStatus.SUCCESS, VerificationStatus.ALREADY_USED]
            .contains(verification)) {
          switch (verification) {
            case VerificationStatus.SUCCESS:
              for (var listener in listeners) {
                listener.onPurchaseSuccess(purchase);
              }
              return;
            case VerificationStatus.ERROR:
              throw 'Error on Purchase';
            case VerificationStatus.ALREADY_USED:
              for (var listener in listeners) {
                listener.onPurchaseAlreadyUsed(purchase);
              }
              return;
          }
        } else {
          throw 'Error on Purchase';
        }
      }
    } catch (err) {
      for (var listener in listeners) {
        listener.onPurchaseError(purchase);
      }
    }
  }

  Future<Session> createSession(String productId);
}
