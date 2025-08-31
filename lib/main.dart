import 'package:camballey_frontend_2025/data/services/notification_service.dart' as notif;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notif.NotificationService.I.init(); // 👈 tu servicio, garantizado no nulo
  runApp(const MyApp());
}

  