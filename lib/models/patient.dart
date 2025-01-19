import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Client {
  int? id = 0;
  DateTime? addingDate = DateTime.now();
  String? name = '';
  String? sex;
  String? phone = '';
  String? address = '';
  String? age = '';
  String? notes = '';

  Client({
    required this.id,
    required this.name,
    required this.notes,
    required this.addingDate,
    required this.address,
    required this.age,
    required this.phone,
    required this.sex,
  });

  Client.fromJson(dynamic json) {
    print(json);
    if (json['addingDate'] == null) {
      addingDate = DateTime.now();
    } else {
      addingDate = DateTime.parse(json['addingDate']);
    }
    id = json['id'];
    name = json['name'] ?? '';
    sex = json['sex'] ?? true;

    phone = json['phone'] ?? '';
    address = json['address'] ?? '';
    age = json['age'] ?? '';
    notes = json['notes'] ?? '';
  }
  get toMap {
    Map<String, dynamic> map = {
      'name': name,
      'sex': sex,
      'id': id,
      'phone': phone,
      'address': address,
      'age': age,
      'notes': notes,
      'addingDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(addingDate!),
    };
    return map;
  }

  void updateData({
    required String? name,
    required String? notes,
    required String? address,
    required String? age,
    required String? phone,
    required String? painIntensity,
    required String? refferedFrom,
    required String? sex,
    required String? otherMedicalProblems,
    required String? work,
    required String? diagsDescription,
    required String? socialState,
  }) {
    this.name = name;
    this.address = address;
    this.notes = notes;
    this.age = age;
    this.phone = phone;
    this.sex = sex;
  }
}
