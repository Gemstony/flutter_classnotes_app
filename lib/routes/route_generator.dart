import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../main.dart';
import '../view/register_view.dart';
import '../view/login_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (context) => const RegisterView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case AppRoutes.verifyEmail:
        return MaterialPageRoute(builder: (context) => const verifyEmail());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
