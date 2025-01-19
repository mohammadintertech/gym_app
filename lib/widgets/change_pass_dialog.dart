import 'package:flutter/material.dart';
import 'package:gym_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChangePassDialog extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: SizedBox(
          height: 400,
          width: 300,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'أدخل اسم المستخدم';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      onChanged: (val) {},
                      controller: usernameController,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        labelText: "اسم المستخدم",
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
                    child: TextFormField(
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      onChanged: (val) {},
                      controller: oldPassController,
                      cursorColor: Colors.blue,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "كلمة المرور القديمة",
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
                    child: TextFormField(
                      validator: (val) {
                        if (val!.length < 4) {
                          return 'كلمة المرور قصيرة جدا';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      onChanged: (val) {},
                      controller: passwordController,
                      cursorColor: Colors.blue,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "كلمة المرور الجديدة",
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
                    child: TextFormField(
                      validator: (val) {
                        if (val == passwordController.text) {
                          return null;
                        } else {
                          return 'كلمة المرور غير متطابقة';
                        }
                      },
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      onChanged: (val) {},
                      obscureText: true,
                      controller: confirmPassController,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        labelText: "تأكيد كلمة المرور الجديدة",
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
                  SizedBox(
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Provider.of<UserProvider>(context, listen: false)
                                .changePass(
                                    usernameController.text,
                                    oldPassController.text,
                                    passwordController.text,
                                    context);
                          }
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
      ),
    );
  }
}
