      import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesync/auth/login_screen.dart';
import 'package:firesync/component/round_button.dart';
      import 'package:flutter/material.dart';


      class MorePage extends StatefulWidget {
        const MorePage({super.key});

        @override
        State<MorePage> createState() => _MorePageState();
      }

      class _MorePageState extends State<MorePage> {
          final _auth = FirebaseAuth.instance;


          void logout() async {
            try{
              await _auth.signOut();
                  if (!mounted) return; // Ensures context is valid before navigating

               Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
            }catch(error){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error Logging out:$error'))
              );
            }
          }

        @override
        Widget build(BuildContext context) {
          return Scaffold(

            body: Center(child: RoundButton(title: 'Sign Out', onTap: logout),),
          );
        }
      }