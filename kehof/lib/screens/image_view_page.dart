import 'package:flutter/material.dart';
import 'package:kehof/models/navigation_model.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({Key? key}) : super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: userAppbar("KEHOF"),
        body: Stack(alignment: Alignment.bottomRight, children: [
          Container(
              color: Colors.black,
              child: Provider.of<UserStore>(context, listen: false)
                          .getVaccineURL() !=
                      ""
                  ? Image.network(
                      Provider.of<UserStore>(context, listen: false)
                          .getVaccineURL(),
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      Provider.of<UserStore>(context, listen: false)
                          .getVaccineBlob(),
                      fit: BoxFit.cover,
                    )),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                padding: EdgeInsets.all(20.0),
                child: const Text(
                  "Vaccine Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                )),
          ]),
        ]));
  }
}
