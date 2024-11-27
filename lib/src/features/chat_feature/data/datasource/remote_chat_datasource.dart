// This file contains the actual code that is responsible for directly interacting with the data provider.
//  (which in this case is our language chat model)

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart'; // Importing Ollama class

abstract class ChatDatasource {
  Stream<ChatResponseEntity> getChatResponseFromServer({required String userInput});
  Future<void> abortCurrentRequest();
}

class RemoteChatDatasource extends ChatDatasource {
  final HttpClient _client;
  RemoteChatDatasource(this._client);

  late HttpClientRequest request;

  @override
  Stream<ChatResponseEntity> getChatResponseFromServer({required String userInput}) async* {
    try {
      final baseUrl = await getIt<StoreService>().getBaseUrl();
      final basePort = await getIt<StoreService>().getPort();
      final basePath = await getIt<StoreService>().getPath();
      final baseModel = await getIt<StoreService>().getModel();

      request = await _client.post(
        baseUrl,
        basePort,
        basePath,
      );
      Map<String, dynamic> jsonMap = {
        "model": baseModel,
        "prompt": userInput,
      };
      String jsonString = json.encode(jsonMap);       // Converting to json string
      List<int> bodyBytes = utf8.encode(jsonString);  // Encoding to bytes for http
      request.add(bodyBytes);
      HttpClientResponse response = await request.close();
      final responseMessage = [];
      final context = [];

      await for (final chunk in response.transform(utf8.decoder)) {
        final resp = json.decode(chunk);
        // print(resp);
        if (resp['done'] == false) {
          // print(resp);
          yield ChatResponseEntity.fromJson(resp);
          responseMessage.add(resp['response'].toString());
        } else {
          yield ChatResponseEntity.fromJson(resp);
          context.add(resp['context']);
        }
      }
      // print(responseMessage.join(''));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    } finally {
      // TODO: Un-comment? Mess around with backend server to view client connection staying open, will want to close this....
      //       we will likely want to implement some form of logic that keeps client open for a certain amount of time
      // _client.close();
    }
  }

  @override
  Future<void> abortCurrentRequest() async {
    try {
      request.abort();
      request.addError('request aborted');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
