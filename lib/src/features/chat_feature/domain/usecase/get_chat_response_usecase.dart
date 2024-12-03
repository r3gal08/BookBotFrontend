import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/repository/chat_repository.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';

@lazySingleton
class GetChatResponseUsecase {
  final ChatRepository repository;
  GetChatResponseUsecase(this.repository);

  // Future<Either<Failure, ChatResponseEntity>> execute({required String userInput}) async {
  //   return repository.getChatResponse(userInput: userInput);
  // }

  // This method triggers the process of getting chat responses from the repository based on user input
  Stream<ChatResponseEntity> execute({required String userInput, required PayloadType pType}) {
    return repository.getChatResponseStream(userInput: userInput, pType: pType);
  }

  void abortRequest() async {
    return await repository.abortRequest();
  }
}
