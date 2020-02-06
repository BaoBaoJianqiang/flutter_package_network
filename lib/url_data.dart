class URLData {
  String key;
  int expires;
  String netType;
  int retryTimes;
  String url;

  URLData({this.key, this.expires, this.netType, this.retryTimes, this.url});

  factory URLData.fromJson(Map<String, dynamic> parsedJson) {
    return URLData(
        key: parsedJson['key'],
        expires: parsedJson['expires'],
        netType: parsedJson['netType'],
        retryTimes: parsedJson['retryTimes'],
        url: parsedJson['url']);
  }
}