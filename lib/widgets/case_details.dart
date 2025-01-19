import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:gym_app/models/case.dart';
import 'package:gym_app/models/clinc_case.dart';
import 'package:gym_app/models/employee.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/employess_provider.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/screens/add_patient_screen.dart';
import 'package:gym_app/widgets/edit_case_dialog.dart';
import 'package:gym_app/widgets/grid_view.dart';
import 'package:provider/provider.dart';

class CaseDetails extends StatefulWidget {
  Case? c;
  CaseDetails({this.c});

  @override
  _CaseDetailsState createState() => _CaseDetailsState();
}

class _CaseDetailsState extends State<CaseDetails> {
  String selectedEmployee = '';
  TextEditingController noteController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  int eIndex = 0;
  String casesToBeAdded = '';
  final _formKey = GlobalKey<FormState>();
  List<String> clincCases = [];
  Widget? casesGrid;
  double painColorIndex = 0;
  double goodColorIndex = 0;
  List<Color> goodValueColors = [
    Colors.red[800]!,
    Colors.red,
    Colors.orange[800]!,
    Colors.orange,
    Colors.yellow[700]!,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen[400]!,
    Colors.lightGreen,
    Colors.green,
  ];
  List<Color> painValueColors = [
    Colors.green,
    Colors.lightGreen,
    Colors.lightGreen[400]!,
    Colors.lime,
    Colors.yellow,
    Colors.yellow[700]!,
    Colors.orange,
    Colors.orange[800]!,
    Colors.red,
    Colors.red[800]!
  ];
  int painValue = 0;
  int goodValue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceController.text = '100';
    Provider.of<EmployeesProvider>(context, listen: false)
        .getEmployees(context: context);
    casesGrid = CasesGridView();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.c!.toMap.toString());
    bool isMobile = Platform.isAndroid || Platform.isIOS;
    var feildStyle = TextStyle(
      height: 1.5,
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Selector<CaseProvider, List<Case>>(
          selector: (_, provider) => provider.cases!,
          builder: (_, cases, child) {
            return SizedBox(
              child: AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Provider.of<CaseProvider>(context, listen: false)
                                  .deleteCase(c: widget.c, context: context);
                            },
                            child: SizedBox(
                              width: isMobile ? 60 : 100,
                              child: Center(
                                child: Text(
                                  'حذف الاشتراك',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                      fontSize: isMobile ? 11 : 15),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await Provider.of<CaseProvider>(context,
                                      listen: false)
                                  .getGymCat(context: context);
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return EditCaseDialog(c: widget.c!);
                                },
                              );
                            },
                            child: SizedBox(
                              width: isMobile ? 60 : 100,
                              child: Center(
                                child: Text(
                                  'تعديل الاشتراك',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                      fontSize: isMobile ? 11 : 15),
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  content: SizedBox(
                    width: width / 1.5,
                    height: height / 1.5,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'العلاج المستخدم:  ',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                widget.c!.title!,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'التاريخ:  ',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                widget.c!.date!,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    enabled: false,
                                    onFieldSubmitted: (val) {
                                      // FocusScope.of(context).requestFocus(focus);
                                    },
                                    initialValue: widget.c!.price,
                                    validator: (val) {
                                      try {
                                        int s = int.parse(
                                            trim(priceController.text));
                                        return null;
                                      } catch (e) {
                                        return 'القيمة المدخلة غير صحيحة';
                                      }
                                    },
                                    style: feildStyle,
                                    cursorColor: Colors.blue,
                                    decoration: InputDecoration(
                                      labelStyle: feildStyle,
                                      prefixIcon: Icon(
                                        Icons.attach_money,
                                        color: Colors.black,
                                      ),
                                      labelText: "المبلغ",

                                      //fillColor: Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue: widget.c!.note!,
                              onFieldSubmitted: (val) {
                                // FocusScope.of(context).requestFocus(focus);
                              },
                              style: feildStyle,
                              cursorColor: Colors.blue,
                              decoration: new InputDecoration(
                                labelStyle: feildStyle,
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                labelText: "ملاحظات حول الاشتراك",

                                //fillColor: Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ));
  }

  Future<void> addCase() async {
    AddClientScreen.diagsController.text = '';
    if (selectedEmployee == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('قم باختيار معالج أولا')),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (_formKey.currentState!.validate()) {
      List<ClincCase> list =
          Provider.of<CaseProvider>(context, listen: false).clincCases!;
      casesToBeAdded = '';
      bool nothingAdded = true;
      for (var i = 0; i < list.length; i++) {
        if (list[i].isSelected!) {
          casesToBeAdded += ',' + list[i].title!;
          nothingAdded = false;
        }
      }
      if (nothingAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('لم يتم اختيار أي علاج!')),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      Case c = Case(
          date: DateTime.now().toString(),
          patName: Provider.of<ClientProvider>(context, listen: false)
              .selectedClient!
              .name!,
          cliID: Provider.of<ClientProvider>(context, listen: false)
              .selectedClient!
              .id,
          note: noteController.text,
          price: priceController.text,
          title: casesToBeAdded);
      Provider.of<CaseProvider>(context, listen: false)
          .addCaseForPat(c: c, context: context);
    }
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

      return result;
    }
  }
}
