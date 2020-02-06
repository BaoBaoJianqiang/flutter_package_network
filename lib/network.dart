import 'url_data.dart';

class Network {
  List<dynamic> urlData;

  Network({this.urlData});

  factory Network.fromJson(Map<String, dynamic> parsedJson) {
    return Network(
        urlData: parsedJson['urlData']);
  }
}