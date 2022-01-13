import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kehof/models/navigation_model.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UpdateEventPage extends StatefulWidget {
  const UpdateEventPage({Key? key}) : super(key: key);

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference kehofevent = FirebaseFirestore.instance
        .collection('public')
        .withConverter<KehofEvent>(
          fromFirestore: (snapshot, _) => KehofEvent.fromJson(snapshot.data()!),
          toFirestore: (evt, _) => evt.toJson(),
        );

    return Consumer<MainStore>(builder: (context, store, child) {
      if (!store.islogin()) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }

      return Scaffold(
          drawer: adminDrawer(context),
          appBar: adminAppbar("KEHOF"),
          body: FutureBuilder<DocumentSnapshot>(
              future: kehofevent.doc("activeevent").get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  KehofEvent? kevent = snapshot.data!.data() as KehofEvent?;
                  Provider.of<UserStore>(context, listen: false)
                      .setKehofEvent(kevent!);
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth > 600) {
                        return _buildNormalContainer();
                      } else {
                        return _buildNormalContainer();
                      }
                    },
                  );
                }
                return const Text("loading");
              }));
    });
  }

  Widget _buildNormalContainer() {
    return ListView(
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Text("Update Event")),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Text(DateFormat('dd-MM-yyyy').format(
                Provider.of<UserStore>(context, listen: false)
                    .getKehofEvent()
                    .datetime))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Card(
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text("Event Status: Pre-Registration")),
                Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Text("Registration Attendance:")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Open the attendance now?"),
                                  content: Text(
                                      'This will enable players to record attendance and make payment.'),
                                  actions: [
                                    TextButton(
                                      child: Text('Not now'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Sure'),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[300]),
                                      onPressed: () {
                                        CollectionReference kehofeventref =
                                            FirebaseFirestore.instance
                                                .collection('public');

                                        kehofeventref
                                            .doc('activeevent')
                                            .update({'open': true})
                                            .then((value) =>
                                                print("Event Edited"))
                                            .catchError((error) => print(
                                                "Failed to edit Event: $error"));

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Open'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Close the attendance now?"),
                                  content: Text(
                                      'This will prevent new players from attending this event.'),
                                  actions: [
                                    TextButton(
                                      child: Text('Not now'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Sure'),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[300]),
                                      onPressed: () {
                                        CollectionReference kehofeventref =
                                            FirebaseFirestore.instance
                                                .collection('public');

                                        kehofeventref
                                            .doc('activeevent')
                                            .update({'open': false})
                                            .then((value) =>
                                                print("Event Edited"))
                                            .catchError((error) => print(
                                                "Failed to edit Event: $error"));

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Text("Closing Event Status:")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Close the event now?"),
                                  content: Text(
                                      'This event will become history. It cannot be re-open.'),
                                  actions: [
                                    TextButton(
                                      child: Text('Not now'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Sure'),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[300]),
                                      onPressed: () {
                                        WriteBatch batch =
                                            FirebaseFirestore.instance.batch();

                                        CollectionReference kehofeventhistory =
                                            FirebaseFirestore.instance
                                                .collection('eventhistory');

                                        String _id = Provider.of<UserStore>(
                                                context,
                                                listen: false)
                                            .getKehofEvent()
                                            .id;

                                        KehofEvent kevent =
                                            Provider.of<UserStore>(context,
                                                    listen: false)
                                                .getKehofEvent();

                                        KehofEventHistory keventhistory =
                                            Provider.of<UserStore>(context,
                                                    listen: false)
                                                .getKehofEventHistory();
                                        keventhistory.finished = true;
                                        keventhistory.title = kevent.title;
                                        keventhistory.datetime =
                                            kevent.datetime;
                                        keventhistory.capacity =
                                            kevent.capacity;
                                        keventhistory.canceled = false;
                                        keventhistory.costperhead =
                                            kevent.costperhead;
                                        keventhistory.totalparticipants = 0;
                                        keventhistory.totalmembers = 0;
                                        keventhistory.totalnonmembers = 0;
                                        keventhistory.pendingactions = true;
                                        keventhistory.currentcollection = 0;

                                        kehofeventhistory
                                            .doc(_id)
                                            .set(keventhistory.toJson())
                                            .then((value) {
                                          CollectionReference
                                              eventparticipations =
                                              FirebaseFirestore.instance.collection(
                                                  'public/activeevent/participants');

                                          eventparticipations
                                              .get()
                                              .then((querySnapshot) {
                                            int totalmembers = 0;
                                            int totalnonmembers = 0;
                                            querySnapshot.docs
                                                .forEach((document) {
                                              CollectionReference
                                                  neweventparticipations =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'eventhistory/$_id/participants');

                                              if (document.get("active")) {
                                                totalmembers += 1;
                                              } else {
                                                totalnonmembers += 1;
                                              }

                                              batch.set(
                                                  neweventparticipations
                                                      .doc(document.id),
                                                  document.data());

                                              batch.delete(document.reference);
                                            });

                                            CollectionReference deleteeventref =
                                                FirebaseFirestore.instance
                                                    .collection('public');
                                            batch.delete(deleteeventref
                                                .doc('activeevent'));

                                            keventhistory.totalparticipants =
                                                totalmembers + totalnonmembers;
                                            keventhistory.totalmembers =
                                                totalmembers;
                                            keventhistory.totalnonmembers =
                                                totalnonmembers;

                                            batch.update(
                                                kehofeventhistory.doc(_id),
                                                keventhistory.toJson());

                                            batch.commit();
                                          });
                                        }).catchError((error) => print(
                                                "Failed to add user: $error"));

                                        Navigator.popUntil(context,
                                            ModalRoute.withName('/admin'));
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Finished'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Cancel the event?"),
                                  content: Text(
                                      'This event will become history. It cannot be re-open.'),
                                  actions: [
                                    TextButton(
                                      child: Text('Not now'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Sure'),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[300]),
                                      onPressed: () {
                                        WriteBatch batch =
                                            FirebaseFirestore.instance.batch();

                                        CollectionReference kehofeventhistory =
                                            FirebaseFirestore.instance
                                                .collection('eventhistory');

                                        String _id = Provider.of<UserStore>(
                                                context,
                                                listen: false)
                                            .getKehofEvent()
                                            .id;

                                        KehofEvent kevent =
                                            Provider.of<UserStore>(context,
                                                    listen: false)
                                                .getKehofEvent();

                                        KehofEventHistory keventhistory =
                                            Provider.of<UserStore>(context,
                                                    listen: false)
                                                .getKehofEventHistory();
                                        keventhistory.finished = false;
                                        keventhistory.title = kevent.title;
                                        keventhistory.datetime =
                                            kevent.datetime;
                                        keventhistory.capacity =
                                            kevent.capacity;
                                        keventhistory.canceled = true;
                                        keventhistory.costperhead =
                                            kevent.costperhead;
                                        keventhistory.totalparticipants = 0;
                                        keventhistory.totalmembers = 0;
                                        keventhistory.totalnonmembers = 0;
                                        keventhistory.pendingactions = true;
                                        keventhistory.currentcollection = 0;

                                        kehofeventhistory
                                            .doc(_id)
                                            .set(keventhistory.toJson())
                                            .then((value) {
                                          CollectionReference
                                              eventparticipations =
                                              FirebaseFirestore.instance.collection(
                                                  'public/activeevent/participants');

                                          eventparticipations
                                              .get()
                                              .then((querySnapshot) {
                                            int totalmembers = 0;
                                            int totalnonmembers = 0;
                                            querySnapshot.docs
                                                .forEach((document) {
                                              CollectionReference
                                                  neweventparticipations =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'eventhistory/$_id/participants');

                                              if (document.get("active")) {
                                                totalmembers += 1;
                                              } else {
                                                totalnonmembers += 1;
                                              }

                                              batch.set(
                                                  neweventparticipations
                                                      .doc(document.id),
                                                  document.data());

                                              batch.delete(document.reference);
                                            });

                                            CollectionReference deleteeventref =
                                                FirebaseFirestore.instance
                                                    .collection('public');
                                            batch.delete(deleteeventref
                                                .doc('activeevent'));

                                            keventhistory.totalparticipants =
                                                totalmembers + totalnonmembers;
                                            keventhistory.totalmembers =
                                                totalmembers;
                                            keventhistory.totalnonmembers =
                                                totalnonmembers;

                                            batch.update(
                                                kehofeventhistory.doc(_id),
                                                keventhistory.toJson());

                                            batch.commit();
                                          });
                                        }).catchError((error) => print(
                                                "Failed to add user: $error"));

                                        Navigator.popUntil(context,
                                            ModalRoute.withName('/admin'));
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Canceled'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideContainers() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.red,
          ),
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
