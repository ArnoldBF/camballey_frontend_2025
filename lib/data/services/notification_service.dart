import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService I = NotificationService._();

  final _fln = FlutterLocalNotificationsPlugin();
  bool _inited = false;

  // Canal (Android 8+)
  static const String _channelId   = 'pagos_channel';
  static const String _channelName = 'Pagos';
  static const String _channelDesc = 'Alertas de pagos y saldos';

  Future<void> init() async {
    if (_inited) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _fln.initialize(initSettings);
    _inited = true;
  }

  Future<void> show({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _fln.show(0, title, body, details);
  }
}
