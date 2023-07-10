import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/verify_view.dart';
import 'views/register_view.dart';
import 'views/home_screen.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const NewHome(),
      routes: {
        "/login/": (context) => const LoginScreen(),
        "/register/": (context) => const RegisterView(),
      },
    ),
  );
}

class NewHome extends StatelessWidget {
  const NewHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified == false) {
                    return const VerifyEmailView();
                  }
                  return const LandingScreen();
                } else {
                  return const LoginScreen();
                }

              default:
                return const Text("Loading");
            }
          },
        ),
      ),
    );
  }
}
