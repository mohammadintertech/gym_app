import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/providers/employess_provider.dart';
import 'package:provider/provider.dart';

class FinScreen extends StatefulWidget {
  static String routeName = 'fin screen';
  static bool isLoading = false;
  @override
  _FinScreenState createState() => _FinScreenState();
}

class _FinScreenState extends State<FinScreen> {
  String selectedEmployee = 'الكل';
  String word = '';
  int eIndex = 0;
  DateTime? fromDate, toDate;
  bool all = true,
      AllIncrease = false,
      AllDecraese = false,
      decreaseEmp = false,
      decrease = false;
  bool today = true,
      calculateWithDate = false,
      yesterday = false,
      thisMonth = false,
      lastMonth = false,
      thisYear = false;

  @override
  void initState() {
    super.initState();
    FinScreen.isLoading = true;
    word = '${getDate(DateTime.now().toString())}';
    Provider.of<EmployeesProvider>(context, listen: false)
        .getEmployees(context: context);
    // Provider.of<BondsProvider>(context, listen: false).getBonds(
    //   Provider.of<UserProvier>(context, listen: false).user.clincId,
    //   context,
    // );
  }

  Future<void> refresh() async {
    setState(() {
      FinScreen.isLoading = true;
      all = true;
      AllIncrease = false;
      decrease = false;
      AllDecraese = false;
      decreaseEmp = false;
      today = true;
      calculateWithDate = false;
      yesterday = false;
      thisMonth = false;
      lastMonth = false;
      thisYear = false;

      // Provider.of<BondsProvider>(context, listen: false).getBonds(
      //   Provider.of<UserProvier>(context, listen: false).user.clincId,
      //   context,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
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
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                'رجوع',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[800]!),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<CaseProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          // '${bondsPrvider.bondsSum} ₪',
                          '${Provider.of<CaseProvider>(context, listen: false).totalValue}  ₪   ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: // bondsPrvider.bondsSum
                                  // // 5>= 0
                                  //     ? Colors.green
                                  Colors.red,
                              fontFamily: 'Cairo',
                              fontSize: 25),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 70,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.s,
                      children: [
                        Text(
                          'عرض حسب المدة : ',
                          style: TextStyle(
                              color: Colors.blue[800]!,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: today,
                                onChanged: (val) async {
                                  if (val == true) {
                                    setState(() {
                                      fromDate = null;
                                      toDate = null;
                                      today = val!;
                                      yesterday = false;
                                      calculateWithDate = false;
                                      thisMonth = false;
                                      lastMonth = false;
                                      thisYear = false;
                                      word =
                                          '${getDate(DateTime.now().toString())}';
                                      Provider.of<CaseProvider>(context,
                                              listen: false)
                                          .getBonds(
                                              context: context,
                                              emp: selectedEmployee,
                                              word:
                                                  '${getDate(DateTime.now().toString())}');
                                      // Provider.of<BondsProvider>(context,
                                      //         listen: false)
                                      //     .getSelectedBonds(
                                      //   all: all,
                                      //   AllIncrease: AllIncrease,
                                      //   AllDecraese: AllDecraese,
                                      //   today: today,
                                      //   yesterday: yesterday,
                                      //   decrease: decrease,
                                      //   decreaseEmp: decreaseEmp,
                                      //   toDate: toDate,
                                      //   fromDate: fromDate,
                                      //   thisYear: thisYear,
                                      //   thisMonth: thisMonth,
                                      //   lastMonth: lastMonth,
                                      //   calculateWithDate: calculateWithDate,
                                      // );
                                    });
                                  }
                                }),
                            Text(
                              'هذا اليوم,',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: yesterday,
                                onChanged: (val) {
                                  if (val == true) {
                                    setState(() {
                                      fromDate = null;
                                      calculateWithDate = false;
                                      toDate = null;
                                      yesterday = val!;
                                      today = false;
                                      thisMonth = false;
                                      lastMonth = false;

                                      thisYear = false;

                                      word =
                                          '${getDate(DateTime.now().subtract(Duration(days: 1)).toString())}';
                                      Provider.of<CaseProvider>(context,
                                              listen: false)
                                          .getBonds(
                                              context: context,
                                              emp: selectedEmployee,
                                              word:
                                                  '${getDate(DateTime.now().subtract(Duration(days: 1)).toString())}');
                                      // Provider.of<BondsProvider>(context,
                                      //         listen: false)
                                      //     .getSelectedBonds(
                                      //   all: all,
                                      //   AllIncrease: AllIncrease,
                                      //   AllDecraese: AllDecraese,
                                      //   today: today,
                                      //   yesterday: yesterday,
                                      //   decrease: decrease,
                                      //   decreaseEmp: decreaseEmp,
                                      //   toDate: toDate,
                                      //   fromDate: fromDate,
                                      //   thisYear: thisYear,
                                      //   thisMonth: thisMonth,
                                      //   lastMonth: lastMonth,
                                      //   calculateWithDate: calculateWithDate,
                                      // );
                                    });
                                  }
                                }),
                            Text(
                              'اليوم السابق,',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: thisMonth,
                                onChanged: (val) {
                                  if (val == true) {
                                    setState(() {
                                      fromDate = null;
                                      toDate = null;
                                      thisMonth = val!;
                                      yesterday = false;
                                      today = false;
                                      calculateWithDate = false;
                                      lastMonth = false;
                                      thisYear = false;
                                      String year =
                                          DateTime.now().year.toString();
                                      String month = DateTime.now().month < 10
                                          ? "${'0' + DateTime.now().month.toString()}"
                                          : DateTime.now().month.toString();
                                      word = year + '-' + month;
                                      Provider.of<CaseProvider>(context,
                                              listen: false)
                                          .getBonds(
                                              context: context,
                                              emp: selectedEmployee,
                                              word: year + '-' + month);
                                      // Provider.of<BondsProvider>(context,
                                      //         listen: false)
                                      //     .getSelectedBonds(
                                      //   all: all,
                                      //   AllIncrease: AllIncrease,
                                      //   AllDecraese: AllDecraese,
                                      //   today: today,
                                      //   yesterday: yesterday,
                                      //   decrease: decrease,
                                      //   decreaseEmp: decreaseEmp,
                                      //   toDate: toDate,
                                      //   fromDate: fromDate,
                                      //   thisYear: thisYear,
                                      //   thisMonth: thisMonth,
                                      //   lastMonth: lastMonth,
                                      //   calculateWithDate: calculateWithDate,
                                      // );
                                    });
                                  }
                                }),
                            Text(
                              'هذا الشهر,',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: lastMonth,
                                onChanged: (val) {
                                  if (val == true) {
                                    setState(() {
                                      fromDate = null;
                                      toDate = null;
                                      lastMonth = val!;
                                      yesterday = false;
                                      thisMonth = false;
                                      today = false;
                                      thisYear = false;
                                      calculateWithDate = false;
                                      var prevMonth = new DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month - 1,
                                          DateTime.now().day);

                                      String year = prevMonth.year.toString();
                                      String month = prevMonth.month < 10
                                          ? "${'0' + (prevMonth.month).toString()}"
                                          : (prevMonth.month).toString();
                                      word = year + '-' + month;
                                      Provider.of<CaseProvider>(context,
                                              listen: false)
                                          .getBonds(
                                              context: context,
                                              emp: selectedEmployee,
                                              word: year + '-' + month);
                                      // Provider.of<BondsProvider>(context,
                                      //         listen: false)
                                      //     .getSelectedBonds(
                                      //   all: all,
                                      //   AllIncrease: AllIncrease,
                                      //   AllDecraese: AllDecraese,
                                      //   today: today,
                                      //   yesterday: yesterday,
                                      //   decrease: decrease,
                                      //   decreaseEmp: decreaseEmp,
                                      //   toDate: toDate,
                                      //   fromDate: fromDate,
                                      //   thisYear: thisYear,
                                      //   thisMonth: thisMonth,
                                      //   lastMonth: lastMonth,
                                      //   calculateWithDate: calculateWithDate,
                                      // );
                                    });
                                  }
                                }),
                            Text(
                              'الشهر السابق,',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: thisYear,
                                onChanged: (val) {
                                  if (val == true) {
                                    setState(() {
                                      fromDate = null;
                                      calculateWithDate = false;
                                      toDate = null;
                                      thisYear = val!;
                                      yesterday = false;
                                      thisMonth = false;
                                      lastMonth = false;
                                      today = false;
                                      word = (DateTime.now().year).toString();
                                      Provider.of<CaseProvider>(context,
                                              listen: false)
                                          .getBonds(
                                              context: context,
                                              emp: selectedEmployee,
                                              word: (DateTime.now().year)
                                                  .toString());
                                      // Provider.of<BondsProvider>(context,
                                      //         listen: false)
                                      //     .getSelectedBonds(
                                      //   all: all,
                                      //   AllIncrease: AllIncrease,
                                      //   AllDecraese: AllDecraese,
                                      //   today: today,
                                      //   yesterday: yesterday,
                                      //   decrease: decrease,
                                      //   decreaseEmp: decreaseEmp,
                                      //   toDate: toDate,
                                      //   fromDate: fromDate,
                                      //   thisYear: thisYear,
                                      //   thisMonth: thisMonth,
                                      //   lastMonth: lastMonth,
                                      //   calculateWithDate: calculateWithDate,
                                      // );
                                    });
                                  }
                                }),
                            Text(
                              'هذا العام,',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Text(
                        //   'تحد يد تاريخ:  ',
                        //   style: TextStyle(
                        //       fontFamily: 'Cairo',
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black,
                        //       fontSize: 15),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     fromDate = await _selectDate(context);
                        //     setState(() {});
                        //   },
                        //   child: Center(
                        //     child: Text(
                        //       // fromDate == null
                        //       //     ? 'من'
                        //       //     : DateTimeProvider.date(fromDate),
                        //       '00-00-0000',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //           fontFamily: 'Cairo',
                        //           fontSize: 15),
                        //     ),
                        //   ),
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStateProperty.all(Colors.blue[800]!),
                        //     shape: MaterialStateProperty.all<
                        //         RoundedRectangleBorder>(
                        //       RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(50.0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     toDate = await _selectDate(context);
                        //     setState(() {});
                        //   },
                        //   child: Center(
                        //     child: Text(
                        //       // toDate == null
                        //       //     ? 'إلى'
                        //       //     : DateTimeProvider.date(toDate),
                        //       '00-00-0000',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //           fontFamily: 'Cairo',
                        //           fontSize: 15),
                        //     ),
                        //   ),
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStateProperty.all(Colors.blue[800]!),
                        //     shape: MaterialStateProperty.all<
                        //         RoundedRectangleBorder>(
                        //       RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(50.0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       thisMonth = false;
                        //       yesterday = false;
                        //       today = false;
                        //       lastMonth = false;
                        //       thisYear = false;
                        //       calculateWithDate = true;

                        //       // Provider.of<BondsProvider>(context, listen: false)
                        //       //     .getSelectedBonds(
                        //       //   all: all,
                        //       //   AllIncrease: AllIncrease,
                        //       //   AllDecraese: AllDecraese,
                        //       //   today: today,
                        //       //   yesterday: yesterday,
                        //       //   decrease: decrease,
                        //       //   decreaseEmp: decreaseEmp,
                        //       //   toDate: toDate,
                        //       //   fromDate: fromDate,
                        //       //   thisYear: thisYear,
                        //       //   thisMonth: thisMonth,
                        //       //   lastMonth: lastMonth,
                        //       //   calculateWithDate: calculateWithDate,
                        //       // );
                        //     });
                        //   },
                        //   child: Center(
                        //     child: Text(
                        //       'حساب',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //           fontFamily: 'Cairo',
                        //           fontSize: 15),
                        //     ),
                        //   ),
                        //   style: ButtonStyle(
                        //     shape: MaterialStateProperty.all<
                        //         RoundedRectangleBorder>(
                        //       RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(50.0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: PopupMenuButton(
                        onSelected: (int value) async {
                          debugPrint(value.toString());
                          if (value == 0) {
                            setState(() {
                              selectedEmployee = 'الكل';
                              Provider.of<CaseProvider>(context, listen: false)
                                  .getBonds(
                                      context: context,
                                      emp: selectedEmployee,
                                      word: word);
                            });
                          } else {
                            setState(() {
                              selectedEmployee = Provider.of<EmployeesProvider>(
                                      context,
                                      listen: false)
                                  .employees[value - 1]
                                  .name!;
                              debugPrint(selectedEmployee);
                              Provider.of<CaseProvider>(context, listen: false)
                                  .getBonds(
                                      context: context,
                                      emp: selectedEmployee,
                                      word: word);
                            });
                          }
                        },
                        child: Container(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
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
                                      color: Colors.blue[800]!,
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
                        ),
                        itemBuilder: (context) => getList(),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          // FinWidget(),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: Colors.blue[800]!,
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
                        'المبلغ',
                        style: TextStyle(
                            color: Colors.blue[800]!,
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'التاريخ',
                        style: TextStyle(
                            color: Colors.blue[800]!,
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'اسم المعالج',
                        style: TextStyle(
                            color: Colors.blue[800]!,
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'اسم المشترك',
                        style: TextStyle(
                            color: Colors.blue[800]!,
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'الرقم',
                        style: TextStyle(
                            color: Colors.blue[800]!,
                            fontFamily: 'Cairo',
                            fontSize: 14,
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
            dashColor: Colors.blue[800]!,
            dashRadius: 0.0,
            dashGapLength: 4.0,
            dashGapColor: Colors.transparent,
            dashGapRadius: 0.0,
          ),
          Consumer<CaseProvider>(
            builder: (context, provider, child) {
              return Expanded(
                child: Container(
                  height: double.infinity,
                  child: ListView.builder(
                    itemCount: provider.bonds!.length,
                    itemBuilder: (_, index) {
                      return Card(
                        color: Colors.grey[100],
                        child: InkWell(
                          hoverColor: Colors.grey[300],
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (_) {
                            //     return BondInfo(
                            //         bondsPrvider.tempBonds[index],refresh);
                            //   },
                            // );
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
                                        // getDescription(bondsPrvider
                                        //     .tempBonds[index]),
                                        provider.bonds![index].price!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        // getDate(bondsPrvider
                                        //     .tempBonds[index]),
                                        provider.bonds![index].date!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        // getUserName(bondsPrvider
                                        //     .tempBonds[index]),
                                        provider.bonds![index].patName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        // getDate(bondsPrvider
                                        //     .tempBonds[index]),
                                        (provider.bonds!.length - index)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<PopupMenuItem<int>> getList() {
    List<PopupMenuItem<int>> list = [];

    eIndex = 1;
    list = Provider.of<EmployeesProvider>(context, listen: false).employees.map(
      (e) {
        var p = PopupMenuItem<int>(
          child: Text(
            e.name!,
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold),
          ),
          value: eIndex,
        );
        eIndex++;

        return p;
      },
    ).toList();
    list.insert(
        0,
        PopupMenuItem(
          child: Text(
            'الكل',
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold),
          ),
          value: 0,
        ));
    return list;
  }
  // String getDescription(Bond b) {
  //   if (b.type == 'increase') {
  //     return 'اسم المشترك: ${b.patName}';
  //   } else if (b.type == 'decrease emp') {
  //     return 'مسحوبات موظف:  ${b.empName}';
  //   } else if (b.type == 'decrease') {
  //     return 'صرف: ${b.description}';
  //   }
  //   return '';
  // }

  // String getAmount(Bond b) {
  //   if (b.type == 'increase') {
  //     return b.amount.toString();
  //   } else {
  //     return (-b.amount).toString();
  //   }
  // }

  String getDate(String pars) {
    return Provider.of<CaseProvider>(context, listen: false).getDate(pars);
  }

  // String getUserName(Bond b) {
  //   return b.userName;
  // }

  // Future<DateTime> _selectDate(BuildContext context) async {
  //   debugPrint('show adte picker');
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));

  //   return picked!;}
}
