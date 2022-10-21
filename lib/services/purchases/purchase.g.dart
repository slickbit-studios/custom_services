// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PurchaseInfo _$$_PurchaseInfoFromJson(Map<String, dynamic> json) =>
    _$_PurchaseInfo(
      productId: json['productId'] as String,
      type: json['type'] as String?,
      provider: json['provider'] as String? ?? 'undefined',
      token: json['token'] as String?,
      status: $enumDecodeNullable(_$PurchaseStatusEnumMap, json['status']),
      baseUrl: json['baseUrl'] as String?,
    );

Map<String, dynamic> _$$_PurchaseInfoToJson(_$_PurchaseInfo instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'type': instance.type,
      'provider': instance.provider,
      'token': instance.token,
      'status': _$PurchaseStatusEnumMap[instance.status],
      'baseUrl': instance.baseUrl,
    };

const _$PurchaseStatusEnumMap = {
  PurchaseStatus.pending: 'pending',
  PurchaseStatus.purchased: 'purchased',
  PurchaseStatus.error: 'error',
  PurchaseStatus.restored: 'restored',
  PurchaseStatus.canceled: 'canceled',
};
