import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("World of Warcraft Subscribers"),
      ),
      body: Center(
        child: Text("charts_flutter_example"),
      ),
    );
  }
}