import 'package:camballey_frontend_2025/presentation/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'data/services/api_client.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    _boot();
  }

   Future<void> _boot() async {
    try {
      await ApiClient.init(); // ahora puede dejar supa en null (MOCK) sin romper
    } catch (e, st) {
      // Log por si algo pasa en init
      debugPrint('Init error: $e\n$st');
    } finally {
      if (mounted) setState(() => _ready = true);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        theme: buildAppTheme(),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // ⚠️ Deja SOLO "home" por ahora.
    // No uses initialRoute ni onGenerateRoute hasta que confirmes que dibuja.
    return MaterialApp(
      title: 'Transporte Público',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
