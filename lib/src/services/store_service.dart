import 'dart:io';

import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings page keys
const String userKey = 'UserKey';
const String baseUrlKey = 'BaseUrlKey';
const String portKey = 'PortKey';
const String customModelKey = 'CustomModelKey';

// Network configuration
const String localhostUrl = 'localhost';
const int localPort = 11434;
const String defaultUrl = '192.168.4.153';
const int defaultPort = 8080;

// End point configurations
const String ollamaDirectPath = '/api/generate';
const String chatEndpoint = '/chat';
const String imageEndpoint = '/image';

// Models
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

  // ENDPOINT  DETAILS
  Future<String> getEndpoint(PayloadType pType) async {
    switch (pType) {
      case PayloadType.image:
        return imageEndpoint;
      case PayloadType.text:
        //return chatEndpoint;
        return ollamaDirectPath;
      default:
        throw Exception('Unsupported payload type: ${pType}');
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
