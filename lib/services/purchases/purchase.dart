import 'package:custom_services/services/purchases/service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase.freezed.dart';
part 'purchase.g.dart';

@freezed
class PurchaseInfo with _$PurchaseInfo {
  const PurchaseInfo._();

  const factory PurchaseInfo({
    required String productId,
    String? type,
    @Default('undefined') String provider,
    String? token,
    PurchaseStatus? status,
  }) = _PurchaseInfo;

  static PurchaseInfo from(PurchaseDetails details) {
    return PurchaseInfo(
      productId: details.productID,
      status: details.status,
    );
  }

  factory PurchaseInfo.fromJson(Map<String, Object?> json) =>
      _$PurchaseInfoFromJson(json);
}
