import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/repository/shop_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'const/color_helper.dart';
import 'models/shop_model.dart';

class ManageShopDetail extends StatefulWidget {
  const ManageShopDetail({Key? key}) : super(key: key);

  @override
  State<ManageShopDetail> createState() => _ManageShopDetailState();
}

class _ManageShopDetailState extends State<ManageShopDetail> {
  ShopController shopController=Get.put(ShopController());
  OnboardingController onboardingController=Get.put(OnboardingController());
  int thisrating=0;
  int rated=0;
  int tab=0;
  String selectedCat="Snacks";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Shop',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 19.sp,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: ColorHelper.shopKeeperThemeColor,
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
                          color: ColorHelper.shopKeeperThemeColor,
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
                                            shopController.myShop[0].image.toString()),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.h,
                                        right: 10.w,
                                        child: InkWell(
                                          onTap: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Edit your shop'),
                                                  content: SizedBox(
                                                    height: 200.h,
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
                                                                      hintText: 'Shop name',
                                                                      hintStyle: TextStyle(color: Colors.white), // Set hint text color
                                                                      filled: false,
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
                                                        if(shopController.nameController.text!='' && shopController.imageFile!=null)
                                                          {
                                                            Navigator.of(context).pop(); // Close the dialog
                                                            String image= await shopController.uploadImageToFirestore(shopController.imageFile.value!);
                                                            await ShopRepository().updateShop(shopController.myShop[0].name!,
                                                                shopController.nameController.text,
                                                                image);
                                                            shopController.clearFields();
                                                          }
                                                        else{
                                                          Fluttertoast.showToast(
                                                            msg: "Insert all fields",
                                                            toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be shown
                                                            gravity: ToastGravity.BOTTOM, // Position of the toast message
                                                            timeInSecForIosWeb: 1, // Duration for iOS and web
                                                            backgroundColor: Colors.black, // Background color of the toast message
                                                            textColor: Colors.white, // Text color of the toast message
                                                            fontSize: 16.0, // Font size of the toast message
                                                          );
                                                        }

                                                      },
                                                      child: Text('Edit'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(90)
                                            ),
                                              child: Icon(Icons.edit_outlined)),
                                        )
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
                                        shopController.myShop[0].name!,
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
                    Divider(thickness: 2,color: ColorHelper.shopKeeperThemeColor,),
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
                                    colors: tab==index? [ColorHelper.shopKeeperThemeColor, ColorHelper.shopKeeperThemeColor.withOpacity(0.5)]:[Colors.grey, Colors.grey],
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
                    Obx(()=>shopController.myShop[0].foods!.length==0? Center(child: Text("No food added"),):SizedBox(
                      height: 250.h,
                      width: MediaQuery.of(context).size.width-20,
                      child:  ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shopController.myShop[0].foods!.length,
                        itemBuilder: (context, index) {
                          var food=shopController.myShop[0].foods![index];
                          return SizedBox(
                            width: 250.w,
                            height: 200.h,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: ColorHelper.shopKeeperThemeColor,
                                child: Center(
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 130.h,
                                          width: 250.w,
                                          decoration: const BoxDecoration(
                                              color: ColorHelper.shopKeeperThemeColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12))),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12)),
                                            child: Image.network(
                                                fit: BoxFit.fill,
                                                height: 130.h,
                                                width: 250.w,
                                                food.foodImage.toString()),
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    food.foodName!,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Inter',
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  Text(
                                                    food.price==null?"N/A":food.price.toString()!+"৳",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Inter',
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Total order: ${food.ordered??0.toString()}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Inter',
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(0.0),
                                                    width: 30.0,
                                                    child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        constraints: BoxConstraints(),
                                                        onPressed: (){
                                                      ShopRepository().deleteFood(
                                                          shopName: shopController.myShop[0].name!,
                                                          foodName: shopController.myShop[0].foods![index].foodName!);
                                                    }, icon: Icon(Icons.delete_outline)),
                                                  )
                                                ],
                                              ),
                                             // SizedBox(height: 10.h,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Delivery available",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Inter',
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                          SizedBox(
                                            height: 20.h,width: 30.w,
                                            child: Switch(
                                              activeColor: Colors.green,
                                              activeTrackColor: Colors.white,
                                              value: food.deliveryOn==null?false:food.deliveryOn!,
                                              onChanged: (value) {
                                                setState(() {
                                                  ShopRepository().updateFoodIDeliveryStat(
                                                      shopName: shopController.myShop[0].name!,
                                                      foodName: shopController.myShop[0].foods![index].foodName!,
                                                      value: value);
                                                });
                                              },
                                            ),
                                          ),
                                                  SizedBox(width: 1.w,)
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),



                                      ],
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
                      Obx(()=>shopController.myShop[0].foods!.length==0? Center(child: Text("No food added"),):SizedBox(
                        height: 250.h,
                        width: MediaQuery.of(context).size.width-20,
                        child:  ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: shopController.myShop[0].foods!.length,
                          itemBuilder: (context, index) {
                            var food=shopController.myShop[0].foods![index];
                            return food.category==null || food.category!=shopController.foodCatTabs[tab] ?SizedBox(): SizedBox(
                              width: 250.w,
                              height: 200.h,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: ColorHelper.shopKeeperThemeColor,
                                  child: Center(
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 130.h,
                                            width: 250.w,
                                            decoration: const BoxDecoration(
                                                color: ColorHelper.shopKeeperThemeColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12))),
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12)),
                                              child: Image.network(
                                                  fit: BoxFit.fill,
                                                  height: 130.h,
                                                  width: 250.w,
                                                  food.foodImage.toString()),
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
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      food.foodName!,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Inter',
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    Text(
                                                      food.price==null?"N/A":food.price.toString()!+"৳",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Inter',
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Total order: ${food.ordered??0.toString()}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Inter',
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.all(0.0),
                                                      width: 30.0,
                                                      child: IconButton(
                                                          padding: EdgeInsets.zero,
                                                          constraints: BoxConstraints(),
                                                          onPressed: (){
                                                            ShopRepository().deleteFood(
                                                                shopName: shopController.myShop[0].name!,
                                                                foodName: shopController.myShop[0].foods![index].foodName!);
                                                          }, icon: Icon(Icons.delete_outline)),
                                                    )
                                                  ],
                                                ),
                                                // SizedBox(height: 10.h,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Delivery available",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Inter',
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                    SizedBox(
                                                      height: 20.h,width: 30.w,
                                                      child: Switch(
                                                        activeColor: Colors.green,
                                                        activeTrackColor: Colors.white,
                                                        value: food.deliveryOn==null?false:food.deliveryOn!,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            ShopRepository().updateFoodIDeliveryStat(
                                                                shopName: shopController.myShop[0].name!,
                                                                foodName: shopController.myShop[0].foods![index].foodName!,
                                                                value: value);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 1.w,)
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),



                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-30.w,
                      height: 40.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorHelper.shopKeeperThemeColor, // Change to red color
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
                                  height: 310.h,
                                  child: SingleChildScrollView(
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 50.h,
                                                  width: 110.w,
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        controller: shopController.priceController,
                                                        decoration: InputDecoration(
                                                          hintText: 'Price ৳',
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
                                                Container(
                                                  height: 50.h,
                                                  width: 110.w,
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: TextField(
                                                        controller: shopController.discountController,
                                                        keyboardType: TextInputType.number,
                                                        decoration: InputDecoration(
                                                          hintText: 'Discount %',
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
                                                )
                                              ],
                                            ),
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
                                      Navigator.of(context).pop(); // Close the dialog
                                      String image= await shopController.uploadImageToFirestore(shopController.imageFile.value!);
                                      await ShopRepository().addFoodToShop(shopController.myShop[0].name!,
                                          Food(
                                              foodName: shopController.nameController.text,
                                              foodImage: image??'',
                                            reviews: [],
                                            ratedBy: 0,
                                            rating: 0,
                                            visited: 0,
                                            price: int.parse(shopController.priceController.text),
                                            discount: int.parse(shopController.discountController.text),
                                            category: shopController.selectedCat.value,
                                            deliveryOn: false
                                          ));

                                      shopController.clearFields();

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
                    SizedBox(height: 10.h,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-20,
                      child:  ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: shopController.myShop[0].reviews!.length,
                        itemBuilder: (context, index) {
                          var food=shopController.myShop[0].reviews![index];
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
