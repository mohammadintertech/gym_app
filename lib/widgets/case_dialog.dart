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
import 'package:gym_app/widgets/edit_cases.dart';
import 'package:gym_app/widgets/grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class CaseDialog extends StatefulWidget {
  @override
  _CaseDialogState createState() => _CaseDialogState();
}

class _CaseDialogState extends State<CaseDialog> {
  String selectedEmployee = '';
  int eIndex = 0;
  TextEditingController noteController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String casesToBeAdded = '';
  int goodColorIndex = 0;
  final _formKey = GlobalKey<FormState>();
  List<String> clincCases = [];
  Widget? casesGrid;
  String selectedType = "";
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;
  final intl.DateFormat _dateFormat = intl.DateFormat('yyyy-MM-dd');
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceController.text = '100';
    // Provider.of<EmployeesProvider>(context, listen: false)
    //     .getEmployees(context: context);
    casesGrid = CasesGridView();
  }

  @override
  Widget build(BuildContext context) {
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
            return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            new Text(
                              "إضافة اشتراك إلى  ${Provider.of<ClientProvider>(context, listen: false).selectedClient!.name}",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 13 : 20,
                              ),
                            ),
                            SizedBox(
                              width: isMobile ? 5 : 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await Provider.of<CaseProvider>(context,
                                        listen: false)
                                    .getGymCat(context: context);
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return EditCasesDialog();
                                  },
                                );
                              },
                              child: SizedBox(
                                width: isMobile ? 60 : 100,
                                child: Center(
                                  child: Text(
                                    'تعديل الاقسام',
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlue[200]),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<CaseProvider>(context,
                                        listen: false)
                                    .clearSelctedCases();
                              },
                              child: SizedBox(
                                width: isMobile ? 60 : 100,
                                child: Center(
                                  child: Text(
                                    'مسح الكل',
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlue[200]),
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
                      ],
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
                content: SizedBox(
                  width: width / 1.5,
                  height: height / 2,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // casesGrid!,
                        Row(
                          children: [
                            Text(
                              'تاريخ بدء الاشتراك:',
                              style: feildStyle,
                            ),
                            TextButton(
                              onPressed: () => _selectStartDate(context),
                              child: Text(
                                _startDate == null
                                    ? 'اختر تاريخ'
                                    : '${_dateFormat.format(_startDate!)}',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 30,
                        ),
                        Row(
                          children: [
                            Text(
                              'قسم الاشتراك:',
                              style: feildStyle,
                            ),
                            PopupMenuButton(
                              onSelected: (dynamic value) async {
                                print(value);
                                selectedType = value;
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
                                      selectedType == ""
                                          ? 'اختيار قسم'
                                          : selectedType,
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              itemBuilder: (context) =>
                                  Provider.of<CaseProvider>(context,
                                          listen: false)
                                      .clincCases!
                                      .map<PopupMenuEntry>((e) {
                                return PopupMenuItem(
                                  child: Text(
                                    e.title!,
                                    style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  value: e.title,
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            controller: noteController,
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  priceController.text = '100';
                                },
                                child: Container(
                                  color: Colors.blue,
                                  width: 60,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '100',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cairo',
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  priceController.text = '200';
                                },
                                child: Container(
                                  color: Colors.blue,
                                  width: 60,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '200',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cairo',
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextFormField(
                                  controller: priceController,
                                  onFieldSubmitted: (val) {
                                    // FocusScope.of(context).requestFocus(focus);
                                  },
                                  validator: (val) {
                                    try {
                                      int s =
                                          int.parse(trim(priceController.text));
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
                          height: height / 30,
                        ),
                        SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                addCase();
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'إضافة',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo',
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                // backgroundBuilder: ,
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        ));
  }

  Future<void> addCase() async {
    AddClientScreen.diagsController.text = '';

    if (_formKey.currentState!.validate()) {
      List<ClincCase> list =
          Provider.of<CaseProvider>(context, listen: false).clincCases!;
      casesToBeAdded = '';
      bool nothingAdded = true;
      for (var i = 0; i < list.length; i++) {
        if (list[i].isSelected!) {
          casesToBeAdded += ' / ' + list[i].title!;
          nothingAdded = false;
        }
      }

      Case c = Case(
          date: DateTime.now().toString(),
          cliID: Provider.of<ClientProvider>(context, listen: false)
              .selectedClient!
              .id,
          patName: Provider.of<ClientProvider>(context, listen: false)
              .selectedClient!
              .name!,
          note: noteController.text,
          startDate: _startDate.toString(),
          price: priceController.text,
          title: selectedType);
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
