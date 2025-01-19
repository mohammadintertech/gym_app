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
import 'package:provider/provider.dart';

class EditCaseDialog extends StatefulWidget {
  Case c;
  EditCaseDialog({required this.c});
  @override
  _EditCaseDialogState createState() => _EditCaseDialogState();
}

class _EditCaseDialogState extends State<EditCaseDialog> {
  String selectedEmployee = '';
  int eIndex = 0;
  TextEditingController noteController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController therapyController = TextEditingController();
  String casesToBeAdded = '';
  int goodColorIndex = 0;
  final _formKey = GlobalKey<FormState>();
  List<String> clincCases = [];
  Widget? casesGrid;
  int painColorIndex = 0;
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
    therapyController.text = widget.c.title!;
    noteController.text = widget.c.note!;
    priceController.text = widget.c.price!;
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
                              "تعديل اشتراك  ${Provider.of<ClientProvider>(context, listen: false).selectedClient!.name}",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 13 : 20,
                              ),
                            ),
                            SizedBox(
                              width: isMobile ? 5 : 10,
                            ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     await Provider.of<CaseProvider>(context,
                            //             listen: false)
                            //         .getSubscriptions(context: context);
                            //     showDialog(
                            //       context: context,
                            //       builder: (_) {
                            //         return EditCasesDialog();
                            //       },
                            //     );
                            //   },
                            //   child: SizedBox(
                            //     width: isMobile ? 60 : 100,
                            //     child: Center(
                            //       child: Text(
                            //         'تعديل الاشتراكات',
                            //         style: TextStyle(
                            //             color: Colors.black,
                            //             fontWeight: FontWeight.bold,
                            //             fontFamily: 'Cairo',
                            //             fontSize: isMobile ? 11 : 15),
                            //       ),
                            //     ),
                            //   ),
                            //   style: ButtonStyle(
                            //     elevation: MaterialStateProperty.all<double>(0),
                            //     backgroundColor: MaterialStateProperty.all(
                            //         Colors.lightBlue[200]),
                            //     shape: MaterialStateProperty.all<
                            //         RoundedRectangleBorder>(
                            //       RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(50.0),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
                  height: height / 1.5,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        casesGrid!,
                        Row(
                          children: [
                            Text(
                              'شدة الألم:     ',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  width: 600,
                                  height: 25,
                                  child: FAProgressBar(
                                    currentValue: painValue as double,
                                    progressColor:
                                        painValueColors[painColorIndex],
                                  ),
                                ),
                                SizedBox(
                                  width: 600,
                                  height: 25,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 100;
                                          painColorIndex = 9;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '100%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 90;

                                          painColorIndex = 8;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '90%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 80;

                                          painColorIndex = 7;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '80%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 70;

                                          painColorIndex = 6;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '70%',
                                            style: TextStyle(
                                                // color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                fontFamily: 'Cairo'),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 60;

                                          painColorIndex = 5;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '60%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 50;

                                          painColorIndex = 4;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '50%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 40;

                                          painColorIndex = 3;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '40%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 30;

                                          painColorIndex = 2;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '30%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 20;

                                          painColorIndex = 1;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '20%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          painValue = 10;

                                          painColorIndex = 0;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Text(
                                            '10%',
                                            style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo', fontSize: 12,
                                            ),
                                          )),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'نسبة التحسن:',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  width: 600,
                                  height: 25,
                                  child: FAProgressBar(
                                    currentValue: goodValue as double,
                                    progressColor:
                                        goodValueColors[goodColorIndex],
                                  ),
                                ),
                                SizedBox(
                                  width: 600,
                                  height: 25,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 100;
                                          goodColorIndex = 9;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Text(
                                                '100%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 90;

                                          goodColorIndex = 8;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Text(
                                                '90%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 80;

                                          goodColorIndex = 7;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '80%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 70;

                                          goodColorIndex = 6;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '70%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 60;

                                          goodColorIndex = 5;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '60%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 50;

                                          goodColorIndex = 4;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '50%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 40;

                                          goodColorIndex = 3;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '40%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 30;

                                          goodColorIndex = 2;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '30%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 20;

                                          goodColorIndex = 1;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '20%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          goodValue = 10;

                                          goodColorIndex = 0;
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Center(
                                              child: Column(
                                            children: [
                                              Text(
                                                '10%',
                                                style: TextStyle(
                                                  // color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 3.0),
                        //   child: TextFormField(
                        //     controller: therapyController,
                        //     onFieldSubmitted: (val) {
                        //       // FocusScope.of(context).requestFocus(focus);
                        //     },
                        //     style: feildStyle,
                        //     cursorColor: Colors.blue,
                        //     decoration: new InputDecoration(
                        //       labelStyle: feildStyle,
                        //       prefixIcon: Icon(
                        //         Icons.account_circle,
                        //         color: Colors.black,
                        //       ),
                        //       labelText: "العلاج المستخدم",

                        //       //fillColor: Colors.green),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
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
                            SizedBox(
                              width: 200,
                              child: PopupMenuButton(
                                onSelected: (int value) async {
                                  debugPrint(value.toString());
                                  if (value >=
                                      Provider.of<EmployeesProvider>(context,
                                              listen: false)
                                          .employees
                                          .length) {
                                    value = value %
                                        Provider.of<EmployeesProvider>(context,
                                                listen: false)
                                            .employees
                                            .length;
                                    setState(() {
                                      selectedEmployee =
                                          Provider.of<EmployeesProvider>(
                                                  context,
                                                  listen: false)
                                              .employees[value]
                                              .name!;
                                      debugPrint(selectedEmployee);
                                    });
                                  } else {
                                    setState(() {
                                      selectedEmployee =
                                          Provider.of<EmployeesProvider>(
                                                  context,
                                                  listen: false)
                                              .employees[value]
                                              .name!;
                                      debugPrint(selectedEmployee);
                                    });
                                  }
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'اسم المعالج:    ',
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Colors.blue,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        selectedEmployee,
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                itemBuilder: (context) =>
                                    Provider.of<EmployeesProvider>(context,
                                            listen: false)
                                        .employees
                                        .map(
                                  (e) {
                                    var p = PopupMenuItem(
                                      child: Text(
                                        e.name!,
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: eIndex,
                                    );
                                    eIndex++;

                                    return p;
                                  },
                                ).toList(),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 500,
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
                                    'تعديل',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo',
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
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
    if (selectedEmployee == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('قم باختيار معالج أولا')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
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
          id: widget.c.id,
          date: widget.c.date,
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
          .editCaseForPat(c: c, context: context);
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
