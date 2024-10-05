import 'package:firebase/bottomScreen.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase/launchePage.dart';
import 'package:firebase/login/Pages/loginPage.dart';
import 'package:firebase/login/Pages/registerscreen.dart';
import 'package:firebase/login_page.dart';
import 'package:firebase/on_boarding.dart';
import 'package:firebase/shopAdd.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LauncherPage(),
      ),
    );
  }
}

