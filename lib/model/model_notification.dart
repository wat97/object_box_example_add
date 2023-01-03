import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class ModelNotification {
  @Id()
  int id;
  String title;
  String detail;
  DateTime date;
  ModelNotification({
    this.id = 0,
    required this.title,
    required this.detail,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['date'] = this.date.toIso8601String();

    return data;
  }
}
