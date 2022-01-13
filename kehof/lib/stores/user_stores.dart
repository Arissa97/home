import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserStore extends ChangeNotifier {
  bool _yesMemberBtn = false;
  bool _noMemberBtn = false;
  bool _yesDependentBtn = false;
  bool _noDependentBtn = false;
  bool _searchmemberfound = false;
  // int _numDependent = 0;
  String _memberPhone = "";
  String _vaccineURL = "";
  Uint8List _vaccineBlob = Uint8List(0);
  String _popURL = "";
  Uint8List _popBlob = Uint8List(0);
  // late XFile _vaccineProfile = XFile.fromData(Uint8List(0));

  KehofEvent _kehofEvent = KehofEvent(
      id: "",
      title: "",
      datetime: DateTime.now(),
      capacity: 0,
      open: false,
      costperhead: 0.0);

  KehofEventHistory _kehofEventHistory = KehofEventHistory(
    finished: false,
    title: "",
    datetime: DateTime.now(),
    capacity: 0,
    canceled: false,
    costperhead: 0.0,
    totalparticipants: 0,
    totalmembers: 0,
    totalnonmembers: 0,
    pendingactions: true,
    currentcollection: 0,
  );

  KehofMember _kehofmember = KehofMember(
    name: "",
    id: "",
    active: false,
    quota: 0,
    yob: 0,
  );

  KehofParticipant _kehofparticipant = KehofParticipant(
    name: "",
    active: false,
    attend: false,
    yob: 0,
    dependent: 0,
  );

  bool yesMemberBtnState() => _yesMemberBtn;

  setYesMemberBtnState(bool isYes) {
    _yesMemberBtn = isYes;
    _noMemberBtn = !isYes;
    notifyListeners();
  }

  bool noMemberBtnState() => _noMemberBtn;

  setNoMemberBtnState(bool isYes) {
    _noMemberBtn = isYes;
    _yesMemberBtn = !isYes;
    notifyListeners();
  }

  bool yesDependentBtnState() => _yesDependentBtn;

  setYesDependentBtnState(bool isYes) {
    _yesDependentBtn = isYes;
    _noDependentBtn = !isYes;
    notifyListeners();
  }

  initYesDependentBtnState(bool isYes) {
    _yesDependentBtn = isYes;
    _noDependentBtn = !isYes;
  }

  bool noDependentBtnState() => _noDependentBtn;

  setNoDependentBtnState(bool isYes) {
    _noDependentBtn = isYes;
    _yesDependentBtn = !isYes;
    _kehofparticipant.dependent = 0;
    notifyListeners();
  }

  bool getSearchMemberFound() => _searchmemberfound;

  setSearchMemberFound(bool isYes) {
    _searchmemberfound = isYes;
    notifyListeners();
  }

  int getNumDependent() => _kehofparticipant.dependent;

  setNumDependent(int data) {
    _kehofparticipant.dependent = data;
    // notifyListeners();
  }

  KehofEvent getKehofEvent() => _kehofEvent;

  setKehofEvent(KehofEvent data) {
    _kehofEvent = data;
    // notifyListeners();
  }

  setKehofEventFactory(Map<String, dynamic> data) {
    _kehofEvent = KehofEvent.fromJsonFactory(data);
    notifyListeners();
  }

  KehofEventHistory getKehofEventHistory() => _kehofEventHistory;

  setKehofEventHistory(KehofEventHistory data) {
    _kehofEventHistory = data;
    // notifyListeners();
  }

  setKehofEventHistoryFactory(Map<String, dynamic> data) {
    _kehofEventHistory = KehofEventHistory.fromJsonFactory(data);
    notifyListeners();
  }

  KehofMember getKehofMember() => _kehofmember;

  setKehofMemberFactory(Map<String, dynamic> data) {
    _kehofmember = KehofMember.fromJsonFactory(data);
    notifyListeners();
  }

  KehofParticipant getKehofParticipant() => _kehofparticipant;

  setKehofParticipant(KehofParticipant data) {
    _kehofparticipant = data;
    // notifyListeners();
  }

  setKehofParticipantFactory(Map<String, dynamic> data) {
    _kehofparticipant = KehofParticipant.fromJsonFactory(data);
    notifyListeners();
  }

  String getMemberPhone() => _memberPhone;

  setMemberPhone(String data) {
    _memberPhone = data;
    notifyListeners();
  }

  String getVaccineURL() => _vaccineURL;

  setVaccineURL(String data) {
    _vaccineURL = data;
    notifyListeners();
  }

  Uint8List getVaccineBlob() => _vaccineBlob;

  setVaccineBlob(XFile data) async {
    _vaccineBlob = await data.readAsBytes();
    notifyListeners();
  }

  String getPopURL() => _popURL;

  setPopURL(String data) {
    _popURL = data;
    notifyListeners();
  }

  Uint8List getPopBlob() => _popBlob;

  setPopBlob(XFile data) async {
    _popBlob = await data.readAsBytes();
    notifyListeners();
  }
}

class KehofEvent {
  KehofEvent({
    required this.id,
    required this.title,
    required this.datetime,
    required this.capacity,
    required this.open,
    required this.costperhead,
  });

  KehofEvent.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          title: json['title']! as String,
          datetime: (json['datetime']! as Timestamp).toDate(),
          capacity: json['capacity']! as int,
          open: json['open']! as bool,
          costperhead: json['costperhead']! as double,
        );

  final String id;
  final String title;
  final DateTime datetime;
  final int capacity;
  final bool open;
  final double costperhead;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'datetime': datetime,
      'capacity': capacity,
      'open': open,
      'costperhead': costperhead,
    };
  }

  factory KehofEvent.fromJsonFactory(Map<String, dynamic> json) {
    return KehofEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      datetime: json['datetime'] as DateTime,
      capacity: json['capacity'] as int,
      open: json['open'] as bool,
      costperhead: json['costperhead'] as double,
    );
  }
}

class KehofEventHistory {
  KehofEventHistory({
    required this.finished,
    required this.title,
    required this.datetime,
    required this.capacity,
    required this.canceled,
    required this.costperhead,
    required this.totalparticipants,
    required this.totalmembers,
    required this.totalnonmembers,
    required this.pendingactions,
    required this.currentcollection,
  });

  KehofEventHistory.fromJson(Map<String, Object?> json)
      : this(
          finished: json['finished']! as bool,
          title: json['title']! as String,
          datetime: (json['datetime']! as Timestamp).toDate(),
          capacity: json['capacity']! as int,
          canceled: json['canceled']! as bool,
          costperhead: json['costperhead']! as double,
          totalparticipants: json['totalparticipants']! as int,
          totalmembers: json['totalmembers']! as int,
          totalnonmembers: json['totalnonmembers']! as int,
          pendingactions: json['pendingactions']! as bool,
          currentcollection: json['currentcollection']! as double,
        );

  bool finished;
  String title;
  DateTime datetime;
  int capacity;
  bool canceled;
  double costperhead;
  int totalparticipants;
  int totalmembers;
  int totalnonmembers;
  bool pendingactions;
  double currentcollection;

  Map<String, Object?> toJson() {
    return {
      'finished': finished,
      'title': title,
      'datetime': datetime,
      'capacity': capacity,
      'canceled': canceled,
      'costperhead': costperhead,
      'totalparticipants': totalparticipants,
      'totalmembers': totalmembers,
      'totalnonmembers': totalnonmembers,
      'pendingactions': pendingactions,
      'currentcollection': currentcollection,
    };
  }

  factory KehofEventHistory.fromJsonFactory(Map<String, dynamic> json) {
    return KehofEventHistory(
      finished: json['finished'] as bool,
      title: json['title'] as String,
      datetime: json['datetime'] as DateTime,
      capacity: json['capacity'] as int,
      canceled: json['canceled'] as bool,
      costperhead: json['costperhead'] as double,
      totalparticipants: json['totalparticipants']! as int,
      totalmembers: json['totalmembers']! as int,
      totalnonmembers: json['totalnonmembers']! as int,
      pendingactions: json['pendingactions']! as bool,
      currentcollection: json['currentcollection']! as double,
    );
  }
}

class KehofMember {
  KehofMember(
      {required this.name,
      required this.id,
      required this.active,
      required this.quota,
      required this.yob});

  KehofMember.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          id: json['id']! as String,
          active: json['active']! as bool,
          quota: json['quota']! as int,
          yob: json['yob']! as int,
        );

  final String name;
  final String id;
  final bool active;
  final int quota;
  int yob;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'id': id,
      'active': active,
      'quota': quota,
      'yob': yob,
    };
  }

  factory KehofMember.fromJsonFactory(Map<String, dynamic> json) {
    return KehofMember(
      name: json['name'] as String,
      id: json['id'] as String,
      active: json['active'] as bool,
      quota: json['quota'] as int,
      yob: json['yob'] as int,
    );
  }
}

class KehofParticipant {
  KehofParticipant({
    required this.name,
    required this.active,
    required this.yob,
    required this.attend,
    required this.dependent,
  });

  KehofParticipant.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          active: json['active']! as bool,
          yob: json['yob']! as int,
          attend: json['attend']! as bool,
          dependent: json['dependent']! as int,
        );

  String name;
  bool active;
  int yob;
  bool attend;
  int dependent;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'active': active,
      'yob': yob,
      'attend': attend,
      'dependent': dependent,
    };
  }

  factory KehofParticipant.fromJsonFactory(Map<String, dynamic> json) {
    return KehofParticipant(
      name: json['name'] as String,
      active: json['active'] as bool,
      yob: json['yob'] as int,
      attend: json['attend'] as bool,
      dependent: json['dependent']! as int,
    );
  }
}
