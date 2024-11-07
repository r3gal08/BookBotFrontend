import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

// Add the @RoutePage() annotation to register this page with AutoRoute
@RoutePage()
class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Page'),
      ),
      body: Center(
        child: const Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
