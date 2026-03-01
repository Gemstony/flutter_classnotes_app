import 'package:classnotes/routes/app_routes.dart';
import 'package:classnotes/services/auth/auth_exceptions.dart';
import 'package:classnotes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration page"),
        backgroundColor: Colors.amber,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter Email"),
            ),
            TextField(
              controller: _password,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Enter Password"),
            ),
            SizedBox(height: 20),

            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  if (!context.mounted) return;
                  final user = AuthService.firebase().currentUser;
                  if (user != null) {
                    await user.sendEmailVerification();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User registered successfully")),
                  );
                } on weakPasswordException {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Weak password")));
                } on emailAlreadyInUseException {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Email already in use")),
                  );
                } on invalidEmailException {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Invalid email")));
                } on genericAuthException {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Failed to register")));
                }
              },
              child: Text("Register"),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              },
              child: Text(
                "Already registered? Login here",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
