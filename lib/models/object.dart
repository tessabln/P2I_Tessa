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
}
