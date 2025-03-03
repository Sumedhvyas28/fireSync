import 'package:flutter/material.dart';

class TextButtons extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  final Color color;
  const TextButtons(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.color,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(title,style: TextStyle(color: color),),
      
    );
  }
}