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
        drawer: adminDrawer(context),
        appBar: adminAppbar("KEHOF"),
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

  Future _imgFromGallery() async {
    // FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();

    final ImagePicker _picker = ImagePicker();

    XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    // PlatformFile file = result.files.first;

    // print(file.name);
    // print(file.bytes);
    // print(file.size);
    // print(file.extension);
    // print(file.path);

    if (pickedFile != null) {
      // File _image = File(pickedFile.path);
      // Uint8List fileBytes = pickedFile.files.first.bytes!;

      // Uint8List fileBytes = pickedFile.path;
      // print(pickedFile.path);
      Provider.of<UserStore>(context, listen: false).setVaccineBlob(pickedFile);
      print('image selected.');
    } else {
      print('No image selected.');
    }

    // Navigator.pop(context);
  }

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

  return ListView(
    children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Text(kevent.title),
              Text(DateFormat('dd-MM-yyyy').format(kevent.datetime)),
              Text(DateFormat('HH : mm').format(kevent.datetime)),
              Text("Hi ${kehofMember.name}"),
              Text("Member ID: ${kehofMember.id}"),
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
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: _buildProfilePic(context)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    _imgFromGallery();
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
                      },
                      child: const Text('No'),
                    ),
                  ),
                ],
              ),
              Provider.of<UserStore>(context, listen: true)
                      .yesDependentBtnState()
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
                                onPressed: () {
                                  Provider.of<UserStore>(context, listen: false)
                                      .setNoDependentBtnState(true);
                                },
                                child: const Text('Online Transfer'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  Provider.of<UserStore>(context, listen: false)
                                      .setNoDependentBtnState(true);
                                },
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
                            onPressed: () {
                              Provider.of<UserStore>(context, listen: false)
                                  .setNoDependentBtnState(true);
                            },
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
                      ? () {}
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
                          "*Attendance check-in will be available on event day")),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20)),
          onPressed: () {
            String phone =
                Provider.of<UserStore>(context, listen: false).getMemberPhone();

            if (Provider.of<UserStore>(context, listen: false)
                .getVaccineBlob()
                .isNotEmpty) {
              UploadTask uploadTask = FirebaseStorage.instance
                  .ref('users/$phone/vaccineProfile.png')
                  .putData(Provider.of<UserStore>(context, listen: false)
                      .getVaccineBlob());

              uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                print('Task state vaccineProfile.png: ${snapshot.state}');
                print(
                    'Progress vaccineProfile.png: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');

                // if (snapshot.state == TaskState.success) {}
              }, onError: (e) {
                // The final snapshot is also available on the task via `.snapshot`,
                // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
                print(uploadTask.snapshot);

                if (e.code == 'permission-denied') {
                  print(
                      'User does not have permission to upload to this reference.');
                }
              });
            }

            CollectionReference kehofevent = FirebaseFirestore.instance
                .collection('public')
                .withConverter<KehofParticipant>(
                  fromFirestore: (snapshot, _) =>
                      KehofParticipant.fromJson(snapshot.data()!),
                  toFirestore: (evt, _) => evt.toJson(),
                );

            kehofevent
                .doc('activeevent/participants/$phone')
                .set(kehofParticipant)
                .then((value) => print("User Added"))
                .catchError((error) => print("Failed to add user: $error"));
          },
          child: const Text('Update'),
        ),
      )
    ],
  );
}

Widget _buildProfilePic(BuildContext context) {
  if (Provider.of<UserStore>(context, listen: true).getVaccineURL() != "") {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ImageViewPage(),
          )),
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        height: 60,
        width: 60,
        child: Image.network(
          Provider.of<UserStore>(context, listen: false).getVaccineURL(),
          fit: BoxFit.cover,
        ),
      ),
    );
  } else if (Provider.of<UserStore>(context, listen: true)
      .getVaccineBlob()
      .isNotEmpty) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ImageViewPage(),
          )),
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        height: 60,
        width: 60,
        child: Image.memory(
          Provider.of<UserStore>(context, listen: false).getVaccineBlob(),
          fit: BoxFit.cover,
        ),
      ),
    );
  } else {
    return Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        height: 60,
        width: 60,
        child: Icon(
          Icons.photo_library,
          color: Colors.grey[800],
        ));
  }
}

Widget _buildTotalPayment(BuildContext context) {
  double costperhead =
      Provider.of<UserStore>(context, listen: true).getKehofEvent().costperhead;
  int numDependent =
      Provider.of<UserStore>(context, listen: true).getNumDependent();
  double total = costperhead * numDependent;
  return Text("Payment to be made: $total");
}
