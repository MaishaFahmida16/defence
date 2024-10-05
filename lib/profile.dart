import 'package:firebase/auth_service.dart';
import 'package:firebase/bottomScreen.dart';
import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/login/Pages/loginPage.dart';
import 'package:firebase/manage_shop.dart';
import 'package:firebase/repository/shop_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'const/color_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  OnboardingController onboardingController=Get.put(OnboardingController());
  ShopController shopController=Get.put(ShopController());
  bool addingShop=false;
  @override
  void initState() {
    shopController.getOrderList();
    //onboardingController.getProfile();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
        toolbarHeight: 20.h,
      ),
      body: SingleChildScrollView(
        child:AuthService.user!=null && AuthService.user!.email.toString()=="admin@gmail.com"?
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("This is an Admin Account",style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 15.h,),
                    Card(
                      child: InkWell(
                        onTap: () async{
                          onboardingController.userProfile.clear();
                          onboardingController.usertype.value='';
                          await onboardingController.logout();
                          shopController.myShop.clear();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const LoginScreen(),
                              ));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(
                                    12
                                )
                            ),
                            height: 40.h,
                            width: MediaQuery.of(context).size.width-160.w,
                            child: Center(
                                child:
                                Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18.sp),))),
                      ),
                    ),
                  ],
                ),
              ),
            ):
        Obx(()=>
            Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 400.h,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 100.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                    onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,

                  ),
                ),
                Positioned(
                  top: 20.h,
                  right:10,
                  left: 10,
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            15
                        ),
                      ),
                      child:Obx(()=> onboardingController.userProfile.value.isEmpty?
                      Center(child: Column(
                        children: [
                          Text("Loading....."),
                          Card(
                            child: InkWell(
                              onTap: () async{
                                onboardingController.userProfile.clear();
                                onboardingController.usertype.value='';
                                await onboardingController.logout();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginScreen(),
                                    ));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                          12
                                      )
                                  ),
                                  height: 40.h,
                                  width: MediaQuery.of(context).size.width-160.w,
                                  child: Center(
                                      child:
                                      Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18.sp),))),
                            ),
                          ),
                        ],
                      ),):
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h,),
                          CircleAvatar(
                            radius: 70.sp,
                            backgroundImage: NetworkImage(onboardingController.userProfile[0].image),
                          ),
                          SizedBox(height: 8.h,),
                          Container(
                              decoration: BoxDecoration(
                                  color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                  onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                  borderRadius: BorderRadius.circular(
                                      12
                                  )
                              ),
                              height: 40.h,
                              width: MediaQuery.of(context).size.width-120.w,
                              child: Center(child: Text("Name: ${onboardingController.userProfile[0].name}",style: TextStyle(color: Colors.white,fontSize: 20.sp),))),
                          SizedBox(height: 8.h,),
                          Container(
                              decoration: BoxDecoration(
                                  color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                  onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                  borderRadius: BorderRadius.circular(
                                      12
                                  )
                              ),
                              height: 40.h,
                              width: MediaQuery.of(context).size.width-120.w,
                              child: Center(child: SizedBox(
                                width: 200.w,
                                  child: Text("Email: ${onboardingController.userProfile[0].email}",overflow:TextOverflow.ellipsis,maxLines:1,style: TextStyle( color: Colors.white,fontSize: 20.sp),)))),
                          SizedBox(height: 8.h,),
                          Container(
                              decoration: BoxDecoration(
                                  color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                  onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                  borderRadius: BorderRadius.circular(
                                      12
                                  )
                              ),
                              height: 40.h,
                              width: MediaQuery.of(context).size.width-120.w,
                              child: Center(child: Text("Phone: ${onboardingController.userProfile[0].phone}",style: TextStyle(color: Colors.white,fontSize: 20.sp),))),
                          SizedBox(height: 8.h,),
                          Card(
                            child: InkWell(
                              onTap: () async{
                                onboardingController.userProfile.clear();
                                onboardingController.usertype.value='';
                                await onboardingController.logout();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginScreen(),
                                    ));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                          12
                                      )
                                  ),
                                  height: 40.h,
                                  width: MediaQuery.of(context).size.width-160.w,
                                  child: Center(
                                      child:
                                      Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18.sp),))),
                            ),
                          ),
                          SizedBox(height: 20.h,),

                        ],
                      )),
                    ),
                  ),
                ),

              ],
            ),
            // if( onboardingController.usertype.value=='shopkeepers' &&  shopController.myShop.isNotEmpty)
            //   Card(
            //     child: InkWell(
            //       onTap: (){
            //         Get.to(ManageShopDetail());
            //       },
            //       child: Container(
            //           decoration: BoxDecoration(
            //               color: Colors.black,
            //               borderRadius: BorderRadius.circular(
            //                   12
            //               )
            //           ),
            //           height: 40.h,
            //           width: MediaQuery.of(context).size.width-160.w,
            //           child: Center(
            //               child:
            //               Text("Manage Your Shop",style: TextStyle(color: Colors.white,fontSize: 18.sp),))),
            //     ),
            //   )
            //
            // else if(onboardingController.usertype.value=='shopkeepers' && addingShop)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //
            //       Container(
            //         height: 50.h,
            //         width: MediaQuery.of(context).size.width,
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text("Expand your business by adding",style: TextStyle(
            //               fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
            //           ),),
            //
            //         ),
            //         decoration: BoxDecoration(
            //             color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
            //             onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
            //             borderRadius: BorderRadius.only(
            //                 bottomLeft: Radius.circular(15),
            //                 bottomRight: Radius.circular(15)
            //             )
            //         ),
            //       ),
            //       SizedBox(height: 20,),
            //       InkWell(
            //         onTap: () async{
            //           await shopController.pickImage();
            //         },
            //         child: Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.only(
            //                     topRight: Radius.circular(15),
            //                     topLeft: Radius.circular(15)
            //                 )
            //             ),
            //             height: 120.h,
            //             width: MediaQuery.of(context).size.width-0.w,
            //             child: ClipRRect(
            //                 borderRadius: BorderRadius.only(
            //                     topRight: Radius.circular(15),
            //                     topLeft: Radius.circular(15)
            //                 ),
            //                 child: Center(
            //                   child:  Obx(() {
            //                     {
            //                       if (shopController.imageFile.value != null) {
            //                         return Image.file(shopController.imageFile.value!);
            //                       } else {
            //                         return   Image.network(
            //                             height: 120.h,
            //                             width: MediaQuery.of(context).size.width-40.w,
            //                             fit: BoxFit.fill,"https://content.hostgator.com/img/weebly_image_sample.png");
            //                       }
            //                     }
            //                   }),
            //                 )
            //
            //             )),
            //       ),
            //       SizedBox(height: 20,),
            //       Container(
            //         height: 50.h,
            //         width: MediaQuery.of(context).size.width,
            //         child: Padding(
            //             padding: const EdgeInsets.all(5.0),
            //             child: TextField(
            //               controller: shopController.nameController,
            //               decoration: InputDecoration(
            //                 hintText: 'Shop Name',
            //                 hintStyle: TextStyle(color: Colors.white), // Set hint text color
            //                 filled: true,
            //                 fillColor: Colors.black.withOpacity(0.4),
            //                 enabledBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.white), // Set border color
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.white), // Set border color when focused
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ),
            //               ),
            //             )
            //
            //         ),
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //                 bottomLeft: Radius.circular(15),
            //                 bottomRight: Radius.circular(15)
            //             )
            //         ),
            //       ),
            //       SizedBox(height: 5,),
            //       Container(
            //         height: 50.h,
            //         width: MediaQuery.of(context).size.width,
            //         child: Padding(
            //             padding: const EdgeInsets.all(5.0),
            //             child: TextField(
            //               controller: shopController.addressController,
            //               decoration: InputDecoration(
            //                 hintText: 'Address',
            //                 hintStyle: TextStyle(color: Colors.white), // Set hint text color
            //                 filled: true,
            //                 fillColor: Colors.black.withOpacity(0.4),
            //                 enabledBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.white), // Set border color
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.white), // Set border color when focused
            //                   borderRadius: BorderRadius.circular(10.0),
            //                 ),
            //               ),
            //             )
            //
            //         ),
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //                 bottomLeft: Radius.circular(15),
            //                 bottomRight: Radius.circular(15)
            //             )
            //         ),
            //       ),
            //       SizedBox(height: 5,),
            //       Obx(()=>InkWell(
            //         onTap: ()async {
            //           await shopController.addNewShop(true);
            //           shopController.clearFields();
            //           Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     BottomNavScreen(),
            //               ));
            //         },
            //         child: Container(
            //           height: 40.h,
            //           width: 90.w,
            //           decoration: BoxDecoration(
            //               color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
            //               onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
            //               borderRadius: BorderRadius.circular(15)
            //           ),
            //           child: Center(child: shopController.shopadding.value?
            //           Center(child: Image.asset("images/load.gif"),):
            //           Text("Submit",style: TextStyle(
            //               fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
            //           ),
            //           ),
            //           ),
            //         ),
            //       ))
            //     ],
            //   )
            // else if(onboardingController.usertype.value=='shopkeepers' && addingShop==false)
            //     Card(
            //       color: Colors.white,
            //       child: SizedBox(
            //         height: 200.h,
            //         width: 325.w,
            //         child: Center(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text("You don't have any shop now"),
            //               SizedBox(height: 20.h,),
            //               Icon(Icons.add,size: 50,),
            //               InkWell(
            //                 onTap: (){
            //                   setState(() {
            //                     addingShop=true;
            //                   });
            //                 },
            //                 child: Container(
            //                     decoration: BoxDecoration(
            //                         color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
            //                         onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
            //                         borderRadius: BorderRadius.circular(
            //                             12
            //                         )
            //                     ),
            //                     height: 40.h,
            //                     width: 300.w,
            //                     child: Center(
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Text("Add your shop and get orders",style: TextStyle(color: Colors.white,fontSize: 20.sp),),
            //                       ),
            //                     )),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     )
            // else
            //   SizedBox(),

            SizedBox(height: 10.h,),
        Obx(()=>onboardingController.usertype=="shopkeepers" && shopController.myShop.isNotEmpty?
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(14.r)
                    ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total Sell: ${shopController.myShop[0].totalSell}",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12.sp),),
                    )),
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(14.r)
                    ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total Delivery: ${shopController.myShop[0].totalDelivery}",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12.sp),),
                    )),
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(14.r)
                    ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Platform Fee: ${shopController.myShop[0].platformFee} ৳",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12.sp),),
                    )),
                  ),
                ],
              ),
            ):SizedBox()
        ),
            Text(onboardingController.usertype=="users"?"Order History":""),
            Obx(()=>onboardingController.usertype=="users"?
            SizedBox(
              width: MediaQuery.of(context).size.width-20,
              child: shopController.myorderList.length==0? Center(child: Text("No order added"),):
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: shopController.myorderList.length,
                itemBuilder: (context, index) {
                  var order=shopController.myorderList[index];
                  return SizedBox(
                    width: 350.w,
                    height: 140.h,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                        child: Center(
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all( 4.0),
                                  child: Container(
                                    width: 100,  // Set the desired width
                                    height: 140,
                                    decoration:  BoxDecoration(
                                        color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12))),
                                    child: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: order.foods.length <= 2 ? 1 :2 ,
                                        childAspectRatio: 1.0,
                                      ),
                                      itemCount: order.foods.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(order.foods[index].foodImage.toString(), fit: BoxFit.cover,),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${order.datetime.toString().substring(0,11)} : ${order.datetime.toString().substring(11,16)} ",style: TextStyle(color: Colors.white),),
                                      Text("Estimated Delivery: 10 minutes",style: TextStyle(color: Colors.white),),
                                      Text("Preparing Time: ${order.prepareTime.toString()} minutes",style: TextStyle(color: Colors.white),),
                                      // Text("Delivery Status: "+order.prepareTime!=null?"Food Preparing":
                                      // order.accepted?"Accepted" :order.delivered?"Delivered":""
                                      //   ,style: TextStyle(color: Colors.white),),

                                      order.shopCancel?Text("Order Canceled "):SizedBox(),
                                      order.userCancel?Text("Order Canceled "):SizedBox(),
                                      order.delivered?Text("Order Delivered"):SizedBox(),
                                      Row(
                                        children: [
                                         order.delivered ||  order.accepted ||  order.shopCancel || order.userCancel?SizedBox():  ElevatedButton(onPressed: (){
                                            ShopRepository().updateOrderBool(order.orderId, "userCancel", true);
                                          }, child: Text("Cancel Order"))
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ):onboardingController.usertype=="deliveryman"?
            Container(
              height: 50.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(14.r)
              ),
              child: Center(child: Text("Total Earning: ${onboardingController.userProfile[0].income} ৳",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
            ):
            SizedBox()),
          ],
        ),)
      ),
    );
  }
}
