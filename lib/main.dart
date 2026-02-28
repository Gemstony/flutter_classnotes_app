import 'package:classnotes/firebase_options.dart';
import 'package:classnotes/routes/route_generator.dart';
import 'package:classnotes/view/notes_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        if (mounted) setState(() => _body = const notesView());
      } else {
        if (mounted) setState(() => _body = const verifyEmail());
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

class verifyEmail extends StatefulWidget {
  const verifyEmail({super.key});

  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Verify your email address"),
        SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) return;

            try {
              await user.sendEmailVerification();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Verification email sent successfully."),
                ),
              );
            } on FirebaseAuthException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.message ?? "Failed to send verification email.",
                  ),
                ),
              );
            }
          },
          child: const Text(
            "Send Verification Email",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
