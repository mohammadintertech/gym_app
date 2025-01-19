import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/screens/cases_screen.dart';
import 'package:gym_app/utils.dart';
import 'package:gym_app/widgets/case_dialog.dart';
import 'package:provider/provider.dart';

class EditClientScreen extends StatefulWidget {
  static TextEditingController diagsController = TextEditingController();
  static String routeName = 'edit_screen';
  @override
  _EditClientScreenState createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  List<String> diags = [];
  String selectedWork = 'لا شيء';

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

  int painValue = 10;
  String selectedDoctor = '';
  List<String> doctors = [
    'د. معاذ عياد',
    'د. فادي ابو عياش',
    'د. بشار سلطان',
    'د. خالد برقان',
    'د. حنا خمشتا',
    'د. عماد تلاحمة',
    'د. عبد الحق شاهين',
    'د. شادي ابو سنينة',
    'د. سعيد اتكيدك',
  ];

  List<String> works = [
    'عامل',
    'موظف',
    'تاجر',
    'معلم',
    'ربة منزل',
    'مقاول',
    'طالب',
    'لا شيء',
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
  bool enableEditing = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = Provider.of<ClientProvider>(context, listen: false)
        .selectedClient!
        .name!;
    phoneController.text = Provider.of<ClientProvider>(context, listen: false)
        .selectedClient!
        .phone!;
    adressController.text = Provider.of<ClientProvider>(context, listen: false)
        .selectedClient!
        .address!;
    ageController.text = Provider.of<ClientProvider>(context, listen: false)
        .selectedClient!
        .age!;

    painColorIndex = (painValue / 10).round() - 1;

    noteController.text = Provider.of<ClientProvider>(context, listen: false)
        .selectedClient!
        .notes!;
    male = Provider.of<ClientProvider>(context, listen: false)
                .selectedClient!
                .sex ==
            '1'
        ? true
        : false;
    debugPrint(painValue.toString());
    female = Provider.of<ClientProvider>(context, listen: false)
                .selectedClient!
                .sex ==
            '0'
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Platform.isAndroid || Platform.isIOS;
    double width = MediaQuery.of(context).size.width;
    final color = Colors.blue;
    var feildStyle = TextStyle(
      fontFamily: 'Cairo',
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontSize: isMobile ? 13 : 16,
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'سجل المشترك',
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
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    width: isMobile ? 30 : 200,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isMobile
                              ? Container()
                              : Text(
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
                          Row(
                            children: [
                              !enableEditing
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () {
                                        Provider.of<ClientProvider>(context,
                                                listen: false)
                                            .deletePat(
                                                p: Provider.of<ClientProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedClient,
                                                context: context);
                                      },
                                      child: SizedBox(
                                        width: isMobile ? 60 : 100,
                                        child: Center(
                                          child: Text(
                                            'حذف المشترك',
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
                                                Colors.red),
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
                          // Icon(
                          //   Icons.assignment_ind_rounded,
                          //   size: isMobile ? 80 : 120,
                          //   color: Colors.blue,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              enabled: enableEditing,
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
                              enableEditing
                                  ? Padding(
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
                                    )
                                  : Text(
                                      Provider.of<ClientProvider>(context,
                                                      listen: false)
                                                  .selectedClient!
                                                  .sex ==
                                              '1'
                                          ? '   ذكر'
                                          : '   أنثى',
                                      style: feildStyle,
                                    ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              enabled: enableEditing,
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
                          Row(
                            children: [
                              Text(
                                'الحالة الاجتماعية:',
                                style: feildStyle,
                              ),
                              enableEditing
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 7.0),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: azab,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      azab = true;
                                                      motalaq = false;
                                                      marrid = false;
                                                    });
                                                  }),
                                              Text(
                                                'أعزب',
                                                style: feildStyle,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: marrid,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      azab = false;
                                                      motalaq = false;
                                                      marrid = true;
                                                    });
                                                  }),
                                              Text(
                                                'متزوج',
                                                style: feildStyle,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: motalaq,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      azab = false;
                                                      motalaq = true;
                                                      marrid = false;
                                                    });
                                                  }),
                                              Text(
                                                'مطلق',
                                                style: feildStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : motalaq
                                      ? Text(
                                          '   مطلق',
                                          style: feildStyle,
                                        )
                                      : marrid
                                          ? Text(
                                              '   متزوج',
                                              style: feildStyle,
                                            )
                                          : Text(
                                              '   أعزب',
                                              style: feildStyle,
                                            ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                'المهنة:',
                                style: feildStyle,
                              ),
                              !enableEditing
                                  ? Container()
                                  : PopupMenuButton(
                                      onSelected: (int value) async {
                                        setState(() {
                                          selectedWork = workController.text =
                                              works[value];
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              'اختيار مهنة',
                                              style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text(
                                            works[0],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 0,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[1],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[2],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 2,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[3],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 3,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[4],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 4,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[5],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 5,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[6],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 6,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            works[7],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 7,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                width: 30,
                              ),
                              SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: TextFormField(
                                    enabled: enableEditing,
                                    controller: workController,
                                    onFieldSubmitted: (val) {
                                      FocusScope.of(context)
                                          .requestFocus(focusPhone);
                                    },
                                    style: feildStyle,
                                    onChanged: (val) {
                                      selectedWork = workController.text;
                                    },
                                    focusNode: focusWork,
                                    cursorColor: color,
                                    decoration: new InputDecoration(
                                      labelText: "المهنة",
                                      labelStyle: feildStyle,

                                      //fillColor: Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              enabled: enableEditing,
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
                              enabled: enableEditing,
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
                          Center(
                            child: SizedBox(
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!isLoading) {
                                      if (enableEditing) {
                                        enableEditing = false;
                                        Provider.of<ClientProvider>(context,
                                                listen: false)
                                            .selectedClient!
                                            .updateData(
                                              painIntensity:
                                                  trim(painValue.toString()),
                                              otherMedicalProblems: trim(
                                                  otherMedicalProblemsController
                                                      .text),
                                              name: trim(nameController.text),
                                              address:
                                                  trim(adressController.text),
                                              age: trim(ageController.text),
                                              notes: trim(noteController.text),
                                              diagsDescription: trim(
                                                  diagsDescriptionController
                                                      .text),
                                              phone: trim(phoneController.text),
                                              refferedFrom:
                                                  trim(refferController.text),
                                              sex: male ? '1' : '0',
                                              socialState: getSocialState(),
                                              work: selectedWork,
                                            );
                                        await Provider.of<ClientProvider>(
                                                context,
                                                listen: false)
                                            .updatePat(context);
                                      } else {
                                        enableEditing = true;
                                      }
                                      setState(() {});
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
                                          : Text(
                                              enableEditing ? 'تم' : 'تعديل',
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
                            ),
                          ),
                          SizedBox(
                            width: 500,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 4),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await Provider.of<CaseProvider>(
                                                  context,
                                                  listen: false)
                                              .getGymCat(context: context);
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return CaseDialog();
                                            },
                                          );
                                        },
                                        child: Center(
                                          child: Text(
                                            'إضافة اشتراك',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo',
                                                fontSize: 15),
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
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 4),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(CasesScreen.routeName);
                                        },
                                        child: Center(
                                          child: Text(
                                            'عرض اشتراكات المشترك',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo',
                                                fontSize: 15),
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Center(
                    child: Container(
                      // color: Colors.black,
                      padding: EdgeInsets.all(15),
                      width: width - width / 1.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.assignment_ind_rounded,
                          //   size: isMobile ? 80 : 120,
                          //   color: Colors.blue,
                          // ),

                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: TextFormField(
                              enabled: enableEditing,
                              controller: diagsDescriptionController,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusPain);
                              },
                              maxLines: 5,
                              style: feildStyle,
                              cursorColor: color,
                              textAlign: TextAlign.left,
                              focusNode: focusDiagsDescription,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.date_range_rounded,
                                  color: Colors.black,
                                ),
                                labelText: "التشخيص", labelStyle: feildStyle,
                                focusedBorder: OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(60.0),
                                  borderSide: BorderSide(color: color),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                //fillColor: Colors.green),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 9.0),
                          //   child: TextFormField(
                          //     controller: painController,
                          //     onFieldSubmitted: (val) {
                          //       FocusScope.of(context).requestFocus(focusOther);
                          //     },
                          //     style: feildStyle,
                          //     cursorColor: color,
                          //     focusNode: focusPain,
                          //     decoration: InputDecoration(
                          //       prefixIcon: const Icon(
                          //         Icons.date_range_rounded,
                          //         color: Colors.black,
                          //       ),
                          //       labelText: "شدة الألم", labelStyle: feildStyle,

                          //       //fillColor: Colors.green),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'شدة الألم',
                                      style: feildStyle,
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    // FAProgressBar(
                                    //   currentValue: painValue as,
                                    //   progressColor:
                                    //       painValueColors[painColorIndex],
                                    // ),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 100;
                                              painColorIndex = 9;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '100%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 90;

                                              painColorIndex = 8;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '90%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 80;

                                              painColorIndex = 7;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '80%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 70;

                                              painColorIndex = 6;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '70%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 60;

                                              painColorIndex = 5;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '60%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 50;

                                              painColorIndex = 4;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '50%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 40;

                                              painColorIndex = 3;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '40%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 30;

                                              painColorIndex = 2;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '30%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 20;

                                              painColorIndex = 1;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '20%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                          Expanded(
                                              child: GestureDetector(
                                            onTap: () {
                                              if (!enableEditing) {
                                                return;
                                              }
                                              painValue = 10;

                                              painColorIndex = 0;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                      '10%',
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Cairo'),
                                                    ),
                                                    Container(
                                                      color: Colors.black,
                                                      width: 2,
                                                      height: 6,
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              enabled: enableEditing,
                              maxLines: 3,
                              controller: otherMedicalProblemsController,
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).requestFocus(focusNotes);
                              },
                              style: feildStyle,
                              cursorColor: color,
                              focusNode: focusOther,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(60.0),
                                  borderSide: BorderSide(color: color),
                                ),
                                prefixIcon: Icon(
                                  Icons.date_range_rounded,
                                  color: Colors.black,
                                ),
                                labelText: "مشاكل طبية اخرى",
                                labelStyle: feildStyle,
                                enabledBorder: OutlineInputBorder(
                                  // borderRadius: new BorderRadius.circular(60.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                //fillColor: Colors.green),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: TextFormField(
                              enabled: enableEditing,
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
                          Row(
                            children: [
                              Text(
                                'طبيب:',
                                style: feildStyle,
                              ),
                              !enableEditing
                                  ? Container()
                                  : PopupMenuButton(
                                      onSelected: (int value) async {
                                        setState(() {
                                          selectedDoctor = refferController
                                              .text = doctors[value];
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              'اختيار طبيب',
                                              style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[0],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 0,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[1],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[2],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 2,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[3],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 3,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[4],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 4,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[5],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 5,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[6],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 6,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[7],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 7,
                                        ),
                                        PopupMenuItem(
                                          child: Text(
                                            doctors[8],
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: 8,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                width: 30,
                              ),
                              SizedBox(
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: TextFormField(
                                    enabled: enableEditing,
                                    controller: refferController,
                                    onFieldSubmitted: (val) {
                                      FocusScope.of(context)
                                          .requestFocus(focusPhone);
                                    },
                                    style: feildStyle,
                                    onChanged: (val) {
                                      selectedWork = workController.text;
                                    },
                                    focusNode: focusWork,
                                    cursorColor: color,
                                    decoration: new InputDecoration(
                                      labelText: "محول من",
                                      labelStyle: feildStyle,

                                      //fillColor: Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            height: 30,
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
