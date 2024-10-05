import 'package:firebase/bottomScreen.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShopAddPage extends StatefulWidget {
  const ShopAddPage({Key? key}) : super(key: key);

  @override
  State<ShopAddPage> createState() => _ShopAddPageState();
}

class _ShopAddPageState extends State<ShopAddPage> {
  ShopController shopController=Get.put(ShopController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        toolbarHeight: 10,
        elevation: 0,
      ),
      body: Container(
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
                  child: Text("Contribute By Adding",style: TextStyle(
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
               await shopController.pickImage();
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
                            if (shopController.imageFile.value != null) {
                              return Image.file(shopController.imageFile.value!);
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
                    controller: shopController.nameController,
                    decoration: InputDecoration(
                      hintText: 'Shop Name',
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
                    controller: shopController.addressController,
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
            Obx(()=>InkWell(
              onTap: ()async {
                await shopController.addNewShop(false);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BottomNavScreen(),
                    ));
              },
              child: Container(
                height: 40.h,
                width: 90.w,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: shopController.shopadding.value?
                Center(child: Image.asset("images/load.gif"),):
                Text("Submit",style: TextStyle(
                    fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                ),
                ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
