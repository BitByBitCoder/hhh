import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  // void error() {
  //   Fluttertoast.showToast(
  //     msg: 'This is a toast message',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.grey,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // To hide the password text
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Login'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void dispose() {
    // Dispose of the CircularProgressIndicator when the widget is removed from the tree
    super.dispose();
  }

  bool loading = false;
  void signIn() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      var a = await FirebaseAuth.instance.currentUser!.email;

      //
      print('the curen is $a');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showErrorMessage(e.code);
    }
    // setState(() {
    //   loading = false;
    // });
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(message),
            ),
          );
        });
  }
}
