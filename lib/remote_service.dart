library flutter_package_network;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'cache_manager.dart';
import 'net_response.dart';
import 'url_data.dart';

class RemoteService {
  //static String serverName = "http://127.0.0.2:8888";        //模拟器
  static String serverName = "http://192.168.1.5:8889"; //真机,同一个网段

  // 区分get还是post的枚举
  static final String REQUEST_GET = "get";
  static final String REQUEST_POST = "post";

  Map<String, String> parameter = null;

  //Tag，用于cancel，标记一类请求
  static final String Tag = "tag";

  // 工厂模式
  factory RemoteService() => _getInstance();

  static RemoteService get instance => _getInstance();
  static RemoteService _instance;

  RemoteService._internal() {
    // 初始化
  }

  static RemoteService _getInstance() {
    if (_instance == null) {
      _instance = new RemoteService._internal();
    }
    return _instance;
  }

  static List<dynamic> urlDataList;

  void invoke (String apiKey, { Map<String, String> params = null,
      final onSuccess,
      final onFail,
      final bool forceUpdate = false,
      final int retryTimes = -100}) async {

    URLData urlData;
    bool find = false;
    for(int i = 0; i < urlDataList.length; i++) {
      urlData = new URLData.fromJson(urlDataList[i]);
      if(urlData.key == apiKey) {
        find = true;
        break;
      }
    }

    if(!find) {
      //以后改
      return;
    }

    int retryTimesInRecusive = retryTimes;

    //强制更新
    if (forceUpdate) {
      urlData.expires = 0;
    }

    int retryTimesInConfig = urlData.retryTimes;
    //第一次进来(-100)，并且有重试机制
    if (retryTimesInRecusive == -100 && retryTimesInConfig > 0) {
      retryTimesInRecusive = retryTimesInConfig;
    }

    String newUrl = serverName + urlData.url;
    parameter = params;

    if (urlData.netType == REQUEST_GET) {
      // 添加参数
      final StringBuffer paramBuffer = new StringBuffer();
      if ((parameter != null) && (parameter.length > 0)) {
        // 这里要对key进行排序
        List<String> keys = parameter.keys.toList();
        // key排序
        keys.sort((a, b) {
          List<int> al = a.codeUnits;
          List<int> bl = b.codeUnits;
          for (int i = 0; i < al.length; i++) {
            if (bl.length <= i)
              return 1;
            if (al[i] > bl[i]) {
              return 1;
            } else if (al[i] < bl[i])
              return -1;
          }
          return 0;
        });

        for (int i = 0; i < keys.length; i++) {
          String k1 = keys[i];
          String v1 = parameter[k1];

          if (paramBuffer.length == 0) {
            paramBuffer.write(k1 + "="
                + Uri.encodeComponent(v1));
          } else {
            paramBuffer.write("&" + k1 + "=" + Uri.encodeComponent(v1));
          }
        }

        newUrl += "?" + paramBuffer.toString();
      }

      print(newUrl);

      if (urlData.expires > 0) {
        print("走缓存");

        dynamic content = await CacheManager.instance.getFileCache(newUrl);
        print("baobao");
        print(content);
        if (content != null) {
          if(onSuccess != null) {
            onSuccess(content);
            return;
          }
        }
      }

      http.get(newUrl).then((response) {
        if (response.statusCode == 200) {
          print("走网络");

          Utf8Decoder decode = new Utf8Decoder();
          dynamic decodeBody = json.decode(decode.convert(response.bodyBytes));

          var res = NetResponse.fromJson(decodeBody);
          if (res.isError == 0) {
            //把成功获取到的数据记录到缓存
            if (urlData.expires > 0) {
              CacheManager.instance.putFileCache(newUrl, response.body, urlData.expires);
            }

            onSuccess(decodeBody);
          } else {
            onFail(res.errorMessage);
          }
        } else {
          print('网络错误');
        }
      });
    } else {
      http.post(newUrl, body: json.encode(parameter)).then((response) {
        if (response.statusCode == 200) {

          Utf8Decoder decode = new Utf8Decoder();
          dynamic decodeBody = json.decode(decode.convert(response.bodyBytes));
          print(decodeBody);
          var res = NetResponse.fromJson(decodeBody);
          if (res.isError == 0) {
            if(onSuccess == null)
              return;

            onSuccess(decodeBody);
          } else {
            if(onFail == null)
              return;

            onFail(res.errorMessage);
          }
        } else {
          print('网络错误');
        }
      });
    }
  }
}
