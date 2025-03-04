import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesync/auth/sign_up.dart';
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

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      utils().toastMessage('Email or Password cannot be empty');
      return;
    }

    setState(() => loading = true);

    Future<void> updateLastLogin(User user) async {
      final userRef = _firestore.collection('users').doc(user.uid);

      await userRef.update({
        'lastLogin': DateTime.now().toIso8601String(),
      }).catchError((error) {
        print('Error updating last login: $error');
      });
    }

    _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text.trim(),
    ).then((value) async {
      await updateLastLogin(value.user!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }).catchError((error) {
      utils().toastMessage(error.toString());
    }).whenComplete(() => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FireSync Title
              const Text(
                'FireSync',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password Input
              TextField(
                controller: passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              RoundButton(
                title: 'Login',
                loading: loading,
                onTap: login,
             
              ),
              const SizedBox(height: 10),

              // Sign Up Button
              TextButtons(
                title: 'Sign Up',
                loading: loading,
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                ),
                color: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
