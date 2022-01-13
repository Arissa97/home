import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kehof/models/navigation_model.dart';
import 'package:kehof/stores/main_stores.dart';
import 'package:kehof/stores/user_stores.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _eventtitle = TextEditingController();
  final _eventdate = TextEditingController();
  final _eventtime = TextEditingController();
  final _eventcapacity = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 17, minute: 00);

  @override
  void initState() {
    super.initState();
    _eventdate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    String _hour = selectedTime.hour.toString();
    String _minute = selectedTime.minute.toString();
    String _time = _hour + ' : ' + _minute;
    _eventtime.text = _time;
  }

  @override
  void dispose() {
    _eventtitle.dispose();
    _eventdate.dispose();
    _eventtime.dispose();
    _eventcapacity.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _eventdate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;

      String _hour = selectedTime.hour.toString();
      String _minute = selectedTime.minute.toString();
      String _time = _hour + ' : ' + _minute;
      _eventtime.text = _time;
      // _timeController.text = formatDate(
      //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
      //     [hh, ':', nn, " ", am]).toString();
    }
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
    final _costperheadController = TextEditingController();

    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: const Text("Create Event")),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Card(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      // onChanged: (value) => _eventdate.text =
                      //     DateFormat('dd-MM-yyyy').format(selectedDate),
                      autofocus: true,
                      controller: _eventtitle,
                      decoration: const InputDecoration(
                        labelText: "Event Title",
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      onChanged: (value) => _eventdate.text =
                          DateFormat('dd-MM-yyyy').format(selectedDate),
                      controller: _eventdate,
                      decoration: InputDecoration(
                          labelText: "Event Date",
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.event),
                              onPressed: () => _selectDate(context))),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      onChanged: (value) {
                        String _hour = selectedTime.hour.toString();
                        String _minute = selectedTime.minute.toString();
                        String _time = _hour + ' : ' + _minute;
                        _eventtime.text = _time;
                      },
                      controller: _eventtime,
                      decoration: InputDecoration(
                          labelText: "Event Time",
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () => _selectTime(context))),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      // onChanged: (value) => _eventdate.text =
                      //     DateFormat('dd-MM-yyyy').format(selectedDate),
                      controller: _eventcapacity,
                      decoration: const InputDecoration(
                        labelText: "Event Capacity",
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: TextField(
                      controller: _costperheadController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+\.\d{1,2})$|^(\d+\.{0,1})$'))
                      ],
                      decoration: const InputDecoration(
                        labelText: "Insert Cost per head for non-member",
                        prefixText: "RM ",
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      CollectionReference kehofevent = FirebaseFirestore
                          .instance
                          .collection('public')
                          .withConverter<KehofEvent>(
                            fromFirestore: (snapshot, _) =>
                                KehofEvent.fromJson(snapshot.data()!),
                            toFirestore: (evt, _) => evt.toJson(),
                          );

                      String _id = kehofevent.doc().id;

                      kehofevent
                          .doc('activeevent')
                          .set(
                            KehofEvent(
                                id: _id,
                                title: _eventtitle.text,
                                datetime: DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute),
                                capacity: int.parse(_eventcapacity.text),
                                open: false,
                                costperhead:
                                    double.parse(_costperheadController.text)),
                          )
                          .then((value) => print("User Added"))
                          .catchError(
                              (error) => print("Failed to add user: $error"));

                      Navigator.popUntil(
                          context, ModalRoute.withName('/admin'));
                    },
                    child: const Text('Create'),
                  ),
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
