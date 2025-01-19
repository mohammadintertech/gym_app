import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_app/models/employee.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class EmployeesProvider extends ChangeNotifier {
  List<Employee> employees = [];

  Future<bool> getEmployees({BuildContext? context}) async {
    bool result = false;
    return false;
    try {
      // final prefs = await SharedPreferences.getInstance();
      // String path = await prefs.getString('dataPath')!;
      // employees.clear();
      // if (path != null || path != '') {
      //   var databaseFactory = databaseFactoryFfi;
      //   var db = await databaseFactory.openDatabase(path);
      //   List<Map> value = await db.rawQuery('''
      //   SELECT * FROM Employees;
      //   )
      //   ''');
      //   result = true;
      //   db.close();

      //   debugPrint(value.toString());
      //   for (var i = 0; i < value.length; i++) {
      //     employees.add(Employee.fromJson(value[i]));
      //   }
      //   return result;
      // }
      // return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }

  String getDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  Future<bool> createEmp({Employee? e, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        e!.addingDate = getDate(e.addingDate.toString());
        await db.insert('Employees', e.toMap);
        employees.add(e);
        result = true;
        db.close();
        notifyListeners();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }

  Future<bool> deleteEmp({Employee? e, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        e!.addingDate = getDate(e.addingDate.toString());
        await db.rawDelete('DELETE FROM Employees WHERE Name = ?', [e.name]);
        employees.remove(e);
        result = true;
        db.close();
        notifyListeners();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }
}
