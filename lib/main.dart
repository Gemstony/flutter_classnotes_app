import 'package:classnotes/routes/route_generator.dart';
import 'package:classnotes/services/auth/auth_exceptions.dart';
import 'package:classnotes/services/auth/auth_service.dart';
import 'package:classnotes/view/auth/notes_view.dart';
import 'package:classnotes/view/auth/verify_email_view.dart';
import 'package:classnotes/view/auth/notes_view.dart';
import 'package:flutter/material.dart';
import 'view/auth/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Class Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? _body;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final user = AuthService.firebase().currentUser;
    if (user != null) {
      if (user.isEmailVerified) {
        if (mounted) setState(() => _body = const NotesView());
      } else {
        if (mounted) setState(() => _body = const VerifyEmail());
      }
    } else {
      if (mounted) setState(() => _body = const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body ?? const Center(child: CircularProgressIndicator()),
    );
  }
}
