import 'utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cache_item.g.dart';

@JsonSerializable()
class CacheItem {

  /** 存储的key */
  String key;

  /** JSON字符串 */
  String data;

  /** 过期时间的时间戳 */
  int timeStamp = 0;

  CacheItem({this.key, this.timeStamp, this.data});

  //反序列化
  factory CacheItem.fromJson(Map<String, dynamic> json) => _$CacheItemFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$CacheItemToJson(this);

  @override
  String toString() {
    return '{"key": "$key", "data": $data, "timeStamp": $timeStamp}';
  }
}