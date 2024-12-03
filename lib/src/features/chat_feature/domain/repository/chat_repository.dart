import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';

abstract class ChatRepository {
  Stream<ChatResponseEntity> getChatResponseStream({required String userInput, required PayloadType pType });

  Future<void> abortRequest();
}
