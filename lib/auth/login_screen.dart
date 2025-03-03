import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesync/component/round_button.dart';
import 'package:firesync/component/text_button.dart';
import 'package:firesync/component/utils.dart';
import 'package:firesync/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;
  bool loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> storeUserData(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    await userRef.set({
      'uid': user.uid,
      'email': user.email,
      'createdAt': DateTime.now().toIso8601String(),
      'lastLogin': DateTime.now().toIso8601String(),
      'role': 'user',
    });
  }

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      utils().toastMessage('Email or Password cannot be empty');
      return;
    }

    setState(() => loading = true);

    _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text.trim(),
    ).then((value) async {
      await storeUserData(value.user!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }).catchError((error) {
      print('..///.....');
      
      print(error);
      print('..dd/d/d/d/d/');
      utils().toastMessage(error.toString());
    }).whenComplete(() => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.jpg', height: 150),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Enter your Email'),
              ),
            ),
                        SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundButton(title: 'Login', loading: loading, onTap: login),
            ),
            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButtons(title: 'Sign/Up', loading: loading, onTap: login,color: Colors.purple,),
            ),
          ],
        ),
      ),
    );
  }
}
