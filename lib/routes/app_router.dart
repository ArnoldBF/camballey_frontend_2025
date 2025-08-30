import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/driver_view.dart';
import '../presentation/passenger_view.dart';

class Routes {
  static const login = '/login';
  static const driver = '/driver';
  static const passenger = '/passenger';
}

class AppRouter {
  // Tabla de rutas directas
  static Map<String, WidgetBuilder> get routes => {
        Routes.login: (_) => const LoginScreen(),
        Routes.driver: (_) => const DriverView(),
        Routes.passenger: (_) => const PassengerView(),
      };

  // Fallback opcional
  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    switch (s.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.driver:
        return MaterialPageRoute(builder: (_) => const DriverView());
      case Routes.passenger:
        return MaterialPageRoute(builder: (_) => const PassengerView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
