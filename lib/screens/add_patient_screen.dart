import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/utils.dart';
import 'package:gym_app/widgets/case_dialog.dart';
import 'package:provider/provider.dart';

class AddClientScreen extends StatefulWidget {
  static TextEditingController diagsController = TextEditingController();
  static String routeName = 'add_patient';
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  int painValue = 10;
  List<String> diags = [];
  String selectedWork = 'لا شيء';
  String selectedDoctor = '';

  int painColorIndex = 0;
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

  List<String> tests = [];
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  // TextEditingController cityController = TextEditingController(text: 'الخليل');

  TextEditingController workController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController otherMedicalProblemsController =
      TextEditingController();
  TextEditingController diagsDescriptionController = TextEditingController();
  TextEditingController refferController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool male = true;

  bool female = false;

  bool azab = true;
  bool marrid = false;
  bool motalaq = false;

  final focusName = FocusNode();
  final focusWork = FocusNode();
  final focusId = FocusNode();
  final focusPain = FocusNode();
  final focusPhone = FocusNode();
  final focusOther = FocusNode();
  final focusAdress = FocusNode();
  final focusDiagsDescription = FocusNode();
  final focusCity = FocusNode();
  final focusAge = FocusNode();
  final focusRefferFrom = FocusNode();
  final focusDiag = FocusNode();
  final focusRays = FocusNode();
  final focusNotes = FocusNode();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final color = Colors.blue;
    var feildStyle = TextStyle(
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: 16,
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.backgroundColor,
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            'إضافة مشترك',
            style: TextStyle(
                color: Colors.blue,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'رجوع',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                fontSize: 15),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
        body: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      // color: Colors.black,
                      padding: EdgeInsets.all(15),
                      width: width - width / 1.8,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.assignment_ind_rounded,
                          //   size: isMobile ? 80 : 120,
                          //   color: Colors.blue,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              controller: nameController,
                              focusNode: focusName,
                              style: feildStyle,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusAge);
                              },
                              validator: (val) {
                                if (trim(val!).length < 5) {
                                  return 'الاسم قصير جدا';
                                } else {
                                  return null;
                                }
                              },
                              cursorColor: color,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                labelText: "إسم المشترك",
                                labelStyle: feildStyle,

                                //fillColor: Colors.green),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'الجنس:',
                                style: feildStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7.0),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: male,
                                            onChanged: (val) {
                                              setState(() {
                                                male = val!;
                                                female = !val;
                                              });
                                            }),
                                        Text(
                                          'ذكر',
                                          style: feildStyle,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: female,
                                            onChanged: (val) {
                                              setState(() {
                                                female = val!;
                                                male = !val;
                                              });
                                            }),
                                        Text(
                                          'أنثى',
                                          style: feildStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              controller: ageController,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusWork);
                              },
                              validator: (val) {
                                if (val == '') {
                                  return null;
                                }
                                try {
                                  int id = int.parse(trim(val!));

                                  return null;
                                } catch (e) {
                                  return 'القيمة المدخلة ليست عمراَ';
                                }
                              },
                              style: feildStyle,
                              cursorColor: color,
                              focusNode: focusAge,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.date_range_rounded,
                                  color: Colors.black,
                                ),
                                labelText: "العمر (سنة)",
                                labelStyle: feildStyle,

                                //fillColor: Colors.green),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              controller: phoneController,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context)
                                    .requestFocus(focusAdress);
                              },
                              style: feildStyle,
                              focusNode: focusPhone,
                              cursorColor: color,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_sharp,
                                  color: Colors.black,
                                ),
                                labelText: "رقم الهاتف", labelStyle: feildStyle,

                                //fillColor: Colors.green),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              controller: adressController,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context)
                                    .requestFocus(focusDiagsDescription);
                              },
                              validator: (val) {
                                if (val == '') {
                                  return null;
                                }
                                if (trim(val!) == '') {
                                  return 'لا يمكنك ترك هذا الحقل فارغاَ';
                                } else {
                                  return null;
                                }
                              },
                              style: feildStyle,
                              cursorColor: color,
                              focusNode: focusAdress,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  color: Colors.black,
                                ),
                                labelText: "العنوان", labelStyle: feildStyle,

                                //fillColor: Colors.green),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              controller: noteController,
                              onFieldSubmitted: (val) {
                                // FocusScope.of(context).requestFocus(focus);
                              },
                              style: feildStyle,
                              focusNode: focusNotes,
                              cursorColor: color,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                labelText: "ملاحظات حول المشترك",
                                labelStyle: feildStyle,

                                //fillColor: Colors.green),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 7.0),
                          //   child: TextFormField(
                          //     controller: refferController,
                          //     onFieldSubmitted: (val) {
                          //       FocusScope.of(context)
                          //           .requestFocus(focusDiagsDescription);
                          //     },
                          //     style: feildStyle,
                          //     cursorColor: color,
                          //     focusNode: focusRefferFrom,
                          //     decoration: new InputDecoration(
                          //       prefixIcon: Icon(
                          //         Icons.medical_services_rounded,
                          //         color: Colors.black,
                          //       ),
                          //       labelText: "محول من", labelStyle: feildStyle,

                          //       //fillColor: Colors.green),
                          //     ),
                          //   ),
                          // ),

                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!isLoading) {
                                    if (_formKey.currentState!.validate()) {
                                      Client p = Client(
                                        id: Provider.of<ClientProvider>(context,
                                                listen: false)
                                            .lastId,
                                        name: trim(nameController.text),
                                        addingDate: DateTime.now(),
                                        address: trim(adressController.text),
                                        age: trim(ageController.text),
                                        notes: trim(noteController.text),
                                        phone: trim(phoneController.text),
                                        sex: male ? '1' : '0',
                                      );
                                      setState(() {
                                        isLoading = true;
                                      });
                                      bool result =
                                          await Provider.of<ClientProvider>(
                                                  context,
                                                  listen: false)
                                              .createPat(
                                                  p: p, context: context);

                                      if (result) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Text(
                                                    'تمت إضافة المشترك بنجاح !')),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child:
                                                    Text('حدث خطأ غير متوقع!')),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'إضافة المشترك',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo',
                                                fontSize: 15),
                                          ),
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
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
                  ),
                ),
              ],
            )),
      ),
    );
  }

  String getSocialState() {
    String result = '';
    if (marrid) {
      result = 'متزوج';
    } else if (azab) {
      result = 'أعزب';
    } else {
      result = 'مطلق';
    }
    return result;
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
