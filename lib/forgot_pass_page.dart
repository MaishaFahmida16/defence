import 'package:firebase/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}
final emailController = TextEditingController();
class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Colors.blue,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customTextField('Enter Email', Icons.email_outlined, false, emailController),
                SizedBox(height: 20,),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: () async{
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text)
                      .then((value) => Navigator.of(context).pop());
                }, child: Text("Reset Password")),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
