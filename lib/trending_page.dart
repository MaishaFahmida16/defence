import 'package:firebase/repository/shop_repo.dart';
import 'package:firebase/shopAdd.dart';
import 'package:firebase/shopdetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'const/color_helper.dart';
import 'controller/onboarding_controller.dart';
import 'controller/shop_controller.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  int hour=0;
  ShopController shopController= Get.put(ShopController());
  OnboardingController onboardingController= Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
          onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
          toolbarHeight: 10,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: "Shops",),
              Tab(text: "Foods",)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height-100.h,
              width: MediaQuery.of(context).size.width,
              color:Colors.white,
              child: Column(
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height-160.h,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Obx(()=>ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: shopController.trendyshopList.value.length, // Example list length
                        itemBuilder: (context, index) {
                          var shop=shopController.trendyshopList[index];
                          return InkWell(
                            onTap: (){
                              shopController.selectedtrendyShop.value=index;
                              if(onboardingController.usertype.value!='shopkeepers')
                              {
                                int clicks=shop.visited==null?0:shop.visited+1;
                                ShopRepository().updateShopClick(shop.name, clicks);
                                Get.to(ShopDetail());
                              }

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width-40.w,
                                decoration: BoxDecoration(
                                    color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                    onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Column(
                                  children: [
                                    Container(
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
                                            child: Image.network(
                                              shop.image, fit: BoxFit.fill,))),
                                    SizedBox(height: 8.h,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width:140.w,
                                            child: Text(shop.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                          ),
                                          Row(
                                            children: [
                                              Text('${shop.reviews.length} Reviews',style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                              SizedBox(width: 15.w,),
                                              Text(shop.foods.length.toString(),style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                              Icon(Icons.emoji_food_beverage_outlined,size:18.sp,color: Colors.white,),
                                              SizedBox(width: 15.w,),
                                              Text("5",style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                              Icon(Icons.star_border,size:18.sp,color: Colors.white,),

                                            ],
                                          )

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height-100.h,
              width: MediaQuery.of(context).size.width,
              color:Colors.white,
              child: Column(
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height-160.h,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Obx(()=>ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: shopController.trendyFoodList.value.length, // Example list length
                        itemBuilder: (context, index) {
                          var food=shopController.trendyFoodList[index];
                          return InkWell(
                            onTap: (){
                              // shopController.selectedtrendyShop.value=index;
                              // if(onboardingController.usertype.value!='shopkeepers')
                              // {
                              //   int clicks=shop.visited==null?0:shop.visited+1;
                              //   ShopRepository().updateShopClick(shop.name, clicks);
                              //   Get.to(ShopDetail());
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width-40.w,
                                decoration: BoxDecoration(
                                    color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                    onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Column(
                                  children: [
                                    Container(
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
                                            child: Image.network(
                                              food.foodImage, fit: BoxFit.fill,))),
                                    SizedBox(height: 8.h,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width:140.w,
                                            child: Text(food.foodName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                          ),
                                          Row(
                                            children: [
                                              Text('${food.reviews==null?0:food.reviews.length} Reviews',style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                              SizedBox(width: 15.w,),
                                              Text(food.ordered==null?"0":food.ordered.toString(),style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                              Icon(Icons.delivery_dining,size:18.sp,color: Colors.white,),
                                              SizedBox(width: 15.w,),
                                              Text("5",style: TextStyle(
                                                  fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                              ),),
                                              Icon(Icons.star_border,size:18.sp,color: Colors.white,),

                                            ],
                                          )

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
