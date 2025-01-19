import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/employess_provider.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/providers/user_provider.dart';
import 'package:gym_app/screens/add_patient_screen.dart';
import 'package:gym_app/screens/cases_screen.dart';
import 'package:gym_app/screens/edit_pat_screen.dart';
import 'package:gym_app/screens/emp_screen.dart';
import 'package:gym_app/screens/finScreen.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/login.dart';
import 'package:gym_app/screens/search_screen.dart';
import 'package:gym_app/screens/subs_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // String path = 'C:/Users/Mohammad/Downloads/Documents/demo.db';
  sqfliteFfiInit();

  // var databaseFactory = databaseFactoryFfi;
  // var db = await databaseFactory.openDatabase(path);

  // Firestore.initialize(projectId); // Firestore reuses the auth client
  runApp(const MyApp());
}

const projectId = 'al-hakeem';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CaseProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => EmployeesProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LoginScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          AddClientScreen.routeName: (context) => AddClientScreen(),
          SearchScreen.routeName: (context) => SearchScreen(),
          FinScreen.routeName: (context) => FinScreen(),
          EditClientScreen.routeName: (context) => EditClientScreen(),
          EmployeesScreen.routeName: (context) => EmployeesScreen(),
          CasesScreen.routeName: (context) => CasesScreen(),
          SubsScreen.routeName: (context) => SubsScreen(),
        },
      ),
    );
  }
}
