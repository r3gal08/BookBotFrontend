import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/camera_feature/presentation/cubit/camera_cubit.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/presentation/cubit/chat_cubit.dart';

// TODO: Get a better understanding of this piece of code in general.....
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change) ${DateTime.timestamp()}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');

    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Initialize Flutter bindings and error handling
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    debugPrint(details.stack.toString());
  };

  // Initialize Bloc observer for logging purposes
  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(getBlocProviders(await builder()));
}

Widget getBlocProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => getIt<ChatCubit>(),
      ),
      BlocProvider(
        create: (context) => getIt<CameraCubit>(),    // TODO: Confirm this is valid....
      ),
    ],
    child: child,
  );
}
