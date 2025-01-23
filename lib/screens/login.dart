import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/providers/user_provider.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/utils.dart';
import 'package:gym_app/widgets/change_pass_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//0055d4ff main color
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  String selectedUser = 'admin';
  List<String> users = ['admin', 'user'];
  TextEditingController _passwordController = TextEditingController();
  final focus = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue;

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                PopupMenuButton(
                    onSelected: (int value) async {
                      if (value == 0) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return ChangePassDialog();
                          },
                        );
                      } else if (value == 1) {
                        // print('object');
                        // FilePickerResult? result =
                        //     await FilePicker.platform.pickFiles();

                        // print('object1');

                        // if (result != null) {
                        // debugPrint(result.files.single.path!.toString());
                        // String path = result.files.single.path!.toString();
                        // String path =
                        //     'C:/Users/Mohammad/Downloads/Documents/data.db';
                        // final prefs = await SharedPreferences.getInstance();
                        // await prefs.setString('dataPath', "data.db");
                        var databaseFactory = databaseFactoryFfi;

                        var db = await databaseFactory.openDatabase("data.db");
                        print(db.path);
                        await db.execute('''
                        CREATE TABLE Users (
                        Username varchar(255),
                        Password varchar(255)
                        );
                        ''');
                        await db.insert('Users', {
                          'Username': 'admin',
                          'Password': 'admin',
                        });
                        await db.insert('Users', {
                          'Username': 'user',
                          'Password': 'user',
                        });
                        await db.execute('''
                        CREATE TABLE Clients (
                        id int PRIMARY KEY,
                        name varchar(45),
                        addingDate varchar(45),
                        sex varchar(45),
                        phone varchar(45),
                        address varchar(45),
                        age varchar(45),
                        notes varchar(45)
                        );
                        ''');
                        await db.execute('''
                        CREATE TABLE Subscriptions (
                        id int PRIMARY KEY,
                        cliID int,
                        title varchar(45),
                        name varchar(45),
                        startDate varchar(45),
                        date varchar(45),
                        duration varchar(45),
                        note varchar(45),
                        price varchar(45),
                        paid varchar(45)
                        );
                        ''');
                        await db.execute('''
                        CREATE TABLE GymCat (
                        title varchar(45)
                        );
                        ''');
                        await db.insert('GymCat', {'title': 'تايكوندو'});
                        await db.insert('GymCat', {'title': 'Boxing'});
                        await db.insert('GymCat', {'title': 'كاراتيه'});
                        await db.execute('''
                        CREATE TABLE ClinetsInfo (
                        lastId int
                        );
                        ''');
                        await db.insert('ClinetsInfo', {'lastId': 1});
                        await db.execute('''
                        CREATE TABLE SubscriptionsInfo (
                        lastId int
                        );
                        ''');
                        await db.insert('SubscriptionsInfo', {'lastId': 1});
                      }
                      // }
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(
                              'تغيير كلمة السر',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text(
                              'تحديد موقع البيانات',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: 1,
                          ),
                        ]),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 300,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: PopupMenuButton<String>(
                          onSelected: (String value) async {
                            debugPrint(value.toString());
                            selectedUser = value;
                            setState(() {});
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.black,
                                ),
                                Text(
                                  'اسم المستخدم:    ',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  selectedUser,
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => users.map(
                            (user) {
                              var p = PopupMenuItem<String>(
                                child: Text(
                                  user,
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: user,
                              );

                              return p;
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    focusNode: focus,
                    controller: _passwordController,
                    onSubmitted: (val) {
                      setState(() {
                        isLoading = true;
                      });
                      login();
                    },
                    obscureText: true,
                    cursorColor: color,
                    style: const TextStyle(
                        fontFamily: 'Cairo', fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      labelStyle: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.black),
                      labelText: "كلمة المرور",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: BorderSide(color: color),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                        borderRadius: new BorderRadius.circular(100.0),
                        // borderSide: BorderSide(color: color),
                      ),
                      //fillColor: Colors.green),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isLoading == false) {
                        setState(() {
                          isLoading = true;
                        });
                        login();
                      }
                    },
                    child: const Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 15),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String trim(String s) {
    s = s.trim();
    if (s == '') {
      return s;
    } else {
      String temp = '';
      for (var i = 0; i < s.length; i++) {
        if (s[i].codeUnitAt(0) != 32 && s[i].codeUnitAt(0) != 8207) {
          temp += s[i];
          for (var j = i + 1; j < s.length; j++) {
            temp += s[j];
          }
          break;
        }
      }
      String temp2 = '';
      for (var i = temp.length - 1; i >= 0; i--) {
        if (temp[i].codeUnitAt(0) != 32 && temp[i].codeUnitAt(0) != 8207) {
          temp2 += temp[i];
          for (var j = i - 1; j >= 0; j--) {
            temp2 += temp[j];
          }
          break;
        }
      }
      String result = '';
      for (var i = temp2.length - 1; i >= 0; i--) {
        result += temp2[i];
      }

      String finalValue = '';
      for (var i = 0; i < result.length; i++) {
        if (result[i].codeUnitAt(0) != 32 && result[i].codeUnitAt(0) != 8207) {
          finalValue += result[i];
        }
      }
      return finalValue;
    }
  }

  Future<void> login() async {
    bool result = await Provider.of<UserProvider>(context, listen: false)
        .login(selectedUser, trim(_passwordController.text), context);
    if (result) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
