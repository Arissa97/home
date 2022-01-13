import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';

import 'models/navigation_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // https://www.fluttercampus.com/guide/52/how-to-get-parameters-from-url-in-flutter-web/
  // String myurl = Uri.base.toString(); //get complete url
  String? page =
      Uri.base.queryParameters["page"]; //get parameter with attribute "page"

  bool admin = false;
  if (page == "admin") {
    admin = true;
  }

  runApp(MyApp(admin: admin));
}

class MyApp extends StatelessWidget {
  final bool admin;
  MyApp({Key? key, required this.admin}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Row(
            children: [
              Expanded(child: Text("${snapshot.error}")),
              Container(
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () => {
                    // store.setLoginFlag(false)
                  },
                  child: const Text('Relog'),
                ),
              ),
            ],
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<MainStore>(
                  create: (context) => MainStore()),
              ChangeNotifierProvider<UserStore>(
                  create: (context) => UserStore()),
            ],
            child: const NavigationModel(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
