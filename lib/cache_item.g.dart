// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CacheItem _$CacheItemFromJson(Map<String, dynamic> json) {
  return CacheItem(
      key: json['key'] as String,
      timeStamp: json['timeStamp'] as int,
      data: json['data'] as String);
}

Map<String, dynamic> _$CacheItemToJson(CacheItem instance) => <String, dynamic>{
      'key': instance.key,
      'data': instance.data,
      'timeStamp': instance.timeStamp
    };
