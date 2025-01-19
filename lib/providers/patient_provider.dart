import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ClientProvider extends ChangeNotifier {
  List<Client> patients = [];
  Client? selectedClient;
  int lastId = 0;
  int betweenMinMax = 10;
  int max = 0;
  int min = 0;

  Future<bool> getClientsByWords(
      {List<String>? words, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;

      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        String query = '';
        List<String> data = ['%${words![0]}%'];
        if (words.length >= 2) {
          for (var i = 1; i < words.length; i++) {
            query += 'AND name LIKE ?';
            data.add('%${words[i]}%');
          }
        }
        List<Map> value = await db.rawQuery('''
       SELECT * FROM Clients  
       WHERE name LIKE ? $query ;
  
        )
        ''', data);
        // debugPrint('word:' + "$word[");
        result = true;
        db.close();
        patients.clear();
        for (var i = 0; i < value.length; i++) {
          patients.insert(0, Client.fromJson(value[i]));
        }

        notifyListeners();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      // Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }

  Future<bool> getClients({BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;

      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        List<Map> value = await db.rawQuery(
          '''
        SELECT * FROM Clients;
        )
        ''',
        );
        result = true;
        db.close();
        min -= betweenMinMax;
        max -= betweenMinMax;
        patients.clear();
        for (var i = 0; i < value.length; i++) {
          patients.insert(0, Client.fromJson(value[i]));
        }
        notifyListeners();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
    // bool result = false;

    // min = max - betweenMinMax;
    // if (min < 0) {
    //   min = 0;
    // }
    // debugPrint(max.toString());
    // debugPrint(min.toString());
    // if (min == 0) {
    //   min = -1;
    // }
    // var ref = await Firestore.instance
    //     .collection('patients')
    //     .where(
    //       'id',
    //       isLessThanOrEqualTo: max,
    //       isGreaterThan: min,
    //     )
    //     .get()
    //     .catchError((e) {
    //   List<Document> d = [];
    //   result = false;
    //   Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //   return d;
    // }).then((value) {
    //   min -= betweenMinMax;
    //   max -= betweenMinMax;
    //   result = true;
    //   for (var i = 0; i < value.length; i++) {
    //     patients.add(Client.fromJson(value[i]));
    //   }
    //   debugPrint(value.toString());
    // }).timeout(Duration(seconds: 4), onTimeout: () {
    //   Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //   result = false;
    // });
    // return result;
  }

  String getDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  Future<bool> deletePat({Client? p, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        await db.rawDelete('DELETE FROM Clients WHERE id = ?', [p!.id]);
        patients.remove(p);
        result = true;
        debugPrint('patinet deleted');
        db.close();

        notifyListeners();
        Navigator.of(context!).pop();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }

  Future<bool> createPat({Client? p, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        List<Map> value = await db.rawQuery('''
        SELECT * FROM ClinetsInfo;
        )
        ''');
        lastId = value[0]['lastId'];
        p!.id = lastId;
        await db.insert('Clients', p.toMap);

        await db.rawUpdate('UPDATE ClinetsInfo SET lastId = ? WHERE lastId = ?',
            [lastId + 1, lastId]);
        result = true;
        db.close();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
    // bool result = false;
    // bool resultLastID = await getLastId(context: context);
    // if (resultLastID) {
    //   p!.id = lastId;
    //   var ref = await Firestore.instance
    //       .collection('patients')
    //       .document(p.id.toString())
    //       .set(p.toMap)
    //       .catchError((e) {
    //     List<Document> d = [];
    //     result = false;
    //     Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //     return d;
    //   }).then((value) async {
    //     patients.insert(0, p);
    //     await updateLastId(context: context);
    //     result = true;
    //   }).timeout(Duration(seconds: 4), onTimeout: () {
    //     Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //     result = false;
    //   });
    //   return result;
    // }
    // return false;
  }

  Future<bool> updatePat(BuildContext context) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        await db.update('Clients', selectedClient!.toMap,
            where: 'id = ?', whereArgs: [selectedClient!.id]);
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

  Future<bool> getLastId({BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        List<Map> value = await db.rawQuery('''
        SELECT * FROM ClinetsInfo;
        )
        ''');
        lastId = value[0]['lastId'];
        result = true;
        db.close();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
    // bool result = false;
    // var ref = await Firestore.instance
    //     .collection('clincInfo')
    //     .document('patientsInfo')
    //     .get()
    //     .catchError((e) {
    //   List<Document> d = [];
    //   result = false;
    //   Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //   return d;
    // }).then((value) {
    //   lastId = value.map['lastId'];
    //   result = true;
    // }).timeout(Duration(seconds: 4), onTimeout: () {
    //   Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //   result = false;
    // });
    // return result;
  }

  // Future<bool> updateLastId({BuildContext? context}) async {
  //   bool result = false;
  //   var ref = await Firestore.instance
  //       .collection('clincInfo')
  //       .document('patientsInfo')
  //       .set({
  //     'lastId': lastId + 1,
  //   }).catchError((e) {
  //     List<Document> d = [];
  //     result = false;
  //     Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
  //     return d;
  //   }).then((value) {
  //     result = true;
  //   }).timeout(Duration(seconds: 4), onTimeout: () {
  //     Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
  //     result = false;
  //   });
  //   return result;
  // }
}
