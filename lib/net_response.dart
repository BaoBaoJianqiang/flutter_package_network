class NetResponse {
  int isError;
  int errorType;
  String errorMessage;
  dynamic result;

  NetResponse({this.isError, this.errorType, this.errorMessage, this.result});

  factory NetResponse.fromJson(Map<String, dynamic> json) {
    return NetResponse(
        isError : json['isError'],
        errorType : json['errorType'],
        errorMessage : json['errorMessage'],
        result : json['result']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isError'] = this.isError;
    data['errorType'] = this.errorType;
    data['errorMessage'] = this.errorMessage;
    data['result'] = this.result;
    return data;
  }
}