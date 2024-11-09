import 'package:ollama_flutter_app/bootstrap.dart';
import 'package:ollama_flutter_app/src/app.dart';
import 'package:ollama_flutter_app/src/constants/env.dart';
import 'package:ollama_flutter_app/src/di/di.dart';

// TODO: General TODOs
// Can likely take a much more simpler approach of just sending text stream and/or images to a backend server/container (recall base64 conversion...)
// Monitor app resources usage.... Ensure things are getting cleaned up
void main() {
  configureDependencies(env: AppEnvironments.dev);

  bootstrap(() => MyApp());
}
