import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/case.dart';
import 'package:gym_app/models/clinc_case.dart';
import 'package:gym_app/utils.dart';
import 'package:intl/intl.dart';
import 'package:gym_app/models/case.dart';
import 'package:gym_app/models/clinc_case.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CaseProvider extends ChangeNotifier {
  List<Case>? cases = [];
  List<Case>? bonds = [];
  int lastId = 0;
  double totalValue = 0;
  List<ClincCase>? clincCases = [];
  Future<bool> getCases({BuildContext? context, String? patID}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      cases!.clear();
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        List<Map> value = await db.rawQuery('''
        SELECT * FROM Subscriptions WHERE cliID = ?;
        )
        ''', [patID]);
        result = true;
        db.close();

        debugPrint(value.toString());
        for (var i = 0; i < value.length; i++) {
          cases!.insert(0, Case.fromJson(value[i]));
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
  }

  Future<bool> getAllCases({BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      cases!.clear();
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        List<Map> value = await db.rawQuery(
          '''
        SELECT * FROM Subscriptions;
        )
        ''',
        );
        result = true;
        db.close();

        debugPrint(value.toString());
        for (var i = 0; i < value.length; i++) {
          cases!.insert(0, Case.fromJson(value[i]));
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
  }

  Future<bool> addCaseForPat({Case? c, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      debugPrint('sssssssssssssssss');
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);
        List<Map> value = await db.rawQuery('''
        SELECT * FROM SubscriptionsInfo;
        )
        ''');
        lastId = value[0]['lastId'];
        c!.id = lastId;
        await db.insert('Subscriptions', c.toMap);
        debugPrint(c.toMap.toString());
        await db.rawUpdate(
            'UPDATE SubscriptionsInfo SET lastId = ? WHERE lastId = ?',
            [lastId + 1, lastId]);
        result = true;
        debugPrint('case added');
        db.close();
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

  Future<bool> editCaseForPat({Case? c, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      debugPrint('sssssssssssssssss');
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        await db.update('Cases', c!.toMap, where: 'id = ?', whereArgs: [c.id]);
        result = true;
        debugPrint('case edited');
        db.close();
        Navigator.of(context!).pop();

        Navigator.of(context).pop();
        getCases(patID: c.cliID.toString(), context: context);
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }

  Future<bool> deleteCase({Case? c, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        await db.rawDelete('DELETE FROM GymCat WHERE id = ?', [c!.id]);
        cases!.remove(c);
        result = true;
        debugPrint('case deleted');
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

  Future<bool> deleteClincCase({ClincCase? c, BuildContext? context}) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        await db.rawDelete('DELETE FROM GymCat WHERE title = ?', [c!.title]);
        clincCases!.remove(c);

        // for (var i = 0; i < clincCases!.length; i++) {
        //   clincCases![i].range = i;
        //   await db.rawUpdate('UPDATE GymCat SET range = ? WHERE title = ?',
        //       [clincCases![i].range, clincCases![i].title]);
        // }

        result = true;

        debugPrint('clinc case deleted');
        db.close();

        notifyListeners();
        // Navigator.of(context!).pop();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
  }

  Future<bool> getGymCat({BuildContext? context}) async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    String path = await prefs.getString('dataPath')!;

    if (path != null || path != '') {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(path);
      List<Map> value = await db.rawQuery('''
        SELECT * FROM GymCat;
        )
        ''');
      clincCases!.clear();

      for (var i = 0; i < value.length; i++) {
        clincCases!.insert(0,
            ClincCase(title: value[i]['title'], isSelected: false, range: 0));
      }
      print(clincCases);

      notifyListeners();
      db.close();
      result = true;
    }
    return result;
  }

  Future<bool> changeCase(
      {int? index, bool? isUp, BuildContext? context}) async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    String path = await prefs.getString('dataPath')!;

    if (path != null || path != '') {
      debugPrint(index.toString());
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(path);

      int newRange = 0;

      if (index == 0 && isUp!) {
        debugPrint('aaa');
        return false;
      }
      if ((index == clincCases!.length - 1) && !isUp!) {
        debugPrint('aafffa');
        return false;
      }
      if (isUp!) {
        debugPrint('hhh');
        newRange = clincCases![index!].range!;
        clincCases![index].range = clincCases![index - 1].range;
        clincCases![index - 1].range = newRange;
        await db.rawUpdate('UPDATE GymCat SET range = ? WHERE title = ?',
            [clincCases![index].range, clincCases![index].title]);

        await db.rawUpdate('UPDATE GymCat SET range = ? WHERE title = ?',
            [clincCases![index - 1].range, clincCases![index - 1].title]);
      }
      if (!isUp) {
        debugPrint('kkkk');
        newRange = clincCases![index!].range!;
        clincCases![index].range = clincCases![index + 1].range;
        clincCases![index + 1].range = newRange;
        await db.rawUpdate('UPDATE GymCat SET range = ? WHERE title = ?',
            [clincCases![index].range, clincCases![index].title]);

        await db.rawUpdate('UPDATE GymCat SET range = ? WHERE title = ?',
            [clincCases![index + 1].range, clincCases![index + 1].title]);
      }

      await getGymCat(context: context);
      db.close();
      result = true;
    }
    return result;
  }

  Future<bool> addClincCase(String title) async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    String path = await prefs.getString('dataPath')!;

    if (path != null || path != '') {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(path);

      await db.insert('GymCat', {
        'title': title,
      });
      clincCases!
          .insert(0, ClincCase(title: title, range: 0, isSelected: false));

      notifyListeners();
      db.close();
      result = true;
    }
    return result;
  }

  void clearSelctedCases() {
    for (var i = 0; i < clincCases!.length; i++) {
      clincCases![i].isSelected = false;
    }
    debugPrint('cleared');
    notifyListeners();
  }

  Future<bool> getBonds(
      {BuildContext? context, required String emp, String? word}) async {
    bool result = false;
    final prefs = await SharedPreferences.getInstance();
    String path = await prefs.getString('dataPath')!;

    if (path != null || path != '') {
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(path);
      List<Map> value = [];
      // if (emp == 'الكل') {
      //   value = await db.rawQuery('''
      //  SELECT * FROM GymCat
      //  WHERE date LIKE ? ;

      //   )
      //   ''', ['%$word%']);
      // } else {
      //   value = await db.rawQuery('''
      //  SELECT * FROM GymCat
      //  WHERE date LIKE ? AND empName = ?;

      //   )
      //   ''', ['%$word%', emp]);
      // }
      value = await db.rawQuery('''
       SELECT * FROM GymCat;
  
        )
        ''');

      debugPrint('word:' + "$word");
      bonds!.clear();
      totalValue = 0;
      for (var i = 0; i < value.length; i++) {
        bonds!.insert(0, Case.fromJson(value[i]));
        totalValue = totalValue + double.parse(value[i]['price']);
        // debugPrint(totalValue.toString());
      }
// //

//       for (var i = 0; i < bonds!.length; i++) {
//         List<Map> value = await db.rawQuery('''
//         SELECT * FROM Clients
//         WHERE id = ?;
//         )
//         ''', [bonds![i].patID]);
//         String patname = value[0]['name'];
//         bonds![i].patName = patname;
//         await db.update('Cases', bonds![i].toMap,
//             where: 'id = ?', whereArgs: [bonds![i].id]);
//       }

// //

      debugPrint(value.toString());
      db.close();
      notifyListeners();
      result = true;
    }
    return result;
  }

  String getDate(String pars) {
    DateTime d = DateTime.parse(pars);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    debugPrint(formatter.format(d).toString());
    return formatter.format(d);
  }
}
