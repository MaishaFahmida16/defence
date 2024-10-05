import 'package:firebase/auth_service.dart';
import 'package:firebase/bottomScreen.dart';
import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase/login/Pages/loginPage.dart';
import 'package:firebase/login/Pages/registerscreen.dart';
import 'package:firebase/on_boarding.dart';
import 'package:firebase/repository/OnBoardRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  OnboardingController onboardingController=Get.put(OnboardingController());
  ShopController shopController=Get.put(ShopController());
  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 1));
    if (AuthService.user != null && AuthService.user!.uid != null) {
      await onboardingController.checkuserType(AuthService.user!.uid);

      if(AuthService.user!.email=="admin@gmail.com")
        {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.to(BottomNavScreen());
          });
        }

      else if (onboardingController.usertype == "") {
        // Defer navigation until after the widget tree is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(OnBoarding());
        });
      } else {
        await onboardingController.getProfile();

        // Defer navigation until after the widget tree is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.to(BottomNavScreen());
        });
      }
    } else {
      // Defer navigation until after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(LoginScreen());
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("images/intro.gif"),
      ),
    );
  }
}
