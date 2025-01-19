import 'package:flutter/material.dart';
import 'package:gym_app/providers/case_provider.dart';
import 'package:provider/provider.dart';

class AddClincCase extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  Function? setStateFunction;
  AddClincCase(this.setStateFunction);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 200,
        width: 300,
        child: Container(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    onChanged: (val) {},
                    controller: titleController,
                    cursorColor: Colors.blue,
                    // obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'اسم العلاج',
                      labelStyle: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: new BorderRadius.circular(100.0),
                        // borderSide: BorderSide(color: color),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CaseProvider>(context, listen: false)
                            .addClincCase(titleController.text);
                        debugPrint('sss');
                        setStateFunction!(() {});
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            'حفظ',
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }
}
