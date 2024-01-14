import 'dart:io' show Platform;
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpHelper {
  HttpHelper._instantiate();
  static final HttpHelper instance = HttpHelper._instantiate();

  final String baseUrlIOS = 'http://localhost:8082';
  final String baseUrlAndroid = 'http://10.0.2.2:8082';

  getUrl() {
    if (Platform.isAndroid) {
      return baseUrlAndroid;
    } else if (Platform.isIOS) {
      return baseUrlIOS;
    }
    return 'http://localhost:8082';
  }

  jsonDecode(List<int> bodyBytes) {
     String source = const Utf8Decoder().convert(bodyBytes);
     return json.decode(source);
  }

  buildHeader() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';
    if (token != '') {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }
}
