import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kehof/models/admin_main_content.dart';
import 'package:kehof/models/auth_processing.dart';
import 'package:kehof/screens/admin_login_page.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:provider/provider.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.hasError) {
            Provider.of<MainStore>(context, listen: false).setIslogin(false);
            return const AuthProcessing(
                errorprint: 'Error at getting user authentication');
          }

          if (user.connectionState == ConnectionState.waiting) {
            Provider.of<MainStore>(context, listen: false).setIslogin(false);
            return const AuthProcessing(
                errorprint: 'Loading user authentication');
          }

          if (!user.hasData) {
            Provider.of<MainStore>(context, listen: false).setIslogin(false);
            return LoginPage();
          }

          // else User signed in:
          Provider.of<MainStore>(context, listen: false).setIslogin(true);
          return AdminMainContent();
        });
  }
}
