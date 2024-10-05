// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/custom_widget.dart';
// import 'package:firebase/forgot_pass_page.dart';
// import 'package:firebase/sigup_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// import 'home_page.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// final emailController = TextEditingController();
// final passController = TextEditingController();
//
//
//
// class _LoginPageState extends State<LoginPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color:Colors.blue,
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage('images/img.png'),),
//                 SizedBox(height: 20,),
//                 customTextField('Enter Email', Icons.email_outlined, false, emailController),
//                 SizedBox(height: 20,),
//                 customTextField('Enter Password', Icons.lock_open, true, passController),
//                 SizedBox(height: 20,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(onPressed: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
//                       );
//                     },
//                         child: Text("Forgot Password",
//                         style: TextStyle(
//                           color: Colors.white
//                         ),)),
//                     TextButton(onPressed: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SignUpPage()),
//                       );
//                     },
//                         child: Text("Sign Up",
//                           style: TextStyle(
//                               color: Colors.white
//                           ),)),
//
//                   ],
//                 ),
//                 SizedBox(height: 20,),
//                 ElevatedButton(onPressed: () async{
//                  FirebaseAuth.instance
//                      .signInWithEmailAndPassword(
//                      email: emailController.text,
//                      password: passController.text)
//                      .then((value) {
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => HomePage()));
//                  }).onError((error, stackTrace) {
//                    print("Error ${error.toString()}");
//                  });
//                 }, child: Text("Login")),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
