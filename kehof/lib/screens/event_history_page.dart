import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kehof/models/navigation_model.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventHistoryPage extends StatefulWidget {
  const EventHistoryPage({Key? key}) : super(key: key);

  @override
  State<EventHistoryPage> createState() => _EventHistoryPageState();
}

class _EventHistoryPageState extends State<EventHistoryPage> {
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
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                return _buildNormalContainer();
              } else {
                return _buildNormalContainer();
              }
            },
          ));
    });
  }

  Widget _buildNormalContainer() {
    return ListView(
      children: [
        EventQuery(),
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

class Item {
  bool isExpanded = false;
  String itemKey;
  String title;
  // String note;
  // String date;
  // List<dynamic> imgUrls;

  Item(this.itemKey, this.title);
}

class EventQuery extends StatefulWidget {
  @override
  _EventQueryState createState() => _EventQueryState();
}

class _EventQueryState extends State<EventQuery> {
  List<Item> _data = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('eventhistory');

    return FutureBuilder<QuerySnapshot>(
      future: events.orderBy("datetime", descending: true).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        // snapshot.data!.docs.forEach((document) {
        //   print(document.get('title'));
        // });

        _data = snapshot.data!.docs.map((DocumentSnapshot document) {
          return Item(document.id, document.get("title")
              // document.get("note"),
              // document.get("imgUrls"),
              // DateFormat('dd MMM yyyy').format(document.get("date").toDate())
              );
        }).toList();

        return BuildExpansionPanelList(dataItem: _data);
        // return Text("SUCCESS");
      },
    );
  }
}

class BuildExpansionPanelList extends StatefulWidget {
  final List<Item> dataItem;

  const BuildExpansionPanelList({Key? key, required this.dataItem})
      : super(key: key);

  @override
  _BuildExpansionPanelListState createState() =>
      _BuildExpansionPanelListState();
}

class _BuildExpansionPanelListState extends State<BuildExpansionPanelList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          widget.dataItem[panelIndex].isExpanded = !isExpanded;
        });
      },
      children: widget.dataItem.map((Item item) {
        return ExpansionPanel(
            headerBuilder: (context, isExpaned) {
              return ListTile(
                isThreeLine: true,
                title: Text(item.title),
                subtitle: Row(
                  children: [
                    Expanded(
                        child: Text("item.note",
                            maxLines: 2, overflow: TextOverflow.ellipsis)),
                    Text("item.date")
                  ],
                ),
              );
            },
            isExpanded: item.isExpanded,
            body: ListTile(
              isThreeLine: true,
              title: Text("Note:"),
              // leading: item.imgUrls.isEmpty ? null : imageSection(item.imgUrls),
              subtitle: Text("item.note",
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                  icon: Icon(Icons.create),
                  onPressed: () {
                    // Provider.of<RabbitDetailsStore>(context, listen: false)
                    //     .setActivityId(item.itemKey);
                    // Provider.of<RabbitDetailsStore>(context, listen: false)
                    //     .setAddNewActivityTitle(item.title);
                    // Provider.of<RabbitDetailsStore>(context, listen: false)
                    //     .setAddNewActivityNote(item.note);
                    // Provider.of<GpvWrapperStore>(context, listen: false)
                    //     .setNetImage(item.imgUrls);

                    // Navigator.pushNamed(context, "/activityDetailsPage");
                  }),
            ));
      }).toList(),
    );
  }
}
