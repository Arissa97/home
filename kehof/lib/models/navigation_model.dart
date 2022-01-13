import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kehof/screens/admin_main_page.dart';
import 'package:kehof/screens/create_event_page.dart';
import 'package:kehof/screens/event_history_page.dart';
import 'package:kehof/screens/front_page.dart';
import 'package:kehof/screens/pop_upload_page.dart';
import 'package:kehof/screens/search_user_page.dart';
import 'package:kehof/screens/checkin_page.dart';
import 'package:kehof/screens/update_event_page.dart';
import 'package:kehof/screens/vaccine_upload_page.dart';

class NavigationModel extends StatelessWidget {
  const NavigationModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KEHOF | Club Members Management System",
      initialRoute: '/',
      routes: {
        '/': (context) => const FrontPage(),
        '/admin': (context) => const AdminMainPage(),
        '/createevent': (context) => const CreateEventPage(),
        '/updateevent': (context) => const UpdateEventPage(),
        '/eventhistory': (context) => const EventHistoryPage(),
        '/searchuser': (context) => const SearchUserPage(),
        '/checkin': (context) => const CheckInPage(),
        '/vaccinebrowse': (context) => const VaccineUploadPage(),
        '/popbrowse': (context) => const PopUploadPage(),
      },
    );
  }
}

Widget adminDrawer(BuildContext context) {
  return Drawer(
      child: ListView(
    padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
    children: [
      Card(
        child: ListTile(
          title: Text("Main Page"),
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/admin'));
          },
        ),
      ),
      Card(
        child: ListTile(
          title: Text("Create Event"),
          onTap: () {
            Navigator.pushNamed(context, "/createevent");
          },
        ),
      ),
      Card(
        child: ListTile(
          title: Text("Update Event"),
          onTap: () {
            Navigator.pushNamed(context, "/updateevent");
          },
        ),
      ),
      Card(
        child: ListTile(
          title: Text("View Report"),
          onTap: () {},
        ),
      ),
      Card(
        child: ListTile(
          title: Text("Player Database"),
          onTap: () {},
        ),
      ),
      Card(
        child: ListTile(
          title: Text("Event History"),
          onTap: () {
            Navigator.pushNamed(context, "/eventhistory");
          },
        ),
      )
    ],
  ));
}

PreferredSizeWidget adminAppbar(String title) {
  return AppBar(
    title: Text(title),
    actions: [
      ElevatedButton(
        style:
            ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: const Text('Sign out'),
      )
    ],
  );
}

PreferredSizeWidget userAppbar(String title) {
  return AppBar(
    title: Text(title),
  );
}
