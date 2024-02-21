import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/features/auth/authScreen/loginPage.dart';
import 'package:newsapp/features/auth/authScreen/login_registerPage.dart';
import 'package:newsapp/features/home/screen/homescreen.dart';
import 'package:newsapp/features/navigator/navigator.dart';
import '../../../core/provider/provider.dart';

// StateProvider(int Function(dynamic ref) param0) {
// }

class AuthCheck extends ConsumerWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigatorBar();
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
