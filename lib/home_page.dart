import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firesync/more_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
class _HomePageState extends State<HomePage> {

  @override

  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "FireSync",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
  actions: [
          
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MorePage(),
                ),
              );
            },
          ),
        ],      ),      
      body: Center(child: Text(
      'ffffff'
      ),),
    );
  }
}