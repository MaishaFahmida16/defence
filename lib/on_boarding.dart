import 'package:firebase/bottomScreen.dart';
import 'package:firebase/const/color_helper.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/launchePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'controller/onboarding_controller.dart';
import 'home_page.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  bool user=false;
  bool shopkeepr=false;
  bool deliveryman=false;
  String selectedCat="Select";
  String cat="Select";
  OnboardingController onboardingController=Get.put(OnboardingController());
  ShopController shopController=Get.put(ShopController());


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: user || shopkeepr || deliveryman?
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color:Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Complete Profile",style: TextStyle(
                        fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                    ),),
                
                  ),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async{
                    await onboardingController.pickImage();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15)
                          )
                      ),
                      height: 120.h,
                      width: MediaQuery.of(context).size.width-0.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15)
                          ),
                          child: Center(
                            child:  Obx(() {
                              {
                                if (onboardingController.imageFile.value != null) {
                                  return Image.file(onboardingController.imageFile.value!);
                                } else {
                                  return   Image.network(
                                      height: 120.h,
                                      width: MediaQuery.of(context).size.width-40.w,
                                      fit: BoxFit.fill,"https://content.hostgator.com/img/weebly_image_sample.png");
                                }
                              }
                            }),
                          )
                
                      )),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: onboardingController.nameController,
                        decoration: InputDecoration(
                          hintText: 'User Name',
                          hintStyle: TextStyle(color: Colors.white), // Set hint text color
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.4),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color when focused
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: onboardingController.addressController,
                        decoration: InputDecoration(
                          hintText: 'Address',
                          hintStyle: TextStyle(color: Colors.white), // Set hint text color
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.4),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color when focused
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: onboardingController.emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white), // Set hint text color
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.4),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color when focused
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: onboardingController.phoneController,
                        decoration: InputDecoration(
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Colors.white), // Set hint text color
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.4),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color when focused
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )
                
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                ),
                SizedBox(height: 5,),
                deliveryman?
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: onboardingController.shopNameController,
                        decoration: InputDecoration(
                          hintText: 'Shop name to add',
                          hintStyle: TextStyle(color: Colors.white), // Set hint text color
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.4),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // Set border color when focused
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      )

                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                ):SizedBox(),

                SizedBox(height: 5,),
                Obx(()=>InkWell(
                  onTap:onboardingController.shopadding.value?null: ()async {
                    if(deliveryman)
                      {
                        print("sdjkfjskjdfkjs: ${shopController.shopNames.toString()}");
                        String? shopId = shopController.shopList.firstWhere((shop) => shop.name.toString().toLowerCase().trim()
                            == onboardingController.shopNameController.text.toString().toLowerCase().trim(), orElse: () => null)?.id;

                        if( shopController.shopNames.contains(onboardingController.shopNameController.text.toString())==false)
                        {
                          Fluttertoast.showToast(
                              msg: "Try an existing shop name ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                    else if(shopId==null || shopId=="")
                    {
                      Fluttertoast.showToast(
                          msg: "Shop id not found ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                        else{
                          onboardingController.shopIdforDM=shopId;
                          await onboardingController.completeProfile(deliveryMan:deliveryman );
                          onboardingController.clearFields();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LauncherPage(),
                              ));
                        }
                      }

                    else if(onboardingController.allOk())
                    {
                      await onboardingController.completeProfile(deliveryMan:deliveryman );
                      onboardingController.clearFields();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LauncherPage(),
                          ));
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Insert all fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                  },
                  child: Container(
                    height: 40.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(child: onboardingController.shopadding.value?
                    Center(child: Image.asset("images/load.gif"),):
                    Text("Complete Profile",style: TextStyle(
                        fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                    ),
                    ),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ):
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Complete your profile as", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        onboardingController.collectionName.value="users";
                        user=true;
                        shopkeepr=false;
                        deliveryman=false;
                      });
                    },
                    child: Card(
                      color: ColorHelper.userThemeColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100.h,width: 200.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outlined),
                              Text("User (Consumer)")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        onboardingController.collectionName.value="shopkeepers";
                        shopkeepr=true;
                        user=false;
                        deliveryman=false;
                      });
                    },
                    child: Card(
                      color: ColorHelper.shopKeeperThemeColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100.h,width: 200.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined),
                              Text("Shop Keeper")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        onboardingController.collectionName.value="deliveryman";
                        shopkeepr=false;
                        user=false;
                        deliveryman=true;
                      });
                    },
                    child: Card(
                      color: ColorHelper.shopKeeperThemeColor.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100.h,width: 200.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delivery_dining),
                              Text("Delivery Man")
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
