import 'package:dartz/dartz.dart';
import 'package:ollama_flutter_app/src/core/failures/failures.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/data/datasource/remote_chat_datasource.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/repository/chat_repository.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDatasource ds;
  ChatRepositoryImpl(this.ds);
  @override

  // This is whats called when the chat app wants to send a message to the server...
  @override
  Stream<ChatResponseEntity> getChatResponseStream({required String userInput, required PayloadType pType }) {
    return ds.getChatResponseFromServer(userInput: userInput, pType: pType).asBroadcastStream();
  }

  @override
  Future<void> abortRequest()async {
    return await ds.abortCurrentRequest();
  }
}
