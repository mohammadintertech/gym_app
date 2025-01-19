import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_app/models/case.dart';
import 'package:gym_app/models/clinc_case.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/screens/add_patient_screen.dart';
import 'package:gym_app/widgets/grid_view.dart';
import 'package:provider/provider.dart';

class PatCases extends StatefulWidget {
  @override
  _PatCasesState createState() => _PatCasesState();
}

class _PatCasesState extends State<PatCases> {
  TextEditingController noteController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String casesToBeAdded = '';
  final _formKey = GlobalKey<FormState>();
  List<String> clincCases = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    priceController.text = '70';
  }

  Future<bool> getSubscriptions() async {
    await Provider.of<CaseProvider>(context, listen: false)
        .getGymCat(context: context);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Platform.isAndroid || Platform.isIOS;
    var feildStyle = TextStyle(
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<bool>(
        future:
            getSubscriptions(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
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
                                      "إضافة اشتراك",
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
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.grey),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
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
                                CasesGridView(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextFormField(
                                    controller: priceController,
                                    onFieldSubmitted: (val) {
                                      // FocusScope.of(context).requestFocus(focus);
                                    },
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
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(60.0),
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(60.0),
                                        borderSide: BorderSide(),
                                      ),
                                      //fillColor: Colors.green),
                                    ),
                                  ),
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
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(60.0),
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(60.0),
                                        borderSide: BorderSide(),
                                      ),
                                      //fillColor: Colors.green),
                                    ),
                                  ),
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
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ));
          } else {
            return Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Future<void> addCase() async {
    AddClientScreen.diagsController.text = '';
    if (_formKey.currentState!.validate()) {
      List<ClincCase> list =
          Provider.of<CaseProvider>(context, listen: false).clincCases!;
      casesToBeAdded = '';
      for (var i = 0; i < list.length; i++) {
        if (list[i].isSelected!) {
          casesToBeAdded += ',' + list[i].title!;
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
