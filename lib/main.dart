import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/transceiver_controller.dart';
import 'ui/screens/transceiver_screen.dart';
import 'ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ITantraApp());
}

class ITantraApp extends StatelessWidget {
  const ITantraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransceiverController(),
      child: MaterialApp(
        title: 'iTantra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const TransceiverScreen(),
      ),
    );
  }
}
