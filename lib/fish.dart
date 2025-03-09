import 'package:flutter/material.dart';

class FishScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
        title: Text('Fish'),
      ),
      body: Center(
        child: Text('This is the Fish Screen'),
      ),
    );
  }
}