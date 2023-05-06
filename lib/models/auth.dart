class AuthInfo {
  AuthInfo(this.username, this.displayName, this.email, this.id, this.token,
      this.tokenExpiredTime);

  String username;
  String displayName;
  String email;
  String id;
  String token;
  String tokenExpiredTime;

  factory AuthInfo.fromJson(Map<String, dynamic> json) => AuthInfo(
      json['username'],
      json['displayName'] == null ? '' : json['displayName'],
      json['email'] == null ? '' : json['email'],
      json['id'],
      json['token'],
      json['tokenExpiredTime']);
}

class AuthResponse {
  AuthResponse(this.user, this.status, this.errors);

  AuthInfo? user;
  int status;
  List<ErrorResponse>? errors;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        json['user'] == null ? null : AuthInfo.fromJson(json['user']),
        json['status'],
        json['errors'] == null
            ? null
            : List<ErrorResponse>.from(
                json['errors'].map((data) => ErrorResponse.fromJson(data))),
      );
}

class ErrorResponse {
  ErrorResponse(this.field, this.code);

  String field;
  String code;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        json['field'] == null ? '' : json['field'],
        json['code'] == null ? '' : json['code'],
      );
}
