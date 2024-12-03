import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart';
import 'package:rxdart/rxdart.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late BehaviorSubject<bool> loadingController;
  late TextEditingController? baseUrlController;
  late TextEditingController? basePortController;
  late TextEditingController? modelNameController;
  late TextEditingController? userNameController;

  @override
  void initState() {
    loadingController = BehaviorSubject.seeded(false);
    baseUrlController = TextEditingController();
    basePortController = TextEditingController();
    modelNameController = TextEditingController();
    userNameController = TextEditingController();
    super.initState();
    loadSettings();
  }

  @override
  void dispose() {
    loadingController.close();
    super.dispose();
  }

  // Async-await ensures that settings are loaded in the correct order without blocking the main thread...
  // ? == null-aware operator which ensures that if a value is "null", the operation is skipped - preventing a runtime error
  Future<void> loadSettings() async {
    loadingController.add(true);
    baseUrlController?.text = await getIt<StoreService>().getBaseUrl();
    basePortController?.text = "${await getIt<StoreService>().getPort()}";  // "${<DATA>}" == Convert to string
    modelNameController?.text = await getIt<StoreService>().getModel();
    userNameController?.text = await getIt<StoreService>().getUser();
    loadingController.add(false);
  }

  // Async-await ensures that settings are saved in the correct order without blocking the main thread...
  Future<void> saveSettings() async {
    await getIt<StoreService>().saveBaseUrl(baseUrl: baseUrlController?.text);
    await getIt<StoreService>().savePort(port: int.tryParse(basePortController?.text ?? '') ?? 0);
    await getIt<StoreService>().saveModel(model: modelNameController?.text);
    await getIt<StoreService>().saveUser(user: userNameController?.text);
    await loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: StreamBuilder<bool>(
        stream: loadingController,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('User Name', userNameController),
                _buildTextField('Base URL', baseUrlController),
                _buildTextField('Base Port', basePortController),
                _buildTextField('Model Name', modelNameController),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await saveSettings();
                        Navigator.pop(context); // Return to main page when settings are saved...
                      },
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await getIt<StoreService>().clearAll();
                        await loadSettings();
                      },
                      child: const Text('Set default'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController? controller) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
