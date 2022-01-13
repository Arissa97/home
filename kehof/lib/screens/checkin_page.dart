import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kehof/models/navigation_model.dart';
import 'package:kehof/screens/image_view_page.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({Key? key}) : super(key: key);

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppbar("KEHOF"),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              return _buildNormalContainer(context);
            } else {
              return _buildNormalContainer(context);
            }
          },
        ));
  }
}

Widget _buildNormalContainer(BuildContext context) {
  final _dependentController = TextEditingController();

  // print(Provider.of<UserStore>(context, listen: true).getVaccineProfile());
  // print(Uint8List(10));
  // if (XFile.fromData(Uint8List(0)).name == "") {
  //   print("TRUE");
  // }
  // print("TEST");
  // print(XFile.fromData(Uint8List(0)).name);
  // print(XFile.fromData(Uint8List(0)).mimeType);

  KehofEvent kevent =
      Provider.of<UserStore>(context, listen: false).getKehofEvent();
  KehofMember kehofMember =
      Provider.of<UserStore>(context, listen: false).getKehofMember();
  KehofParticipant kehofParticipant =
      Provider.of<UserStore>(context, listen: false).getKehofParticipant();

  _dependentController.text = kehofParticipant.dependent.toString();

  if (kehofParticipant.dependent > 0) {
    Provider.of<UserStore>(context, listen: false)
        .initYesDependentBtnState(true);
  }

  return ListView(
    children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Text(kevent.title),
              Text(DateFormat('dd-MM-yyyy').format(kevent.datetime)),
              Text(DateFormat('HH : mm').format(kevent.datetime)),
              Text("Hi ${kehofParticipant.name}"),
              kehofParticipant.active
                  ? Text("Member ID: ${kehofMember.id}")
                  : const Text("Visitor"),
            ],
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Card(
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Upload Vaccination Profile")),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    FirebaseStorage.instance
                        .ref(
                            'users/${Provider.of<UserStore>(context, listen: false).getMemberPhone()}/vaccineProfile.png')
                        .getDownloadURL()
                        .then((value) =>
                            Provider.of<UserStore>(context, listen: false)
                                .setVaccineURL(value))
                        .catchError(
                            (error) => print("Failed to get URL: $error"));

                    Navigator.pushNamed(context, "/vaccinebrowse");
                  },
                  child: const Text('Upload'),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Bring any dependent?")),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Card(
                        child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            Provider.of<UserStore>(context, listen: false)
                                .setYesDependentBtnState(true);
                          },
                          child: const Text('Yes'),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: SizedBox(
                              width: 100,
                              height: 60,
                              child: TextField(
                                enabled: Provider.of<UserStore>(context,
                                        listen: true)
                                    .yesDependentBtnState(),
                                controller: _dependentController,
                                onChanged: (value) {
                                  // _dependentController.text = value;

                                  if (_dependentController.text.isNotEmpty) {
                                    Provider.of<UserStore>(context,
                                            listen: false)
                                        .setNumDependent(int.parse(
                                            _dependentController.text));
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(\d+)'))
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "##",
                                ),
                              ),
                            ))
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        Provider.of<UserStore>(context, listen: false)
                            .setNoDependentBtnState(true);
                        _dependentController.text = "";
                      },
                      child: const Text('No'),
                    ),
                  ),
                ],
              ),
              !kehofParticipant.active
                  ? Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: _buildTotalPayment(context)),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: Provider.of<UserStore>(context,
                                            listen: false)
                                        .getKehofEvent()
                                        .open
                                    ? () {
                                        FirebaseStorage.instance
                                            .ref(
                                                'publicEvents/${kevent.id}/users/${Provider.of<UserStore>(context, listen: false).getMemberPhone()}/pop.png')
                                            .getDownloadURL()
                                            .then((value) =>
                                                Provider.of<UserStore>(context,
                                                        listen: false)
                                                    .setPopURL(value))
                                            .catchError((error) => print(
                                                "Failed to get pop URL: $error"));

                                        Navigator.pushNamed(
                                            context, "/popbrowse");
                                      }
                                    : null,
                                child: const Text('Online Transfer'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: Provider.of<UserStore>(context,
                                            listen: false)
                                        .getKehofEvent()
                                        .open
                                    ? () {}
                                    : null,
                                child: const Text('Cash'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20)),
                            onPressed:
                                Provider.of<UserStore>(context, listen: false)
                                        .getKehofEvent()
                                        .open
                                    ? () {}
                                    : null,
                            child: const Text('Voucher'),
                          ),
                        ),
                      ],
                    )
                  : Text(""),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Attendance")),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: Provider.of<UserStore>(context, listen: false)
                          .getKehofEvent()
                          .open
                      ? () {
                          kehofParticipant.attend = true;
                        }
                      : null,
                  child: const Text('Check-in'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Provider.of<UserStore>(context, listen: false)
                          .getKehofEvent()
                          .open
                      ? const Text("")
                      : const Text(
                          "*Attendance check-in and payment will be available on event day")),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20)),
          onPressed: () async {
            String phone =
                Provider.of<UserStore>(context, listen: false).getMemberPhone();

            CollectionReference kehofParticipantRef = FirebaseFirestore.instance
                .collection('/public/activeevent/participants')
                .withConverter<KehofParticipant>(
                  fromFirestore: (snapshot, _) =>
                      KehofParticipant.fromJson(snapshot.data()!),
                  toFirestore: (evt, _) => evt.toJson(),
                );

            kehofParticipantRef
                .doc(phone.toString())
                .set(Provider.of<UserStore>(context, listen: false)
                    .getKehofParticipant())
                .then((value) => print("User Added"))
                .catchError((error) => print("Failed to add user: $error"));

            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Update"),
                    content: Text("Your pre-registration has been recorded"),
                    actions: [
                      TextButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });

            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: const Text('Update'),
        ),
      )
    ],
  );
}

Widget _buildTotalPayment(BuildContext context) {
  double costperhead =
      Provider.of<UserStore>(context, listen: true).getKehofEvent().costperhead;
  // int numDependent =
  //     Provider.of<UserStore>(context, listen: true).getNumDependent();
  // double total = costperhead * numDependent;
  return Text("Payment to be made: RM ${costperhead.toStringAsFixed(2)}");
}
