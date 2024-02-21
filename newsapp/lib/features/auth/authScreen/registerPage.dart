import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();
final nameController = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
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
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Email',
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
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: register,
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
                  : const Text('Register'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        )));
  }

  bool loading = false;
  void register() async {
    try {
      setState(() {
        loading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'uid': uid,
        'moderator': false,
        'superUser': false,
      });
      CollectionReference favoritesRef = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('favorites');
      await favoritesRef.add({
        'title': 'Favorite Item 1',
        'createdAt': FieldValue.serverTimestamp(),
      });
      CollectionReference myPost = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('post');
      await myPost.add({
        'title': 'Favorite Item 1',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('login');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showErrorMessage(e.code);
      loading = false;
    }
    loading = false;
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

  void dispose() {
    // Dispose of the CircularProgressIndicator when the widget is removed from the tree
    super.dispose();
  }
}
