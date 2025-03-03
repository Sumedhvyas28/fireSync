import 'package:firesync/repo/splash_screen.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenRepo splashScreenRepo = SplashScreenRepo();
  @override
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    splashScreenRepo.isLogin(context);
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:Center(
            child: Image.asset(
          'assets/logo.jpg',
          height: 100,
        ),
      ),
    );
  }
}