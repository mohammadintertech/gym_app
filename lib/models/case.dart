import 'package:intl/intl.dart';

class Case {
  int? cliID = 0;
  String? title = '';
  String? date = '';
  String? startDate = '';
  String patName = '';
  String? note = '';
  int? id = 0;
  String? price;
  String? duration;
  Case({
    this.date,
    this.note,
    required this.patName,
    this.price,
    this.cliID,
    this.startDate,
    this.title,
    this.duration,
    this.id,
  });

  Case.fromJson(dynamic json) {
    cliID = json['cliID'] ?? 0;
    title = json['title'] ?? '';
    date = json['date'] == null ? '' : getDate(json['date']);
    startDate = json['startDate'] == null ? '' : getDate(json['startDate']);
    note = json['note'] ?? '';
    price = json['price'];
    duration = json['duration'];
    patName = json['name'] ?? '';
    id = json['id'] ?? 0;
  }
  get toMap {
    Map<String, dynamic> map = {
      'title': title,
      'date': date,
      'startDate': startDate,
      'duration': duration,
      'id': id,
      'cliID': cliID,
      'name': patName,
      'note': note,
      'price': price,
    };
    return map;
  }

  String getDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }
}
