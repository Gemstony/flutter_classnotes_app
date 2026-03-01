import 'package:classnotes/services/auth/auth_exceptions.dart';
import 'package:classnotes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Verify your email address"),
        SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            final user = AuthService.firebase().currentUser;

            if (user == null) return;

            try {
              await user.sendEmailVerification();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Verification email sent successfully."),
                ),
              );
            } on userNotFoundException {
              if (!mounted) return;

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("User not found!")));
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
