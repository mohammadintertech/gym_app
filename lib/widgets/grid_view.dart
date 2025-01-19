import 'package:flutter/material.dart';
import 'package:gym_app/models/clinc_case.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:provider/provider.dart';

class CasesGridView extends StatefulWidget {
  @override
  _CasesGridViewState createState() => _CasesGridViewState();
}

class _CasesGridViewState extends State<CasesGridView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CaseProvider>(builder: (context, cases, child) {
      return Expanded(
        child: GridView.builder(
          itemCount: cases.clincCases!.length, // cases.clincCases!.length,
          itemBuilder: (context, index) {
            return InkWell(
              // overlayColor: MaterialStateProperty.all(Colors.red),
              hoverColor: Colors.grey,
              onTap: () {
                setState(() {
                  cases.clincCases![index].isSelected =
                      !Provider.of<CaseProvider>(context, listen: false)
                          .clincCases![index]
                          .isSelected!;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: cases.clincCases![index].isSelected!
                        ? Colors.blue
                        : Colors.transparent,
                    border: Border.all(color: Colors.black)),
                child: Center(
                  child: Text(
                    cases.clincCases![index].title!,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
            childAspectRatio: 5.1,
          ),
        ),
      );
    });
  }
}
