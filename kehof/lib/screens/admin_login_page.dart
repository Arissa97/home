import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "admin@kehof.com";
  String password = "admin123";

  void setName(String namex) {
    username = namex;
    // setState(() {
    //   username = namex;
    // });
  }

  void setPass(String passx) {
    password = passx;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Center(
        child: Card(
            child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "Username"),
                    onChanged: (value) => setName(value))),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    onChanged: (value) => setPass(value))),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ElevatedButton(
                style: style,
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: username, password: password);
                  } on FirebaseAuthException catch (e) {
                    String errortext = "";
                    if (e.code == 'user-not-found') {
                      errortext = 'No user found for that email.';
                    } else if (e.code == 'wrong-password') {
                      errortext = 'Wrong password provided for that user.';
                    }
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(errortext),
                              content: const Text('Retry'),
                              actions: [
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop('my return string');
                                  },
                                ),
                              ],
                            ));
                  }
                },
                child: const Text('Sign in'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
