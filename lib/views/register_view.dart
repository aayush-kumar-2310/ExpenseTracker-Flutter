import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const Text(
            "REGISTER",
            style: TextStyle(
                color: Colors.transparent,
                decorationColor: Colors.black,
                shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                fontSize: 24,
                decoration: TextDecoration.underline,
                decorationThickness: 3),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                hintText: "Your email here",
                label: const Text("E-mail"),
              ),
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: TextField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                filled: true,
                hintText: "Your password",
                label: const Text("Password"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
              ),
              controller: _password,
              keyboardType: TextInputType.text,
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "A verification mail has been sent at $email. Kindly check your email."),
                  ),
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == "invalid-email") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid email entered."),
                    ),
                  );
                } else if (e.code == "email-already-in-use") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "The email is already registered! Kindly login.")));
                }
              }
            },
            child: const Text(
              "Register",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: const Text(
              "Already Registered? Login here",
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
