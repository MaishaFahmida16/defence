import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/repository/shop_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'const/color_helper.dart';
import 'models/order_model.dart';
import 'models/shop_model.dart';

class FoodDetail extends StatefulWidget {
  const FoodDetail({Key? key}) : super(key: key);

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  ShopController shopController=Get.put(ShopController());
  OnboardingController onboardingController=Get.put(OnboardingController());
  double ratingValue=0;
  Food? food;
  @override
  void initState() {
    food=  shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value];

    ratingValue=(shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].rating/
        shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].ratedBy);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Food Detail',
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
                                        shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].foodImage.toString()),
                                  ),
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
                                        shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].foodName,
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
                                  initialRating:ratingValue,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) async{
                                    var food=shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value];
                                    int rat= (food.rating+rating).floor();
                                    int ratby= (food.ratedBy+1).floor();
                                    await ShopRepository().updateFoodIntegers(fieldName: "rating",
                                        shopName: shopController.shopList[shopController.selectedShop.value].name,
                                        foodName: food.foodName, value: rat);
                                    await ShopRepository().updateFoodIntegers(fieldName: "rated_by",
                                        shopName: shopController.shopList[shopController.selectedShop.value].name,
                                        foodName: food.foodName, value: ratby);

                                    ratingValue= (shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].rating/
                                        shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].ratedBy).floorToDouble();
                                    print(ratingValue.toString());
                                  },
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),food!.deliveryOn!?
                    Text("Delivery available"):
                    Text("Delivery is not available"),
                    SizedBox(height: 20.h,),
                    const Text("Reviews"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-20,
                      child:  ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount:shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].reviews==null?0:
                        shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].reviews.length,
                        itemBuilder: (context, index) {
                          var food=shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].reviews[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 50.h,width: 200.w,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Center(child: Text(food.toString(),style: TextStyle(fontSize: 18.sp),))),
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
                            ShopRepository().addReviewToFood(shopController.shopList[shopController.selectedShop.value].name,
                                shopController.shopList[shopController.selectedShop.value].foods[shopController.selectedFood.value].foodName,
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
