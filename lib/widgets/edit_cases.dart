import 'package:flutter/material.dart';
import 'package:gym_app/models/clinc_case.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:gym_app/widgets/add_clinc_case_dialog.dart';
import 'package:provider/provider.dart';

class EditCasesDialog extends StatefulWidget {
  @override
  State<EditCasesDialog> createState() => _EditCasesDialogState();
}

class _EditCasesDialogState extends State<EditCasesDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 600,
        height: 600,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await Provider.of<CaseProvider>(context, listen: false)
                    .getGymCat(context: context);
                showDialog(
                  context: context,
                  builder: (_) {
                    return AddClincCase(setState);
                  },
                );
              },
              child: SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                    'إضافة قسم',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 15),
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
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Center(),
                  ),
                  Expanded(
                    child: Center(
                        child: Text(
                      'القسم',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 530,
              child: Consumer<CaseProvider>(
                builder: (context, cases, child) {
                  return ListView.builder(
                    itemCount: cases.clincCases!.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 60,
                        child: Card(
                          color: Colors.grey[100],
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<CaseProvider>(context,
                                            listen: false)
                                        .deleteClincCase(
                                      c: cases.clincCases![index],
                                      context: context,
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                    child: Text(
                                  cases.clincCases![index].title!,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
