import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/di/di.config.dart';

// TODO: What im currently doing with cameras is wildly messy. I should be able to simply inject/init the camera module once here and use globally.
//       look into this next time, then remove code that is creating a damn camera in every class

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',      // default
  preferRelativeImports: true,  // default
  asExtension: true,            // default
)
void configureDependencies({required String env}) => getIt.init(environment: env);
