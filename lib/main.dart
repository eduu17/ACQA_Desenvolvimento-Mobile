import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AcqaTarefasApp());
}

class AcqaTarefasApp extends StatelessWidget {
  const AcqaTarefasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACQA Tarefas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const AuthScreen(),
    );
  }
}
