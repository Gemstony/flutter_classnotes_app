import 'package:classnotes/firebase_options.dart';
import 'package:classnotes/services/auth/auth_user.dart';
import 'package:classnotes/services/auth/auth_provider.dart';
import 'package:classnotes/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw userNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw weakPasswordException();
      } else if (e.code == 'invalid-email') {
        throw invalidEmailException();
      } else if (e.code == 'email-already-in-use') {
        throw emailAlreadyInUseException();
      } else {
        throw genericAuthException();
      }
    } catch (_) {
      throw genericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw userNotFoundException();
      }
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw userNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw wrongPasswordException();
      } else {
        throw genericAuthException();
      }
    } catch (_) {
      throw genericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw userNotLoggedInException();
    }
  }

  @override
  Future<AuthUser> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      return currentUser!;
    } else {
      throw userNotLoggedInException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
