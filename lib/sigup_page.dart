// import 'package:firebase/login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'custom_widget.dart';
// import 'home_page.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
// final emailController = TextEditingController();
// final nameController = TextEditingController();
// final passController = TextEditingController();
// class _SignUpPageState extends State<SignUpPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           color:Colors.blue,
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 customTextField('Enter Your Name', Icons.person_2_outlined, false, nameController),
//                 SizedBox(height: 20,),
//                 customTextField('Enter Email', Icons.email_outlined, false, emailController),
//                 SizedBox(height: 20,),
//                 customTextField('Enter Password', Icons.lock_open, true, passController),
//                 SizedBox(height: 20,),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                    Text("Already have an account?",
//                      style: TextStyle(
//                          color: Colors.white
//                      ),),
//                     TextButton(onPressed: (){
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginPage()),
//                       );
//                     },
//                         child: Text("Login",
//                           style: TextStyle(
//                               color: Colors.white
//                           ),)),
//
//                   ],
//                 ),
//                 SizedBox(height: 20,),
//                 ElevatedButton(onPressed: () async{
//                   FirebaseAuth.instance
//                       .createUserWithEmailAndPassword(
//                       email: emailController.text,
//                       password: passController.text)
//                       .then((value) {
//                     print("Created New Account");
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => HomePage()));
//                   }).onError((error, stackTrace) {
//                     print("Error ${error.toString()}");
//                   });
//                 }, child: Text("Sign Up")),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
