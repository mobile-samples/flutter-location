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
      json['email'],
      json['id'],
      json['token'],
      json['tokenExpiredTime']);
}

class AuthResponse {
  AuthResponse(this.user, this.status);
  AuthInfo user;
  int status;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        AuthInfo.fromJson(json['user']),
        json['status'],
      );
}
