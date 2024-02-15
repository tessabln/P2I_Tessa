import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post {
  final String message;
  final DateTime date;
  late String formattedDate;

  Post({
    required this.message,
    required this.date,
  })

  {
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    
  }

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      message: data['PostMessage'],
      date: data['TimeStamp'],
    );
  }
}
