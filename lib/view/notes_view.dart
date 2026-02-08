import 'dart:developer' as devtools;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:classnotes/firebase_options.dart';
import 'package:classnotes/routes/route_generator.dart';
import 'package:classnotes/view/notes_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';
import '../routes/app_routes.dart';

enum MenuAction { logout }

class notesView extends StatefulWidget {
  const notesView({super.key});

  @override
  State<notesView> createState() => _notesViewState();
}

class _notesViewState extends State<notesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 99, 238),
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shoulLogOut = await ShowlogOutDialog(context);
                  if (shoulLogOut) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Center(child: Text("This is the notes view")),
    );
  }
}

Future<bool> ShowlogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
