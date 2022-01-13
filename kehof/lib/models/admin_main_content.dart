import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:provider/provider.dart';

import 'navigation_model.dart';

class AdminMainContent extends StatelessWidget {
  const AdminMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: adminDrawer(context),
      appBar: adminAppbar("KEHOF"),
      body: const Center(
        child: Card(child: Text("Hello Admin")),
      ),
    );
  }
}
