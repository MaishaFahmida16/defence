
import 'package:firebase/bottomScreen.dart';
import 'package:firebase/launchePage.dart';
import 'package:firebase/login/Pages/registerscreen.dart';
import 'package:firebase/on_boarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../home_page.dart';
import '../Controller/loginController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  final IconData iconData = Icons.visibility;
  bool activeConnection = false;
  bool visiblepass = false;
  bool status = false;
  String errMsg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(child: Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
              )),
              Positioned(
                  bottom: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height/2+50.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                    ),
                  )),

              Positioned(
                  top: 190.h,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        height: 300.h,
                        width: MediaQuery.of(context).size.width-30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(
                              height: 0.h,
                            ),
                            Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 25.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    child: TextField(
                                      controller: loginController.emailController,
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF0a7bc4), width: 1.2)),
                                        prefixIcon: Icon(Icons.mail_outline,
                                            color: Color(0xff053c60)),
                                        labelText: 'Email',
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1.2)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1.2)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                    child: TextFormField(
                                      controller: loginController.passwordController,
                                      obscureText: !visiblepass,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.lock_outlined,
                                            color: Color(0xff053c60),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF0a7bc4), width: 1.2)),
                                          enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black, width: 1.2)),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black, width: 1.2)),
                                          suffixIcon: visiblepass
                                              ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  visiblepass
                                                      ? visiblepass = false
                                                      : visiblepass = true;
                                                });
                                              },
                                              icon: const Icon(Icons.visibility,
                                                  color: Color(0xff053c60)))
                                              : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  visiblepass
                                                      ? visiblepass = false
                                                      : visiblepass = true;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.visibility_off,
                                                color: Color(0xff053c60),
                                              )),
                                          labelText: 'Password',
                                          labelStyle: const TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  top: 520.h,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width-30.w,
                        height: 40.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Change to red color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            EasyLoading.show();
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: loginController.emailController.text.trim(),
                                password: loginController.passwordController.text.trim())
                                .then((value) {
                              EasyLoading.dismiss();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => LauncherPage()));
                            }).onError((error, stackTrace) {
                              Fluttertoast.showToast(
                                  msg: error.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              print("Error ${error.toString()}");
                            });
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 18.h),
                          ),
                        )
                        ,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Color(0xFF181E29),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => RegisterScreen()));

                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
