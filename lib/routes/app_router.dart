import 'package:flutter/material.dart';

import '../presentation/auth/login_screen.dart';
import '../presentation/auth/profile_screen.dart';
import '../presentation/auth/register_screen.dart';

// Importa SOLO los símbolos necesarios para evitar colisiones
import '../presentation/driver_view.dart' show DriverView;
import '../presentation/passenger_view.dart' show PassengerView;

class Routes {
  static const login = '/login';
  static const driver = '/driver';
  static const passenger = '/passenger';
  static const profile = '/profile';
  static const register = '/register';
}

class AppRouter {
  // Mapa de rutas directas
  static Map<String, WidgetBuilder> get routes => {
        Routes.login: (_) => const LoginScreen(),
        Routes.driver: (_) => DriverView(),       // sin const por si tu vista no es const
        Routes.passenger: (_) => PassengerView(), // idem
        Routes.profile: (_) => const ProfileScreen(),
        Routes.register: (_) => const RegisterScreen(),
      };

  // Fallback opcional
  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    switch (s.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.driver:
        return MaterialPageRoute(builder: (_) => DriverView());
      case Routes.passenger:
        return MaterialPageRoute(builder: (_) => PassengerView());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
