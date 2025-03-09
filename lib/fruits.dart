import 'package:flutter/material.dart';

class FruitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับอัตโนมัติ
        title: Text('Fruits'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.local_florist),
            title: Text('Apple'),
          ),
          ListTile(
            leading: Icon(Icons.local_florist),
            title: Text('Banana'),
          ),
          ListTile(
            leading: Icon(Icons.local_florist),
            title: Text('Orange'),
          ),
          ListTile(
            leading: Icon(Icons.local_florist),
            title: Text('Grapes'),
          ),
        ],
      ),
    );
  }
}