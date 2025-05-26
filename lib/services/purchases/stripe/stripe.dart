import 'package:custom_services/services/purchases/product.dart';
import 'package:custom_services/services/purchases/purchase.dart';
import 'package:custom_services/services/purchases/stripe/session.dart';
import 'package:flutter/widgets.dart';

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

    // ignore: unused_local_variable
    var session = await createSession(product.id);

    if (context.mounted) {
      // TODO: DEPRECATED

      // await redirectToCheckout(
      //   context: context,
      //   sessionId: session.id,
      //   publishableKey: publishableKey,
      //   successUrl: session.successUrl,
      //   canceledUrl: session.cancelUrl,
      // );
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
            case VerificationStatus.ALREADY_USED:
              for (var listener in listeners) {
                listener.onPurchaseAlreadyUsed(purchase);
              }
              return;
            default:
              throw 'Error on Purchase';
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
