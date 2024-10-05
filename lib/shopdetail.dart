import 'package:firebase/auth_service.dart';
import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/food_detail.dart';
import 'package:firebase/models/order_model.dart';
import 'package:firebase/repository/shop_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'const/color_helper.dart';
import 'models/shop_model.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({Key? key}) : super(key: key);

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  ShopController shopController=Get.put(ShopController());
  OnboardingController onboardingController=Get.put(OnboardingController());
  int thisrating=0;
  int rated=0;
  int tab=0;
  int orderIndex=0;
  bool ordering=false;
  String selectedCat="Snacks";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Shop Detail',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 19.sp,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
          onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          toolbarHeight: 22.h,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                          onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                          elevation: 2,
                          child: Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 210.h,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12))),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        child: Image.network(
                                            fit: BoxFit.fill,
                                            height: 210.h,
                                            width: 450.w,
                                            shopController.shopList[shopController.selectedShop.value].image.toString()),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: AuthService.user!.email=="admin@gmail.com"  && shopController.shopList[shopController.selectedShop.value].platformFee!=null
                                          && shopController.shopList[shopController.selectedShop.value].platformFee!=0?
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(color: Colors.black,
                                            borderRadius: BorderRadius.circular(12)),
                                        child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Clear Platform Due for this shop?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async{
                                                          Navigator.of(context).pop();
                                                         await ShopRepository().clearShopDue(shopController.shopList[shopController.selectedShop.value].id);
                                                          setState(() {

                                                          });
                                                        },
                                                        child: Text(
                                                          "Clear Due",
                                                          style: TextStyle(color: Colors.green), // Optional: make the text red
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Platform Due: ${shopController.shopList[shopController.selectedShop.value].platformFee??"0"}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                                SizedBox(width: 5.w,),
                                                Icon(Icons.error_outline,color: Colors.red,)
                                              ],
                                            ),
                                          ),
                                        ),),
                                      ):SizedBox(),
                                    )
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shopController.shopList[shopController.selectedShop.value].name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Inter',
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),


                                    ],
                                  ),
                                ),

                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(thickness: 2,color: onboardingController.usertype!="users"?ColorHelper.adminThemeColor: ColorHelper.userThemeColor,),
                    Obx(()=> SizedBox(
                      height: 35.h,
                      width: MediaQuery.of(context).size.width-20,
                      child: shopController.shopList[shopController.selectedShop.value].foods.length==0? Center(child: Text("No food added"),):
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shopController.foodCatTabs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async{
                             setState(() {
                               tab=index;
                             });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                width: 80.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: tab==index? onboardingController.usertype!="users"? [ColorHelper.adminThemeColor, ColorHelper.adminThemeColor.withOpacity(0.5)]:[ColorHelper.userThemeColor, ColorHelper.userThemeColor.withOpacity(0.5)]:[Colors.grey, Colors.grey],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp,
                                  ),
                                ),
                                child: Center(child: Text(shopController.foodCatTabs[index],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 14.sp),),),
                                // other properties like padding, margin, etc. can be added here
                              ),
                            ),
                          );
                        },
                      ),
                    )),

                   if(tab==0)
                   Obx(()=> SizedBox(
                     width: MediaQuery.of(context).size.width-20,
                     child: shopController.shopList[shopController.selectedShop.value].foods.length==0? Center(child: Text("No food added"),):
                     ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       scrollDirection: Axis.vertical,
                       itemCount: shopController.shopList[shopController.selectedShop.value].foods.length,
                       itemBuilder: (context, index) {
                         var food=shopController.shopList[shopController.selectedShop.value].foods[index];
                         return InkWell(
                           onTap: () async{
                             shopController.selectedFood.value=index;
                             Get.to(FoodDetail());
                             await ShopRepository().updateFoodIntegers(
                                 fieldName: "visited",
                                 shopName: shopController.shopList[shopController.selectedShop.value].name,
                                 foodName: food.foodName, value: 1);
                           },
                           child: SizedBox(
                             width: 250.w,
                             height: 140.h,
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Card(
                                 color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
    onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                 child: Center(
                                   child: SizedBox(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Column(
                                                 mainAxisAlignment:
                                                 MainAxisAlignment.start,
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment.start,
                                                 children: [
                                                   Text(
                                                     food.foodName!,
                                                     style: TextStyle(
                                                         color: Colors.white,
                                                         fontFamily: 'Inter',
                                                         fontSize: 15.sp,
                                                         fontWeight: FontWeight.w700),
                                                   ),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     children: [

                                                       Text(
                                                         food.price==null?"N/A":food.price.toString()!+"৳    ${food.discount!=null?food.discount.toString()+"% off":""}",
                                                         style: TextStyle(
                                                             color: Colors.white,
                                                             fontFamily: 'Inter',
                                                             fontSize: 15.sp,
                                                             fontWeight: FontWeight.w700),
                                                       ),
                                                     ],
                                                   ),

                                                 ],
                                               ),

                                               RatingBar.builder(
                                                 itemSize: 18.sp,
                                                 initialRating: 0,
                                                 minRating: 1,
                                                 direction: Axis.horizontal,
                                                 allowHalfRating: false,
                                                 itemCount: 5,
                                                 itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                 itemBuilder: (context, _) => Icon(
                                                   Icons.star,
                                                   color: Colors.amber,
                                                 ), onRatingUpdate: (double value) {  },
                                               ),
                                               SizedBox(height: 5.h,),
                                               Text(
                                                 "Ordered: ${food.ordered??0.toString()} times",
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontFamily: 'Inter',
                                                     fontSize: 15.sp,
                                                     fontWeight: FontWeight.w700),
                                               ),
                                               SizedBox(height: 5.h,),
                                               food.deliveryOn!=null && food.deliveryOn?
                                                   SizedBox():
                                               Text("Delivery is not available")
                                             ],
                                           ),
                                         ),
                                         Stack(
                                           children: [
                                             Container(
                                               height: 140.h,
                                               width: 140.w,
                                               decoration:  BoxDecoration(
                                                   color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                   onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                   borderRadius: BorderRadius.only(
                                                       bottomRight: Radius.circular(12),
                                                       topRight: Radius.circular(12))),
                                               child: ClipRRect(
                                                 borderRadius: const BorderRadius.only(
                                                     bottomRight: Radius.circular(12),
                                                     topRight: Radius.circular(12)),
                                                 child: Image.network(
                                                     fit: BoxFit.fill,
                                                     height: 80.h,
                                                     width: 100.w,
                                                     food.foodImage.toString()),
                                               ),
                                             ),
                                             Positioned(
                                               top: 5.h,right: 5.w,
                                                 child:AuthService.user!.email=="admin@gmail.com"?
                                             Container(
                                               padding: const EdgeInsets.all(0.0),
                                               width: 50.w,
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(90),
                                                 color: Colors.white.withOpacity(0.4)
                                               ),
                                               child: IconButton(
                                                   padding: EdgeInsets.zero,
                                                   constraints: BoxConstraints(),
                                                   onPressed: (){
                                                     ShopRepository().deleteFood(
                                                         shopName: shopController.shopList[shopController.selectedShop.value].name!,
                                                         foodName: food.foodName!);
                                                   }, icon: Icon(Icons.delete_outline,color: Colors.white,)),
                                             ): SizedBox()),
                                             Positioned(
                                               bottom: 5,
                                                 right: 5,
                                                 child: food.deliveryOn!=null && food.deliveryOn?
                                                 Obx(()=>InkWell(
                                                   onTap: (){
                                                     shopController.tempOrderFooods.contains(food)?shopController.tempOrderFooods.remove(food):
                                                     shopController.tempOrderFooods.add(food);
                                                   },
                                                   child: Container(
                                                     height: 40.h,width: 40.h,
                                                     decoration: BoxDecoration(
                                                         color: Colors.black.withOpacity(0.5),
                                                         borderRadius: BorderRadius.circular(10)
                                                     ),
                                                     child:  Padding(
                                                       padding: const EdgeInsets.all(4.0),
                                                       child: Center(child: Icon(shopController.tempOrderFooods.contains(food)?Icons.remove_shopping_cart_outlined:Icons.add_shopping_cart,color: Colors.white,size: 30.sp,),),
                                                     ),
                                                   ),
                                                 )):SizedBox())

                                           ],
                                         ),


                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         );
                       },
                     ),
                   ))
                    else
                     Obx(()=> SizedBox(
                       width: MediaQuery.of(context).size.width-20,
                       child: shopController.shopList[shopController.selectedShop.value].foods.length==0? Center(child: Text("No food added"),):
                       ListView.builder(
                         scrollDirection: Axis.vertical,
                         physics: NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: shopController.shopList[shopController.selectedShop.value].foods.length,
                         itemBuilder: (context, index) {
                           var food=shopController.shopList[shopController.selectedShop.value].foods[index];
                           return food.category==null || food.category!=shopController.foodCatTabs[tab] ?SizedBox():
                           InkWell(
                             onTap: () async{
                               shopController.selectedFood.value=index;
                               Get.to(FoodDetail());
                               await ShopRepository().updateFoodIntegers(
                                   fieldName: "visited",
                                   shopName: shopController.shopList[shopController.selectedShop.value].name,
                                   foodName: food.foodName, value: 1);
                             },
                             child: SizedBox(
                               width: 250.w,
                               height: 140.h,
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Card(
                                   color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                   onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                   child: Center(
                                     child: SizedBox(
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Column(
                                                   mainAxisAlignment:
                                                   MainAxisAlignment.start,
                                                   crossAxisAlignment:
                                                   CrossAxisAlignment.start,
                                                   children: [
                                                     Text(
                                                       food.foodName!,
                                                       style: TextStyle(
                                                           color: Colors.white,
                                                           fontFamily: 'Inter',
                                                           fontSize: 15.sp,
                                                           fontWeight: FontWeight.w700),
                                                     ),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                       children: [

                                                         Text(
                                                           food.price==null?"N/A":food.price.toString()!+"৳    ${food.discount!=null?food.discount.toString()+"% off":""}",
                                                           style: TextStyle(
                                                               color: Colors.white,
                                                               fontFamily: 'Inter',
                                                               fontSize: 15.sp,
                                                               fontWeight: FontWeight.w700),
                                                         ),
                                                       ],
                                                     ),

                                                   ],
                                                 ),

                                                 RatingBar.builder(
                                                   itemSize: 18.sp,
                                                   initialRating: 0,
                                                   minRating: 1,
                                                   direction: Axis.horizontal,
                                                   allowHalfRating: false,
                                                   itemCount: 5,
                                                   itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                   itemBuilder: (context, _) => Icon(
                                                     Icons.star,
                                                     color: Colors.amber,
                                                   ), onRatingUpdate: (double value) {  },
                                                 ),
                                                 SizedBox(height: 5.h,),
                                                 Text(
                                                   "Ordered: ${food.ordered??0.toString()} times",
                                                   style: TextStyle(
                                                       color: Colors.white,
                                                       fontFamily: 'Inter',
                                                       fontSize: 15.sp,
                                                       fontWeight: FontWeight.w700),
                                                 ),
                                                 SizedBox(height: 5.h,),
                                                 food.deliveryOn!=null && food.deliveryOn?
                                                 SizedBox():
                                                 Text("Delivery is not available")
                                               ],
                                             ),
                                           ),
                                           Stack(
                                             children: [
                                               Container(
                                                 height: 140.h,
                                                 width: 140.w,
                                                 decoration:  BoxDecoration(
                                                     color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                     onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                     borderRadius: BorderRadius.only(
                                                         bottomRight: Radius.circular(12),
                                                         topRight: Radius.circular(12))),
                                                 child: ClipRRect(
                                                   borderRadius: const BorderRadius.only(
                                                       bottomRight: Radius.circular(12),
                                                       topRight: Radius.circular(12)),
                                                   child: Image.network(
                                                       fit: BoxFit.fill,
                                                       height: 80.h,
                                                       width: 100.w,
                                                       food.foodImage.toString()),
                                                 ),
                                               ),
                                               Positioned(
                                                   top: 5.h,right: 5.w,
                                                   child:AuthService.user!.email=="admin@gmail.com"?
                                                   Container(
                                                     padding: const EdgeInsets.all(0.0),
                                                     width: 50.w,
                                                     decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(90),
                                                         color: Colors.white.withOpacity(0.4)
                                                     ),
                                                     child: IconButton(
                                                         padding: EdgeInsets.zero,
                                                         constraints: BoxConstraints(),
                                                         onPressed: (){
                                                           ShopRepository().deleteFood(
                                                               shopName: shopController.shopList[shopController.selectedShop.value].name!,
                                                               foodName: food.foodName!);
                                                         }, icon: Icon(Icons.delete_outline,color: Colors.white,)),
                                                   ): SizedBox()),
                                               Positioned(
                                                   bottom: 5,
                                                   right: 5,
                                                   child: food.deliveryOn!=null && food.deliveryOn?
                                                   Obx(()=>InkWell(
                                                     onTap: (){
                                                       shopController.tempOrderFooods.contains(food)?shopController.tempOrderFooods.remove(food):
                                                       shopController.tempOrderFooods.add(food);
                                                     },
                                                     child: Container(
                                                       height: 40.h,width: 40.h,
                                                       decoration: BoxDecoration(
                                                           color: Colors.black.withOpacity(0.5),
                                                           borderRadius: BorderRadius.circular(10)
                                                       ),
                                                       child:  Padding(
                                                         padding: const EdgeInsets.all(4.0),
                                                         child: Center(child: Icon(shopController.tempOrderFooods.contains(food)?Icons.remove_shopping_cart_outlined:Icons.add_shopping_cart,color: Colors.white,size: 30.sp,),),
                                                       ),
                                                     ),
                                                   )):SizedBox())

                                             ],
                                           ),


                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                     )),

                  SizedBox(height: 15.h,),
                    Obx(()=>
                    shopController.tempOrderFooods.isNotEmpty?
                        SizedBox(
                      width: MediaQuery.of(context).size.width-30.w,
                      height: 120.h,
                      child: Obx(()=>Column(
                        children: [
                          shopController.tempOrderFooods.isNotEmpty?
                          Container(
                            height: 70.h,
                            width:MediaQuery.of(context).size.width-30.w ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.r),
                              color: Colors.black.withOpacity(0.4)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Price: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                      ,Text("Platform Fee: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                      ,Text("Delivery Fee: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                      ,Text("Total: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("${shopController.calculatePrice(shopController.tempOrderFooods)} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                      ,Text("10 ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                      ,Text("20 ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                      ,Text("${shopController.calculatePrice(shopController.tempOrderFooods)+30} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11,color: Colors.white),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ):SizedBox(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                              onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor, // Change to red color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: shopController.ordering.value?null: () async{
                              shopController.ordering.value=true;
                              await ShopRepository().makeOrder(
                                  OrderModel(
                                      orderId: '',
                                      userId: AuthService.user!.uid,
                                      userCancel: false,
                                      shopCancel: false,
                                      datetime: DateTime.now().toString(),
                                      shopId: shopController.shopList[shopController.selectedShop.value].id,
                                      status: '',
                                      address: onboardingController.userProfile.isEmpty?"":onboardingController.userProfile[0].address,
                                      distance: '100 meter',
                                      prepareTime: 0,
                                      accepted: false,
                                      onTheWay: false,
                                      delivered: false,
                                      foods: shopController.tempOrderFooods.cast<Food>()
                                  )
                              );
                              shopController.tempOrderFooods.clear();
                              shopController.ordering.value=false;
                            },
                            child: Text(shopController.ordering.value?"Placing Order":
                              'Order ${shopController.tempOrderFooods.length.toString()} Food Items',
                              style: TextStyle(color: Colors.white, fontSize: 15.h),
                            ),
                          ),
                        ],
                      ))
                      ,
                    ):SizedBox()),
                    SizedBox(height: 10.h,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-30.w,
                      height: 40.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
    onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor, // Change to red color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String cat="Select";
                              return AlertDialog(
                                title: Text('Add new food item'),
                                content: SizedBox(
                                  height: 280.h,
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

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
                                                    hintText: 'Food Name',
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
                                          SizedBox(height: 20,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Obx(()=> Text("Category: ${shopController.selectedCat.value}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),)),

                                              DropdownButton<String>(
                                                underline: const SizedBox(),
                                                value: cat,
                                                items: shopController.foodCat
                                                    .map((option) => DropdownMenuItem(
                                                  value: option,
                                                  child: Text(option),
                                                ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  shopController.selectedCat.value=value!;
                                                  setState(() {
                                                    selectedCat = value!;
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('Close'),
                                  ),
                                  TextButton(
                                    onPressed: () async{
                                     if( shopController.nameController.text!='' && shopController.imageFile!=null)
                                       {
                                         Navigator.of(context).pop(); // Close the dialog
                                         String image= await shopController.uploadImageToFirestore(shopController.imageFile.value!);
                                         await ShopRepository().addFoodToShop(shopController.shopList[shopController.selectedShop.value].name,
                                             Food(
                                               foodName: shopController.nameController.text,
                                               foodImage: image??'',
                                               deliveryOn: false,
                                               reviews: [],
                                               ratedBy: 0,
                                               rating: 0,
                                               visited: 0,
                                               category: shopController.selectedCat.value
                                             ));
                                         shopController.clearFields();
                                         onboardingController.clearFields();
                                     }
                                     else{
                                       Fluttertoast.showToast(
                                           msg: "Add image and name",
                                           toastLength: Toast.LENGTH_SHORT,
                                           gravity: ToastGravity.BOTTOM,
                                           timeInSecForIosWeb: 1,
                                           backgroundColor: Colors.black,
                                           textColor: Colors.white,
                                           fontSize: 16.0);

                                     }
                                    },
                                    child: Text('Add'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Add New Food Item ',
                          style: TextStyle(color: Colors.white, fontSize: 15.h),
                        ),
                      )
                      ,
                    ),
                    SizedBox(height: 20.h,),
                    const Text("Reviews"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-20,
                      child:  ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: shopController.shopList[shopController.selectedShop.value].reviews.length,
                        itemBuilder: (context, index) {
                          var food=shopController.shopList[shopController.selectedShop.value].reviews[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async{
                                await ShopRepository().updateFoodIntegers(
                                    fieldName: "visited",
                                    shopName: shopController.shopList[shopController.selectedShop.value].name,
                                    foodName: food.foodName, value: 1);
                              },
                              child: Container(
                                height: 40.h,width: 200.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Center(child:
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(food.toString(),style: TextStyle(fontSize: 15.sp),),
                                        AuthService.user!.email=="admin@gmail.com"?
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            onPressed: (){
                                              ShopRepository().deleteShopReview(
                                                  shopName: shopController.shopList[shopController.selectedShop.value].name!,
                                                  review: food.toString());
                                            }, icon: Icon(Icons.delete_outline,size:20.sp,color: Colors.black,)):SizedBox()
                                      ],
                                    ),
                                  ))),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h,),

                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50.h,
                            width: MediaQuery.of(context).size.width-125,
                            child: SizedBox(
                              width: 50.w,
                              child: TextField(
                                controller: shopController.reveiwController,
                                decoration: InputDecoration(
                                  hintText: 'write reveiw',
                                  hintStyle: TextStyle(color: Colors.white), // Set hint text color
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.2),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white), // Set border color
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white), // Set border color when focused
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)
                                )
                            ),
                          ),
                          ElevatedButton(onPressed: (){
                            ShopRepository().addReveiwToShop(shopController.shopList[shopController.selectedShop.value].name,
                                shopController.reveiwController.text
                            );
                            shopController.reveiwController.text='';
                          }, child: Text("Post"))
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
