import 'package:camballey_frontend_2025/presentation/auth/profile_screen.dart';
import 'package:camballey_frontend_2025/presentation/auth/register_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/driver_view.dart';
import '../presentation/passenger_view.dart';

class Routes {
  static const login = '/login';
  static const driver = '/driver';
  static const passenger = '/passenger';
  static const profile = '/profile';
  static const register = '/register';
}

class AppRouter {
  // Tabla de rutas directas
  static Map<String, WidgetBuilder> get routes => {
        Routes.login: (_) => const LoginScreen(),
        Routes.driver: (_) => const DriverView(),
        Routes.profile: (_) => const ProfileScreen(),
        Routes.passenger: (_) => const PassengerView(),
        Routes.register: (_) => const RegisterScreen(), // reemplaza si tienes pantalla de registro
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
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
