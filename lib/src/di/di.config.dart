// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i497;

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../constants/endpoints/endpoints.dart' as _i499;
import '../features/chat_feature/data/datasource/remote_chat_datasource.dart'
    as _i156;
import '../features/chat_feature/domain/repository/chat_repository.dart'
    as _i994;
import '../features/chat_feature/domain/usecase/get_chat_response_usecase.dart'
    as _i980;
import '../features/chat_feature/presentation/cubit/chat_cubit.dart' as _i569;
import '../services/store_service.dart' as _i563;
import 'di_register_modules.dart' as _i1036;

const String _dev = 'dev';
const String _production = 'production';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singletonAsync<_i460.SharedPreferences>(
        () => registerModule.sharedPreferences);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i497.HttpClient>(() => registerModule.httpClient);
    gh.lazySingleton<_i994.ChatRepository>(() => registerModule.chatRepository);
    gh.lazySingleton<_i156.ChatDatasource>(() => registerModule.chatDatasource);
    gh.lazySingleton<_i563.StoreService>(() => registerModule.storeService);
    gh.lazySingleton<_i980.GetChatResponseUsecase>(
        () => _i980.GetChatResponseUsecase(gh<_i994.ChatRepository>()));
    gh.singleton<_i499.AppEndpoints>(
      () => registerModule.devEndpoints,
      registerFor: {_dev},
    );
    gh.factory<_i569.ChatCubit>(
        () => _i569.ChatCubit(gh<_i980.GetChatResponseUsecase>()));
    gh.singleton<_i499.AppEndpoints>(
      () => registerModule.prodEndpoints,
      registerFor: {_production},
    );
    return this;
  }
}

class _$RegisterModule extends _i1036.RegisterModule {}
