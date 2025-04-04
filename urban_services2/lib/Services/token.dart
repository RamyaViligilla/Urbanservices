import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageMethods {
  static const storage = FlutterSecureStorage();
  static Future<void> storeTokenUserType(String token) async {
    await storage.write(key: "token", value: token);
  }

  static Future<String?> getTokenUserType() async {
    return await storage.read(key: "token");
  }

  static Future<String?> removeAllTokens() async {
    await storage.deleteAll();
  }
}
