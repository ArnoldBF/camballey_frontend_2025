import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'data/services/api_client.dart';
import 'presentation/auth/login_screen.dart';


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
      await ApiClient.init(); // ok si queda en MOCK
    } catch (_) {
      // silenciar en MVP
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
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Transporte Público',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),                 // inicio simple y seguro
      routes: AppRouter.routes,                  // rutas registradas
      onGenerateRoute: AppRouter.onGenerateRoute, // fallback si usas pushNamed con otra ruta
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
