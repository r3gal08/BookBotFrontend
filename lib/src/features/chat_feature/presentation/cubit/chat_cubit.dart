import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/usecase/get_chat_response_usecase.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';

part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final GetChatResponseUsecase usecase;       // Will be used to fetch chat responses
  StreamSubscription? _responseSubscription;  // Optional field that allows for the cancellation of subs when necessary

  ChatCubit(this.usecase) : super(ChatInitial());

  getChatResponse({required String userInput, required PayloadType pType}) async {
    _responseSubscription?.cancel();
    _responseSubscription = usecase.execute(userInput: userInput, pType: pType).listen(
      (response) {
        if (response.done == false) {       // Checks if the response indicates an ongoing proces
          emit(ChatLoading());              // Emits a loading state to the UI.
          emit(ChatNewResponse(response));  // Emits a new chat response state with the current response
        } else {                            // If response is complete...
          emit(ChatLoaded(response));       // Emits a loaded state with the final response
        }
      },
      onError: (error) {
        emit(ChatError(error.toString()));
      },
    );
  }

  abortRequest() {
    emit(ChatLoading());
    usecase.abortRequest();
    emit(const ChatError('request aborted try again'));
  }

  @override
  Future<void> close() {
    _responseSubscription?.cancel();
    return super.close();
  }
}
