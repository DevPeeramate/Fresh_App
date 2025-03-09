import 'package:flutter/material.dart';

class MeatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
        title: Text('Meat'),
      ),
      body: Center(
        child: Text('This is the Meat screen'),
      ),
    );
  }
}