import 'package:flutter/material.dart';
import 'package:gym_app/models/employee.dart';
import 'package:gym_app/providers/employess_provider.dart';
import 'package:provider/provider.dart';

class AddEmployee extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          child: SizedBox(
        height: 230,
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'أدخل اسم الموظف',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  validator: (val) {
                    if (val == '') {
                      return 'أدخل اسم الموظف';
                    }
                    if (val!.length < 3) {
                      return 'الاسم قصير جدا';
                    }
                    return null;
                  },
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  onChanged: (val) {},
                  controller: nameController,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    labelText: "الاسم",
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
                    //fillColor: Colors.green),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool result = await Provider.of<EmployeesProvider>(
                              context,
                              listen: false)
                          .createEmp(
                              e: Employee(
                                  name: nameController.text,
                                  addingDate: DateTime.now().toString()));
                      if (result) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'إضافة',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Cairo',
                            fontSize: 15),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
