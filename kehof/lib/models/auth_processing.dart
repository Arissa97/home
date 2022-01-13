import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:provider/provider.dart';

class AuthProcessing extends StatelessWidget {
  final String errorprint;

  const AuthProcessing({Key? key, required this.errorprint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Login'),
        ),
        body: Center(
          child: Text(errorprint),
        ));
  }
}
