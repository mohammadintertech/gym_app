import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/user.dart';
import 'package:gym_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UserProvider extends ChangeNotifier {
  User? user;

  Future<bool> login(String username, String pass, BuildContext context) async {
    bool result = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        List<Map> value = await db.rawQuery('''
        SELECT * FROM Users
        WHERE Username="$username";
        )
        ''');
        print(value);
        if (value[0]['Password'] == pass) {
          result = true;
          user = User(username: username, password: pass);
        } else {
          Helpers.showErrorMessage(
              msg: 'كلمة المرور غير صحيحة', context: context);
          result = false;
        }
        db.close();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(msg: 'حدث خطأ ما', context: context);
      return false;
    }
    // var ref = await Firestore.instance
    //     .collection('users')
    //     .where('username', isEqualTo: 'admin')
    //     .get()
    //     .catchError((e) {
    //   List<Document> d = [];
    //   result = false;
    //   Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //   return d;
    // }).then((value) {
    //   if (value.isNotEmpty) {
    //     if (value[0]['password'] == pass) {
    //       result = true;
    //     } else {
    //       Helpers.showErrorMessage(
    //           msg: 'كلمة المرور غير صحيحة', context: context);
    //       result = false;
    //     }
    //   } else {
    //     result = false;
    //   }
    // }).timeout(Duration(seconds: 4), onTimeout: () {
    //   Helpers.showErrorMessage(msg: 'تحقق من الانترنت', context: context);
    //   result = false;
    // });
  }

  Future<bool> changePass(String username, String oldPass, String pass,
      BuildContext context) async {
    bool result = false;
    try {
      debugPrint(username);
      final prefs = await SharedPreferences.getInstance();
      String path = await prefs.getString('dataPath')!;
      if (path != null || path != '') {
        var databaseFactory = databaseFactoryFfi;
        var db = await databaseFactory.openDatabase(path);

        int count = await db.rawUpdate(
            'UPDATE Users SET Password = ? WHERE Username = ? AND Password = ?',
            [pass, username, oldPass]);
        if (count > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('تم تعديل كلمة المرور')),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          Helpers.showErrorMessage(
              msg: 'يبدو أن اسم المستخدم أو كلمة المرور غير صحيح',
              context: context);
        }
        debugPrint(count.toString());
        db.close();
        return result;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      Helpers.showErrorMessage(
          msg: 'يبدو أن اسم المستخدم غير صحيح', context: context);
      return false;
    }
  }
}
