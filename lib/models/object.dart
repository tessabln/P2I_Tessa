import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Object {
  late String name;
  late String description;
  late DateTime begindate;
  late DateTime endate;
  late String formattedBeginDate;
  late String formattedEndDate;

  Object({
    required this.name,
    required this.description,
    required this.begindate,
    required this.endate,
  }) {
    formattedBeginDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(begindate);
    formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endate);
  }

  Object.fromFirestore(Map<String, dynamic> data) {
    name = data['name'] ?? 'Nom non défini';
    description = data['description'] ?? 'Description non définie';
    Timestamp? timestamp = data['begindate'];
    begindate = timestamp?.toDate() ?? DateTime.now();
    Timestamp? timestamp2 = data['endate'];
    endate = timestamp2?.toDate() ?? DateTime.now();
    formattedBeginDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(begindate);
    formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endate);
  }
}
