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
    _init();
  }

  Future<void> _init() async {
    await ApiClient.init(); // Supabase init
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }
    return MaterialApp(
      title: 'Transporte Público',
      theme: buildAppTheme(),
      onGenerateRoute: onGenerateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
