import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var visiblepass = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var success=''.obs;

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Login successful, navigate to the next screen or perform other actions.
      print("User logged in: ${userCredential.user}");
      success.value="success";
    } catch (e) {
      success.value=e.toString();
      // Login failed, handle the error.
      print("Login failed: $e");
      // Show an error dialog or message to the user.
    }
  }
  Future<void> register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('User registered successfully: ${userCredential.user!.uid}');
      success.value="success";
    } catch (e) {
      success.value=e.toString();
      print('Error registering user: $e');
    }
  }
}