import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/constants/endpoints/dev_endpoints.dart';
import 'package:ollama_flutter_app/src/constants/endpoints/endpoints.dart';
import 'package:ollama_flutter_app/src/constants/endpoints/prod_endpoints.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/data/datasource/remote_chat_datasource.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/data/repository/chat_repository.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/repository/chat_repository.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ollama_flutter_app/src/services/get_cameras_service.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  HttpClient get httpClient => HttpClient();

  @singleton
  Future<SharedPreferences> get sharedPreferences async => await SharedPreferences.getInstance();

  // (A lazy singleton creates an instance only when it is actually needed....)
  // // ABSTRACT CLASSES NEED TO IMPORT LIKE THIS WITH ACTUAL IMPLEMENTATION
  @lazySingleton
  ChatRepository get chatRepository => ChatRepositoryImpl(getIt());

  @lazySingleton
  ChatDatasource get chatDatasource => RemoteChatDatasource(getIt());

  // SERVICE
  @lazySingleton
  StoreService get storeService => StoreService(getIt());

  // CAMERAS
  // Register CameraService as a lazy singleton
  @lazySingleton
  GetCamerasService get getCameraService => GetCamerasService()..initialize();

  @Environment('dev')
  @singleton
  AppEndpoints get devEndpoints => DevEndpoints();

  @Environment('production')
  @singleton
  AppEndpoints get prodEndpoints => ProdEndpoints();
}
