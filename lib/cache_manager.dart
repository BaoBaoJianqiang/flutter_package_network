import 'dart:io';

import 'dart:convert';
import 'cache_item.dart';
import 'utils.dart';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  // 工厂模式
  factory CacheManager() => _getInstance();

  static CacheManager get instance => _getInstance();
  static CacheManager _instance;

  CacheManager._internal() {
    // 初始化
  }

  static CacheManager _getInstance() {
    if (_instance == null) {
      _instance = new CacheManager._internal();
    }
    return _instance;
  }



  /**
   * 查询是否有key对应的缓存文件
   *
   * @param key
   * @return
   */
  Future<bool> contains(final String key) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;

    File file = new File('$documentsPath/' + key);
    return file.existsSync();
  }

  /**
   * 从文件缓存中取出缓存，没有则返回空
   *
   * @param key
   * @return
   */
  Future<dynamic> getFileCache(final String key) async {
    String md5Key = Utils.getMd5(key);

    bool find = await contains(md5Key);
    if(!find)
      return null;

    return await getFromCache(md5Key);
  }

  /**
   * API data 缓存到文件
   *
   * @param key
   * @param data
   * @param outDate
   */
  void putFileCache(final String key, final String data,
      int expiredTime) async {
    String md5Key = Utils.getMd5(key);

    final CacheItem item = new CacheItem(
        key: md5Key,
        timeStamp: Utils.currentTimeMillis() + expiredTime * 1000,
        data: data);

    putIntoCache(item);
  }

  /**
   * 将CacheItem从磁盘读取出来
   *
   * @param path
   * @return 缓存数据CachItem
   */
  Future<dynamic> getFromCache(final String key) async{

    // 获取应用文档目录并创建文件
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;

    File file = new File('$documentsPath/' + key);
    if(!file.existsSync()) {
      return null;
    }

    String content = await file.readAsString();

    print(content);

    //把content转为CacheItem

    dynamic a = json.decode(content);
    print(a);
    Map<String, dynamic> item1 = a as Map<String, dynamic>;
    int timestamp = item1["timeStamp"];

    print("manyun");
    print(Utils.currentTimeMillis());
    print(timestamp);

    // 缓存过期
    if (Utils.currentTimeMillis() > timestamp) {
      return null;
    }

    print(item1["data"]);
    return item1["data"];
  }

  /**
   * 将CacheItem缓存到磁盘
   *
   * @param item
   * @return 是否缓存，True：缓存成功，False：不能缓存
   */
  Future<bool> putIntoCache(final CacheItem item) async {

    // 获取应用文档目录并创建文件
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;

    File file = new File('$documentsPath/' + item.key);
    if(!file.existsSync()) {
      file.createSync();
    }

    //把item转为字符串
    String content = item.toString();
    print(content);

    File file1 = await file.writeAsString(content);
    if(file1.existsSync()) {
      return true;
    } else {
      return false;
    }
  }
}