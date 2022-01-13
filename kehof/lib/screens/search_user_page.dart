import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kehof/models/navigation_model.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppbar("KEHOF"),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              return _NormalContainer();
            } else {
              return _NormalContainer();
            }
          },
        ));
  }
}

class _NormalContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NormalContainerState();
  }
}

class _NormalContainerState extends State<_NormalContainer> {
  final _phonenumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _yobController = TextEditingController();
  String prevPhoneInput = "";

  @override
  void initState() {
    super.initState();

    _phonenumberController.text = "01234567891";

    // Start listening to changes.
    _phonenumberController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _phonenumberController.dispose();
    _nameController.dispose();
    _yobController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    print('Second text field: ${_phonenumberController.text}');
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference kehofevent = FirebaseFirestore.instance
        .collection('public')
        .withConverter<KehofEvent>(
          fromFirestore: (snapshot, _) => KehofEvent.fromJson(snapshot.data()!),
          toFirestore: (evt, _) => evt.toJson(),
        );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: FutureBuilder<DocumentSnapshot>(
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
                return Column(
                  children: [
                    Text(kevent.title),
                    Text(DateFormat('dd-MM-yyyy').format(kevent.datetime)),
                    Text(DateFormat('HH : mm').format(kevent.datetime)),
                  ],
                );
              }

              return const Text("loading");
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Card(
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text("Are you active member of KEHOF?")),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () {
                          Provider.of<UserStore>(context, listen: false)
                              .setYesMemberBtnState(true);
                        },
                        child: const Text('Yes'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () {
                          Provider.of<UserStore>(context, listen: false)
                              .setNoMemberBtnState(true);
                        },
                        child: const Text('No'),
                      ),
                    ),
                  ],
                ),
                Consumer<UserStore>(builder: (context, store, child) {
                  if (store.yesMemberBtnState()) {
                    _nameController.text = store.getKehofMember().name;
                    _yobController.text = store.getKehofMember().yob.toString();
                    if (_yobController.text == "0") _yobController.text = "";
                    return Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: TextField(
                            autofocus: true,
                            controller: _phonenumberController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(0\d+)|0'))
                            ],
                            decoration: InputDecoration(
                                labelText:
                                    "Insert Phone Number (eg. 0123456789)",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  tooltip: "Search",
                                  onPressed: () {
                                    if (_phonenumberController.text !=
                                        prevPhoneInput) {
                                      prevPhoneInput =
                                          _phonenumberController.text;

                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_phonenumberController.text)
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          Map<String, dynamic> data =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>;
                                          store.setKehofMemberFactory(data);

                                          FirebaseFirestore.instance
                                              .collection(
                                                  '/public/activeevent/participants')
                                              .doc(_phonenumberController.text)
                                              .get()
                                              .then((DocumentSnapshot
                                                  documentSnapshot) {
                                            if (documentSnapshot.exists) {
                                              Map<String, dynamic> data =
                                                  documentSnapshot.data()
                                                      as Map<String, dynamic>;
                                              store.setKehofParticipantFactory(
                                                  data);
                                            } else {
                                              print('Member not yet pre-reg');
                                            }
                                          });
                                          store.setSearchMemberFound(true);
                                        } else {
                                          store.setSearchMemberFound(false);
                                          print('Member data not found');
                                        }
                                      });
                                    }
                                  },
                                )),
                          )),
                      store.getSearchMemberFound()
                          ? Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: TextField(
                                enabled: false,
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                ),
                              ),
                            )
                          : const Text(""),
                      store.getSearchMemberFound()
                          ? Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: TextField(
                                enabled: store.getKehofMember().yob == 0,
                                keyboardType: TextInputType.number,
                                controller: _yobController,
                                decoration: const InputDecoration(
                                  labelText: "Year of Birth (eg. 1980)",
                                ),
                              ),
                            )
                          : const Text(""),
                    ]);
                  } else if (store.noMemberBtnState()) {
                    _nameController.text = store.getKehofParticipant().name;
                    _yobController.text =
                        store.getKehofParticipant().yob.toString();
                    if (_yobController.text == "0") _yobController.text = "";
                    return Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: TextField(
                            autofocus: true,
                            controller: _phonenumberController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) =>
                                store.setSearchMemberFound(false),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(0\d+)|0'))
                            ],
                            decoration: InputDecoration(
                                labelText:
                                    "Insert Phone Number (eg. 0123456789)",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    if (_phonenumberController.text !=
                                        prevPhoneInput) {
                                      prevPhoneInput =
                                          _phonenumberController.text;

                                      FirebaseFirestore.instance
                                          .collection(
                                              '/public/activeevent/participants')
                                          .doc(_phonenumberController.text)
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          Map<String, dynamic> data =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>;
                                          store
                                              .setKehofParticipantFactory(data);
                                        } else {
                                          print(
                                              'Document does not exist on the database');
                                        }
                                      });
                                    }
                                  },
                                )),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _yobController,
                          decoration: const InputDecoration(
                            labelText: "Year of Birth (eg. 1980)",
                          ),
                        ),
                      )
                    ]);
                  }
                  return const Text("");
                }),
              ],
            ),
          ),
        ),
        Consumer<UserStore>(builder: (context, store, child) {
          if (store.yesMemberBtnState()) {
            if (!store.getSearchMemberFound()) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    if (_phonenumberController.text != prevPhoneInput) {
                      prevPhoneInput = _phonenumberController.text;

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(_phonenumberController.text)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          Map<String, dynamic> data =
                              documentSnapshot.data() as Map<String, dynamic>;
                          store.setKehofMemberFactory(data);

                          FirebaseFirestore.instance
                              .collection('/public/activeevent/participants')
                              .doc(_phonenumberController.text)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data() as Map<String, dynamic>;
                              store.setKehofParticipantFactory(data);
                            } else {
                              print('Member not yet pre-reg');
                            }
                          });
                          store.setSearchMemberFound(true);
                        } else {
                          store.setSearchMemberFound(false);
                          print('Member data not found');
                        }
                      });
                    }
                  },
                  child: const Text('Search'),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  store.getKehofParticipant().name = _nameController.text;
                  store.getKehofParticipant().active = true;
                  store.getKehofParticipant().yob =
                      int.parse(_yobController.text);
                  store.setMemberPhone(_phonenumberController.text);

                  FirebaseStorage.instance
                      .ref(
                          'users/${_phonenumberController.text}/vaccineProfile.png')
                      .getDownloadURL()
                      .then((value) => store.setVaccineURL(value))
                      .catchError(
                          (error) => print("Failed to get URL: $error"));

                  if (int.parse(_yobController.text) !=
                      store.getKehofMember().yob) {
                    CollectionReference kehofmemberref = FirebaseFirestore
                        .instance
                        .collection(
                            'users/${store.getMemberPhone().toString()}')
                        .withConverter<KehofMember>(
                          fromFirestore: (snapshot, _) =>
                              KehofMember.fromJson(snapshot.data()!),
                          toFirestore: (evt, _) => evt.toJson(),
                        );

                    KehofMember kmember = store.getKehofMember();

                    kmember.yob = int.parse(_yobController.text);

                    // store.setKehofMemberFactory(
                    //     kmember as Map<String, Object?>);

                    kehofmemberref
                        .doc(store.getMemberPhone().toString())
                        .update({'yob': int.parse(_yobController.text)})
                        .then((value) => print("User Edited"))
                        .catchError(
                            (error) => print("Failed to edit user: $error"));
                  }

                  // CollectionReference kehofParticipantRef = FirebaseFirestore
                  //     .instance
                  //     .collection('/public/activeevent/participants')
                  //     .withConverter<KehofParticipant>(
                  //       fromFirestore: (snapshot, _) =>
                  //           KehofParticipant.fromJson(snapshot.data()!),
                  //       toFirestore: (evt, _) => evt.toJson(),
                  //     );

                  // kehofParticipantRef
                  //     .doc(_phonenumberController.text)
                  //     .set(store.getKehofParticipant())
                  //     .then((value) => print("User Added"))
                  //     .catchError((error) => print("Failed to add user: $error"));

                  Navigator.pushNamed(context, "/checkin");
                },
                child: const Text('Next'),
              ),
            );
          } else if (store.noMemberBtnState()) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  store.getKehofParticipant().name = _nameController.text;
                  store.getKehofParticipant().active = false;
                  store.getKehofParticipant().yob =
                      int.parse(_yobController.text);
                  store.setMemberPhone(_phonenumberController.text);

                  // CollectionReference kehofParticipantRef = FirebaseFirestore
                  //     .instance
                  //     .collection('/public/activeevent/participants')
                  //     .withConverter<KehofParticipant>(
                  //       fromFirestore: (snapshot, _) =>
                  //           KehofParticipant.fromJson(snapshot.data()!),
                  //       toFirestore: (evt, _) => evt.toJson(),
                  //     );

                  // kehofParticipantRef
                  //     .doc(_phonenumberController.text)
                  //     .set(store.getKehofParticipant())
                  //     .then((value) => print("User Added"))
                  //     .catchError((error) => print("Failed to add user: $error"));

                  Navigator.pushNamed(context, "/checkin");
                },
                child: const Text('Next'),
              ),
            );
          }

          return const Text("");
        })
      ],
    );
  }
}

Widget _buildNormalContainer(BuildContext context) {
  return const Text("");
}
