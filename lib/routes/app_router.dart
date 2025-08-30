import 'package:flutter/material.dart';
import '../presentation/auth/login_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case '/home':
      // TODO: reemplaza con PassengerHome / DriverHome según rol leído en profiles
      return MaterialPageRoute(builder: (_) => const Scaffold(
        body: Center(child: Text('Home (redirigir según rol)')),
      ));
    default:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
  }
}
