import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/patient.dart';
import 'package:gym_app/providers/patient_provider.dart';
import 'package:gym_app/screens/edit_pat_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static bool isLoading = false;
  static bool enableEditing = false;
  static String routeName = 'search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  bool showSideInfo = false;
  int counter = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SearchScreen.isLoading = true;
  }

  Future<bool> getPats() async {
    bool resultLastId =
        await Provider.of<ClientProvider>(context, listen: false)
            .getLastId(context: context);
    debugPrint('the last id : ' +
        Provider.of<ClientProvider>(context, listen: false).lastId.toString());
    Provider.of<ClientProvider>(context, listen: false).max =
        Provider.of<ClientProvider>(context, listen: false).lastId - 1;

    debugPrint('max : ' +
        Provider.of<ClientProvider>(context, listen: false).max.toString());
    Provider.of<ClientProvider>(context, listen: false).patients.clear();
    if (resultLastId) {
      await Provider.of<ClientProvider>(context, listen: false)
          .getClients(context: context);
    }
    return true;
  }

  Future<void> loadMore() async {
    await Provider.of<ClientProvider>(context, listen: false)
        .getClients(context: context);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Platform.isAndroid || Platform.isIOS;
    double width = MediaQuery.of(context).size.width;
    final tableHeadersStyle =
        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
    // return ElevatedButton(onPressed: (){
    //   setState(() {
    //           counter++;
    //         });
    // }, child: Text(counter.toString()));
    return Scaffold(
      body: FutureBuilder<bool>(
        future: getPats(), // a previously-obtained Future<String> or null
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
                              isMobile
                                  ? Container()
                                  : Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                      ' رجوع',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontFamily: 'Cairo',
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              loadMore();
                                              // bool resultLastId =
                                              //     await Provider.of<
                                              //                 ClientProvider>(
                                              //             context,
                                              //             listen: false)
                                              //         .getLastId(
                                              //             context: context);

                                              // if (resultLastId) {
                                              //   Provider.of<ClientProvider>(
                                              //           context,
                                              //           listen: false)
                                              //       .getClients(
                                              //           context: context);
                                              // }

                                              // setState(() {
                                              //   SearchScreen.isLoading = true;
                                              // });
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.refresh,
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                      'تحد يث',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontFamily: 'Cairo',
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.grey),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      height: 50,
                                      child: TextField(
                                        style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        onSubmitted: (val) {
                                          debugPrint('enter button');
                                        },
                                        onChanged: (val) {
                                          if (val.length > 2) {
                                            List<String> words =
                                                searchController.text
                                                    .split(" ");
                                            debugPrint(words.toString());
                                            Provider.of<ClientProvider>(context,
                                                    listen: false)
                                                .getClientsByWords(
                                                    context: context,
                                                    words: words);
                                          } else {
                                            Provider.of<ClientProvider>(context,
                                                    listen: false)
                                                .getClients(
                                              context: context,
                                            );
                                          }
                                        },
                                        controller: searchController,
                                        cursorColor: Colors.blue,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                          labelText: "بحث...",
                                          labelStyle: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),

                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    100.0),
                                            // borderSide: BorderSide(color: color),
                                          ),
                                          //fillColor: Colors.green),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    isMobile
                                        ? Container()
                                        : ElevatedButton(
                                            onPressed: () {
                                              searchController.text.split(
                                                  " "); // ["Hello", "world!"];
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.search,
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                      'بحث',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontFamily: 'Cairo',
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      !isMobile
                          ? Container()
                          : Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          SearchScreen.isLoading = true;
                                        });
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.refresh,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                'تحسسد يث',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontFamily: 'Cairo',
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      style: ButtonStyle(
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
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'إضافة مشترك',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontFamily: 'Cairo',
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
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
                                    'تاريخ الإضافة',
                                    style: TextStyle(
                                        fontSize: isMobile ? 12 : 14,
                                        color: Colors.blue,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'الإسم',
                                    style: TextStyle(
                                        fontSize: isMobile ? 12 : 14,
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
                                        fontSize: isMobile ? 12 : 14,
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
                      Consumer<ClientProvider>(
                        builder: (context, provider, child) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: provider.patients.length,
                              itemBuilder: (_, index) {
                                return Card(
                                  color: Colors.grey[100],
                                  child: InkWell(
                                    hoverColor: Colors.grey[300],
                                    // // focusColor: Colors.red,
                                    // overlayColor:
                                    //     MaterialStateProperty.all(Colors.red),
                                    // highlightColor: Colors.red,

                                    onTap: () {
                                      Provider.of<ClientProvider>(context,
                                                  listen: false)
                                              .selectedClient =
                                          provider.patients[index];
                                      Navigator.of(context).pushNamed(
                                          EditClientScreen.routeName);
                                      // SearchScreen.selectedClient =
                                      //     patProvider.searchList[index];
                                      // if (isMobile) {
                                      //   Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ClinetsInfoScreen()),
                                      //   );
                                      // } else {
                                      //   ClinetsInfoSideContainer
                                      //       .setStateForAnimation(true);
                                      // }
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
                                                  Provider.of<ClientProvider>(
                                                          context,
                                                          listen: false)
                                                      .getDate(provider
                                                          .patients[index]
                                                          .addingDate!
                                                          .toString()),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  provider
                                                      .patients[index].name!,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                      fontFamily: 'Cairo',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  (provider.patients.length -
                                                          index)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Cairo',
                                                      fontSize:
                                                          isMobile ? 12 : 14,
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
