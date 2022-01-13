import 'package:flutter/material.dart';
import 'package:kehof/models/navigation_model.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FrontPageState();
  }
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("KEHOF"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.pushNamed(context, "/admin");
              },
              child: const Text('Sign in'),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.pushNamed(context, "/searchuser");
            },
            child: const Text('Register for event'),
          ),
        ));
  }
}
