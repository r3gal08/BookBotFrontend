// Reference: https://kush373.medium.com/integrating-ollamas-apis-with-flutter-building-a-conversational-ai-app-local-chatgpt-flutter-42346513d033

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/presentation/cubit/chat_cubit.dart';
import 'package:ollama_flutter_app/src/router/app_router.gr.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:ollama_flutter_app/src/services/get_cameras_service.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/enums/payload_type.dart';


// TODO: There must be a program that just visualizes/builds the presentation portion of these files

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late BehaviorSubject<List<String>> messagesController;
  late BehaviorSubject<bool> loadingController;
  late ScrollController scrollController;

  bool _isUserDragging = false;
  String userName = 'User';
  String gpt = 'Bot';

  List<String> messages = []; // Stores message chunks

  final getCamerasService = getIt<GetCamerasService>();

  @override
  void initState() {
    messagesController = BehaviorSubject.seeded([]);
    loadingController = BehaviorSubject.seeded(false);
    scrollController = ScrollController();
    getUserDetails();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messages.clear();
    messagesController.close();
    loadingController.close();
  }

  void getUserDetails() async {
    userName = await getIt<StoreService>().getUser();
  }

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Page'), actions: [
        StreamBuilder(
            stream: loadingController,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true && mounted) {
                return const SizedBox(
                    height: 50,
                    width: 50,
                    // child: CircularProgressIndicator(
                    //   strokeWidth: 1,
                    // ),
                    child: SpinKitPulse(
                      color: Colors.green,
                      size: 50.0,
                    ));
              } else {
                return const SizedBox.shrink();
              }
            }),
        const SizedBox(
          width: 10,
        )
      ]),
      body: GestureDetector(
        onVerticalDragStart: (_) {
          _isUserDragging = true;
        },
        onVerticalDragEnd: (_) {
          _isUserDragging = false;
        },
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {      // Updates UI based on different states...
                  if (state is ChatNewResponse) {
                    // Append partial response to the last user message
                    messages[messages.length - 1] += state.entity.response;

                    messagesController.add(messages);
                    loadingController.add(true);

                    if (!_isUserDragging) {
                      // Only trigger auto-scroll if the user is not dragging the screen
                      _scrollDown();
                    }
                  } else if (state is ChatLoaded) {
                    // Add concatenated response as a single message
                    messages[messages.length - 1] += state.entity.response;   // Actual message contents from entity object
                    messagesController.add(messages);
                    loadingController.add(false);
                  } else if (state is ChatError) {
                    messages[messages.length - 1] += state.error;
                    messagesController.add(messages);
                    loadingController.add(false);
                  } else {
                    loadingController.add(false);
                  }
                },
                builder: (context, state) { // Displays the chat messages in a ListView. Last 2 messages have green text, rest are red. Also automatically scrolls user to the bottom of page
                  return ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        if (index == messages.length - 1 || index == messages.length - 2) {
                          return ListTile(
                            title: Text(
                              messages[index],
                              style: const TextStyle(color: Colors.green), // Recent text....
                            ),
                          );
                        }
                        return ListTile(
                          title: Text(
                            messages[index],
                            style: const TextStyle(color: Colors.red),  // Text above....
                          ),
                        );
                      });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,  // Text box background color
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (v) {
                            sendMessage();
                          },
                        ),
                      ),
                    ),
                  ),
                  // Camera Button
                  // Send Button
                  const SizedBox(width: 8.0),
                  StreamBuilder<bool>(
                    stream: loadingController,
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: (snapshot.hasData && snapshot.data == true)
                            ? () {
                          context.read<ChatCubit>().abortRequest();
                        }
                            : sendMessage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green,  // Send button background color
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: (snapshot.hasData && snapshot.data == true && mounted)
                                ? const SpinKitPulse(
                              color: Colors.green,
                              size: 20.0,
                            )
                                : const Icon(
                              Icons.send,
                              color: Colors.black,  // Send icon color
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.green), // Camera icon color
                    onPressed: () {
                      if (getCamerasService.hasCameras) {
                        // Navigate to the camera route if cameras are available
                        context.router.push(CameraRoute(cameras: getCamerasService.cameras));
                      } else {
                        // Show an alert if no cameras are available
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No cameras available")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    String message = _controller.text;
    if (message.isNotEmpty) {
      messages.add('$userName : $message');
      messages.add('$gpt : ');
      messagesController.add(messages);
      loadingController.add(true);
      context.read<ChatCubit>().getChatResponse(userInput: message, pType: PayloadType.image);
      _controller.clear();
    }
  }

  String generateResponse(String message) {
    // Simulate response generation based on user input
    return "This is a sample response to '$message'";
  }
}
