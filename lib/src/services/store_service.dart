import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

const String userKey = 'UserKey';
const String baseUrlKey = 'BaseUrlKey';
const String portKey = 'PortKey';
const String customPathKey = 'CustomPathKey';
const String customModelKey = 'CustomModelKey';

// DEFAULT
// const String defaultUrl = 'localhost';
const String defaultUrl = '192.168.4.153';
// TODO: Update port to be backend_port or something
const int defaultPort = 8080;
// TODO: Update defaultPath to be chat_path or something
//       Also add in defaultpath for image endpoint
const String defaultPath = '/chat';
const String defaultModel = 'llama3.2';

class StoreService {
  late SharedPreferences preferences;
  StoreService(this.preferences);

  // USER DETAILS
  Future<void> saveUser({required String? user}) async {
    if (user == null || user.isEmpty) {
      return;
    }
    await preferences.setString(userKey, user);
  }

  Future<String> getUser() async {
    final res = preferences.getString(userKey);
    return res ?? 'User';
  }

  // BASE URL DETAILS
  Future<void> saveBaseUrl({required String? baseUrl}) async {
    if (baseUrl == null || baseUrl.isEmpty) {
      return;
    }
    await preferences.setString(baseUrlKey, baseUrl);
  }

  Future<String> getBaseUrl() async {
    final res = preferences.getString(baseUrlKey);
    if (res != null && res.isNotEmpty) {
      return res;
    } else {
      // TODO: Keeping if statements in here just in the case where this might need to be handled in the future for some reason....
      // IF TESTING ON ANDROID EMULATOR
      // ELSE USE 127.0.0.1
      if (Platform.isAndroid) {
        return defaultUrl;
      } else if (Platform.isIOS) {
        return defaultUrl;
      } else {
        return defaultUrl;
      }
    }
  }

  // PORT  DETAILS
  Future<void> savePort({required int? port}) async {
    if (port == null) {
      return;
    }
    await preferences.setInt(portKey, port);
  }

  Future<int> getPort() async {
    final res = preferences.getInt(portKey);
    if (res != null) {
      return res;
    } else {
      return defaultPort;
    }
  }

  // PATH  DETAILS
  Future<void> savePath({required String? path}) async {
    if (path == null || path.isEmpty) {
      return;
    }
    await preferences.setString(customPathKey, path);
  }

  Future<String> getPath() async {
    final res = preferences.getString(customPathKey);
    if (res != null && res.isNotEmpty) {
      return res;
    } else {
      return defaultPath;
    }
  }

  // MODEL  DETAILS
  Future<void> saveModel({required String? model}) async {
    if (model == null || model.isEmpty) {
      return;
    }
    await preferences.setString(customModelKey, model);
  }

  Future<String> getModel() async {
    final res = preferences.getString(customModelKey);
    if (res != null && res.isNotEmpty) {
      return res;
    } else {
      return defaultModel;
    }
  }

  Future<void> clearAll() async {
    await preferences.clear();
  }
}
