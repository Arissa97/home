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

class PopUploadPage extends StatefulWidget {
  const PopUploadPage({Key? key}) : super(key: key);

  @override
  State<PopUploadPage> createState() => _PopUploadPageState();
}

class _PopUploadPageState extends State<PopUploadPage> {
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
      Provider.of<UserStore>(context, listen: false).setPopBlob(pickedFile);
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
                  child: Text("Online Transfer")),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Gambar logo bank")),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Account No:")),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("0123456456789")),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Account Holder:")),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Ali Khan")),
              const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text("Upload proof of payment")),
              Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: _buildPopPic(context)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () {
                    _imgFromGallery();
                  },
                  child: const Text('Browse'),
                ),
              ),
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
                .getPopBlob()
                .isNotEmpty) {
              UploadTask uploadTask = FirebaseStorage.instance
                  .ref('publicEvents/${kevent.id}/users/$phone/pop.png')
                  .putData(Provider.of<UserStore>(context, listen: false)
                      .getPopBlob());

              uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                print('Task state pop.png: ${snapshot.state}');
                print(
                    'Progress pop.png: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');

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

            // String refID = users.doc().id;
            // .then((value) => print("User Added ${value.id}"))

            Navigator.pop(context);
          },
          child: const Text('Upload'),
        ),
      )
    ],
  );
}

Widget _buildPopPic(BuildContext context) {
  if (Provider.of<UserStore>(context, listen: true).getPopURL() != "") {
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
          Provider.of<UserStore>(context, listen: false).getPopURL(),
          fit: BoxFit.cover,
        ),
      ),
    );
  } else if (Provider.of<UserStore>(context, listen: true)
      .getPopBlob()
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
          Provider.of<UserStore>(context, listen: false).getPopBlob(),
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
