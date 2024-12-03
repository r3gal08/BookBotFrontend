// This file contains the actual code that is responsible for directly interacting with the data provider.
//  (which in this case is our language chat model)

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart'; // Importing Ollama class

// Abstract class allows us to enforce creation of new/sub-classes or quickly mock up new classes for quick testing without modifying existing code
abstract class ChatDatasource {
  Stream<ChatResponseEntity> getChatResponseFromServer({
    required String userInput,
    required PayloadType pType,
  });
  Future<void> abortCurrentRequest();
}

// TODO: Use HTTPS!
// TODO: Error handling of http requests (response.statusCode)
// TODO: responseMessage and context variables could be removed as it is note used.
// TODO: Close client somewhere eventually!
// Best Practice: Close the client in a higher-level lifecycle manager (e.g.,
//  an app-wide HttpClient instance or in the repository layer). Don’t close it in the finally block here unless this is the last function using the client.
class RemoteChatDatasource extends ChatDatasource {
  final HttpClient _client;
  RemoteChatDatasource(this._client);

  late HttpClientRequest request;

  @override
  Stream<ChatResponseEntity> getChatResponseFromServer({required String userInput, required PayloadType pType}) async* {
    try {
      final baseUrl = await getIt<StoreService>().getBaseUrl();
      final basePort = await getIt<StoreService>().getPort();
      final endPoint = await getIt<StoreService>().getEndpoint(pType);  // get endpoint based on payloadType
      final baseModel = await getIt<StoreService>().getModel();

      request = await _client.post(
        baseUrl,
        basePort,
        endPoint,
      );

      Map<String, dynamic> jsonMap = {
        "model": baseModel,
        "prompt": userInput,
      };

      String jsonString = json.encode(jsonMap);       // Converting to json string
      List<int> bodyBytes = utf8.encode(jsonString);  // Encoding to bytes for http
      request.add(bodyBytes);                         // Adds the encoded body to the request.

      // Sends the request and wait for the server’s response...
      HttpClientResponse response = await request.close();

      final responseMessage = []; // Collects the streaming response from the server
      final context = [];         // Stores any additional metadata returned by the server

      await for (final chunk in response.transform(utf8.decoder)) {
        final resp = json.decode(chunk);
        //print(resp);
        if (resp['done'] == false) {
          // print(resp);
          yield ChatResponseEntity.fromJson(resp);            // Send a chunk of ChatResponseEntity to any listener subscribed to the Stream
          responseMessage.add(resp['response'].toString());
        } else {
          yield ChatResponseEntity.fromJson(resp);            // Send the final ChatResponseEntity to any listener subscribed to the Stream
          context.add(resp['context']);
        }
      }
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
