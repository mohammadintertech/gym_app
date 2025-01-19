import 'dart:io';
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/case.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/employess_provider.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/providers/user_provider.dart';
import 'package:gym_app/screens/edit_pat_screen.dart';
import 'package:gym_app/widgets/add_employee_dialog.dart';
import 'package:gym_app/widgets/case_details.dart';
import 'package:provider/provider.dart';

class SubsScreen extends StatefulWidget {
  static String routeName = 'subs';
  @override
  _SubsScreenState createState() => _SubsScreenState();
}

class _SubsScreenState extends State<SubsScreen>
    with AutomaticKeepAliveClientMixin {
  Future<bool> getEmps() async {
    await Provider.of<CaseProvider>(context, listen: false).getAllCases(
      context: context,
    );

    return true;
  }

  String getTotalAmount(List<Case> cases) {
    int value = 0;
    for (var i = 0; i < cases.length; i++) {
      value += int.parse(cases[i].price!);
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final tableHeadersStyle =
        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);

    return Scaffold(
      body: FutureBuilder<bool>(
        future: getEmps(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            ' رجوع',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Cairo',
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user!
                                              .username ==
                                          'admin'
                                      ? Text(
                                          '${getTotalAmount(Provider.of<CaseProvider>(context, listen: false).cases!)} ₪',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.blue,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'تاريخ الاشتراك',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'اسم المعالج',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'العلاج المستخدم',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'الرقم',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashLength: 4.0,
                        dashColor: Colors.blue,
                        dashRadius: 0.0,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0,
                      ),
                      Consumer<CaseProvider>(
                        builder: (context, provider, child) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: provider.cases!.length,
                              itemBuilder: (_, index) {
                                debugPrint(index.toString());
                                return Card(
                                  color: Colors.grey[100],
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return CaseDetails(
                                            c: provider.cases![index],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  provider.cases![index].date
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  provider.cases![index].title!,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  '${provider.cases!.length - index}         ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // ClinetsInfoSideContainer(),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
