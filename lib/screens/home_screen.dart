import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/providers/user_provider.dart';
import 'package:gym_app/screens/add_patient_screen.dart';
import 'package:gym_app/screens/emp_screen.dart';
import 'package:gym_app/screens/finScreen.dart';
import 'package:gym_app/screens/search_screen.dart';
import 'package:gym_app/screens/subs_screen.dart';
import 'package:gym_app/utils.dart';
import 'package:intl/intl.dart';
import 'package:gym_app/widgets/timer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _timeString;

  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  String getDate(String pars) {
    DateTime d = DateTime.parse(pars);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    debugPrint(formatter.format(d).toString());
    return formatter.format(d);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue;
    bool isAdmin =
        Provider.of<UserProvider>(context, listen: false).user!.username ==
                'admin'
            ? true
            : false;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppClock(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              'assets/logo.png',
              width: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
//                 ElevatedButton(
//                     onPressed: () async {
//                       // String path =
//                       //     'C:/Users/Mohammad/Downloads/Documents/data.db';
//                       final prefs = await SharedPreferences.getInstance();
//                       var databaseFactory = databaseFactoryFfi;
//                       String path = prefs.getString('dataPath')!;
//                       var db = await databaseFactory.openDatabase(path);

//                       await db.execute('''
// ALTER TABLE Cases
// ADD patName varchar(45);
// ''');
//                       // DROP TABLE Cases;
//                     },
//                     child: Text('run Query')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        stops: [0.0, 1.0],
                        colors: [
                          Colors.blue,
                          Colors.blue[200]!,
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(Size(width, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        'المشتركين',
                        style: AppStyle.mainButtons,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pushNamed(SearchScreen.routeName);
                      },
                    ),
                    width: 250,
                    height: 110,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        stops: [0.0, 1.0],
                        colors: [
                          Colors.blue,
                          Colors.blue[200]!,
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(Size(width, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        'الاشتراكات',
                        style: AppStyle.mainButtons,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pushNamed(SubsScreen.routeName);
                      },
                    ),
                    width: 250,
                    height: 110,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(Size(width, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        'إضافة مشترك',
                        style: AppStyle.mainButtons,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddClientScreen.routeName);
                      },
                    ),
                    width: 250,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                        stops: [0.0, 1.0],
                        colors: [
                          Colors.blue,
                          Colors.blue[200]!,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isAdmin
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                            stops: [0.0, 1.0],
                            colors: [
                              Colors.blue,
                              Colors.blue[200]!,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          child: Center(
                            child: Text(
                              'إحصائيات',
                              style: AppStyle.mainButtons,
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(width, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () async {
                            await Provider.of<CaseProvider>(context,
                                    listen: false)
                                .getBonds(
                                    context: context,
                                    emp: 'الكل',
                                    word:
                                        '${getDate(DateTime.now().toString())}');

                            Navigator.of(context)
                                .pushNamed(FinScreen.routeName);
                          },
                        ),
                        width: 250,
                        height: 110,
                      ),
                    )
                  : Container(),
              isAdmin
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                            stops: [0.0, 1.0],
                            colors: [
                              Colors.blue,
                              Colors.blue[200]!,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(width, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: Center(
                            child: Text(
                              'الموظفين',
                              style: AppStyle.mainButtons,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EmployeesScreen.routeName);
                          },
                        ),
                        width: 250,
                        height: 110,
                      ),
                    )
                  : Container(),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      'خروج',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          // fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    onPressed: () {
                      debugPrint('App Finished!');

                      exit(0);
                    },
                  ),
                  width: 140,
                  height: 60,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> login() async {}
}
