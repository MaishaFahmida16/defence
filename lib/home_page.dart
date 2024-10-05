import 'package:firebase/auth_service.dart';
import 'package:firebase/const/color_helper.dart';
import 'package:firebase/controller/onboarding_controller.dart';
import 'package:firebase/controller/shop_controller.dart';
import 'package:firebase/launchePage.dart';
import 'package:firebase/login/Pages/loginPage.dart';
import 'package:firebase/login_page.dart';
import 'package:firebase/repository/OnBoardRepo.dart';
import 'package:firebase/repository/shop_repo.dart';
import 'package:firebase/shopAdd.dart';
import 'package:firebase/shopdetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bottomScreen.dart';
import 'chart.dart';
import 'manage_shop.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int hour=0;
  int tab=1;
  final TextEditingController searchController = TextEditingController();
ShopController shopController= Get.put(ShopController());
OnboardingController onboardingController= Get.put(OnboardingController());
  var _suggestions = [];
  bool myShopView=true;
  bool analyticsView=true;
  bool addingShop=false;

  void _onTextChanged() {
    setState(() {
      String searchValue = searchController.text.toLowerCase();
      print("srch" + _suggestions.length.toString());
      _suggestions = shopController.shopList
          .where((item) =>
      item.name.toString().toLowerCase().contains(searchValue.toLowerCase()) ||
          item.foods.any((food) =>
              food.foodName.toString().toLowerCase().contains(searchValue.toLowerCase())
          )
      ).toList();

    });
  }
@override
  void initState() {
  searchController.addListener(_onTextChanged);
  getData();
  onboardingController.getTotalUsers();
    // TODO: implement initState
    super.initState();
  }



  Future<void> getData()async{
    shopController.getShopList();
    await onboardingController.getProfile();
    if(onboardingController.usertype.value=="deliveryman" && onboardingController.userProfile[0].shopId!=null){
      shopController.makeDeliveryList(onboardingController.userProfile[0].shopId);
      shopController.DelShopId=onboardingController.userProfile[0].shopId;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
        toolbarHeight: 10,
        elevation: 0,
      ),
      body: onboardingController.usertype=="deliveryman"?
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                Text("Order History",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp,color: ColorHelper.shopKeeperThemeColor),),
                SizedBox(height: 20.h,),

                Text("Deliver from Shop ***",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp,color: ColorHelper.shopKeeperThemeColor),),
                SizedBox(height: 20.h,),
                Obx(()=>  Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width-20,
                    child: shopController.mydeliveryList.length==0? Center(child: Text("No delivery added"),):
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: shopController.mydeliveryList.length,
                      itemBuilder: (context, index) {
                        var order=shopController.mydeliveryList[index];
                        return  order.userCancel==false && order.shopCancel==false && (order.deliveryManId==null || order.deliveryManId==AuthService.user!.uid)?
                        SizedBox(
                          width: MediaQuery.of(context).size.width-20,
                          height: 250.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                              onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                              child: Center(
                                child: SizedBox(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 100.h,
                                        width: MediaQuery.of(context).size.width-20,
                                        decoration:  BoxDecoration(
                                            color:  ColorHelper.shopKeeperThemeColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12))),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12)),
                                          child:Container(
                                            height: 100.h,
                                            width: 300.w,
                                            decoration:  BoxDecoration(
                                                color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    bottomLeft: Radius.circular(12))),
                                            child: GridView.builder(
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: order.foods.length < 2 ? 1 :2 ,
                                                childAspectRatio: 1.0,
                                              ),
                                              itemCount: order.foods.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: const EdgeInsets.all(1.0),
                                                    child:Stack(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.black),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Image.network(width:150.w,height:160.h,order.foods[index].foodImage.toString(), fit: BoxFit.cover,)),
                                                        ),
                                                        Positioned(
                                                          right:10,
                                                          top:10,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.4),
                                                                borderRadius: BorderRadius.circular(12)
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child: Center(child: Text(order.foods[index].foodName,style: TextStyle(
                                                                  fontWeight: FontWeight.bold,color: Colors.white
                                                              ),),),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )


                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
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
                                            order.delivered?Text("Order Delivered",style: TextStyle(fontSize:18.sp,color: Colors.white),):SizedBox(),
                                            SizedBox(height: 15.h,),
                                            order.delivered?SizedBox():
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                order.onTheWay?
                                                ElevatedButton(onPressed: ()async{
                                                setState(()async {
                                                  await ShopRepository().updateInvoice(
                                                      deliverymanId: order.deliveryManId,
                                                      newIncome: order.totalPrice,
                                                      shopId: order.shopId,
                                                      newTotalSell: order.foods.length,
                                                      newPlatformFee: 10);
                                                  await ShopRepository().updateOrderBool(order.orderId, "delivered", true);
                                                  await shopController.makeDeliveryList(onboardingController.userProfile[0].shopId);

                                                });
                                                }, child: Text("Complete Delivery")):
                                                ElevatedButton(onPressed: ()async{
                                                 setState(() async{
                                                   await ShopRepository().riderDeliveryAccept(order.orderId, AuthService.user!.uid, true);
                                                   shopController.makeDeliveryList(onboardingController.userProfile[0].shopId);

                                                 });
                                                }, child: Text("Accept Delivery"))
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
                        ):SizedBox();
                      },
                    ),
                  ),
                ))
              ],
            ),
          )
          :
      SingleChildScrollView(
        child:AuthService.user!=null && AuthService.user!.email.toString()=="admin@gmail.com"?
        Container(

          width: MediaQuery.of(context).size.width,
          color:Colors.white,
          child: Column(
            children: [
              Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: ColorHelper.adminThemeColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)
                    )
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:analyticsView?
                    Container(
                      height: 30.h,width: 100.w,
                      decoration: BoxDecoration(
                          color: ColorHelper.adminThemeColor,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(child:Text("Admin Dashboard",style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 18.sp,color: Colors.white
                      ),)),
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50.h,
                          width: MediaQuery.of(context).size.width-100.w,
                          child: TextField(
                            controller: searchController,
                            onChanged: (va){

                            },
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.white), // Set hint text color
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
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
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(color: Colors.white)
                            ),
                            child: IconButton(onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const ShopAddPage(),
                                  ));
                            }, icon: Icon(Icons.add,color: Colors.white,)))
                      ],
                    )

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          analyticsView=true;
                        });
                      },
                      child: Container(
                        height: 30.h,width: 100.w,
                        decoration: BoxDecoration(
                            color: analyticsView?ColorHelper.adminThemeColor:Colors.grey,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Center(child:Text("Analytics",style: TextStyle(
                            fontWeight: FontWeight.w500,fontSize: 16.sp,color: Colors.white
                        ),)),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          analyticsView=false;
                        });
                      },
                      child: Container(
                        height: 30.h,width: 100.w,
                        decoration: BoxDecoration(
                            color: analyticsView==false?ColorHelper.adminThemeColor:Colors.grey,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Center(child:Text("Inspect",style: TextStyle(
                            fontWeight: FontWeight.w500,fontSize: 16.sp,color: Colors.white
                        ),)),
                      ),
                    )
                  ],
                ),
              ),
              analyticsView?Container(
                child: Column(
                  children: [
                    SizedBox(height: 10.h,),
                    Divider(color: ColorHelper.adminThemeColor,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height:70.w,width:70.w,
                                child: Center(child:
                                Obx(()=>Text("${onboardingController.totalUser.toString()}",
                                  style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.bold,color: Colors.white),))),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: ColorHelper.adminThemeColor
                                ),
                              ),
                              SizedBox(height: 8.h,),
                              Icon(Icons.person_outlined)
                             ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height:70.w,width:70.w,
                                child: Center(child: Text("${shopController.shopList.length}",style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.bold,color: Colors.white),)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: ColorHelper.adminThemeColor
                                ),
                              ),
                              SizedBox(height: 8.h,),
                              Icon(Icons.food_bank_outlined) ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height:70.w,width:70.w,
                                child: Center(child:
                                Obx(()=>Text("${onboardingController.totalDel.toString()}",
                                  style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.bold,color: Colors.white),))
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: ColorHelper.adminThemeColor
                                ),
                              ),
                              SizedBox(height: 8.h,),
                              Icon(Icons.delivery_dining) ],
                          )
                        ],
                      ),
                    ),
                    Divider(color: ColorHelper.adminThemeColor,),
                    SizedBox(height: 15.h,),
                    Center(
                      child: Text(
                        "Order Survey",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h,),
                    OrderStatusChart(),
                    SizedBox(height: 40.h,),
                    Center(
                      child: Text(
                        "Top Seller LeaderBoard",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 15.h,),
                    SizedBox(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: shopController.topSellerShopList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              height: 50.h,width: 60.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                    shopController.topSellerShopList[index].image,
                                  height: 50.h,width: 60.w,fit: BoxFit.fill,),),),
                            title: Text(shopController.topSellerShopList[index].name),
                            subtitle: Text('Food Item: ${shopController.topSellerShopList[index].foods.length}'),
                            trailing: Container(
                              height: 30.h,width: 30.h,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(90)
                              ),
                              child: Center(child: Text("${(index+1).toString()}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color:ColorHelper.adminThemeColor),)),
                            ),
                            onTap: () {

                            },
                          );
                        },
                      ),

                    )
                  ],
                ),
              ):
              SizedBox(
                height: MediaQuery.of(context).size.height-195.h,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Obx(()=>ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:searchController.text ==
                        null ||
                        searchController
                            .text ==
                            ''
                        ?  shopController.shopList.value.length:_suggestions.length, // Example list length
                    itemBuilder: (context, index) {
                      var shop=searchController.text ==
                          null ||
                          searchController
                              .text ==
                              ''
                          ? shopController.shopList[index]:_suggestions[index];
                      return InkWell(
                        onTap: (){
                          searchController.text ==
                              null ||
                              searchController
                                  .text ==
                                  ''
                              ?
                          shopController.selectedShop.value=index:
                          shopController.selectedShop.value=shopController.shopList.indexWhere((element) => element.name==_suggestions[index].name)
                          ;
                          if(onboardingController.usertype.value!='shopkeepers')
                          {
                            shopController.tempOrderFooods.clear();
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
                                Stack(
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
                                    Positioned(
                                      top:10.h, left:10.w,
                                        child: Container(
                                      height: 55.h,width: 130.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(25.sp)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap:(){
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Remove ${shop.name} permanently? '),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop(); // Close the dialog
                                                              },
                                                              child: const Text('Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () async{
                                                                Navigator.of(context).pop(); // Close the dialog
                                                                ShopRepository().removeShop(
                                                                    shop.name!);

                                                              },
                                                              child: Text('Yes Remove'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                      },
                                                    child: Icon(Icons.highlight_remove)),
                                                Text("Remove This Shop",style: TextStyle(fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                          ),
                                    )),
                                    Positioned(
                                        top:10.h, right:10.w,
                                        child: Container(
                                          height: 55.h,width: 130.w,
                                          decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(25.sp)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 20.h,width: 30.w,
                                                  child: Switch(
                                                    activeColor: Colors.green,
                                                    value: shop.deliveryAvailable==null?false:shop.deliveryAvailable,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        ShopRepository().updateShopDeliveryStatus(
                                                            shop.name!, value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Text(shop.deliveryAvailable==null || shop.deliveryAvailable==false?"Verify Shop":"Verified",style: TextStyle(fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(height: 8.h,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:200.w,
                                        child: Text(shop.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                          ),),
                                      ),
                                      Row(
                                        children: [
                                          Text('',style: TextStyle(
                                              fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                          ),),
                                          SizedBox(width: 2.w,),
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
        ):
        onboardingController.usertype=="shopkeepers"?
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color:Colors.white,
            child: Column(
              children: [
                Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                      onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:myShopView?
                      Container(
                        height: 30.h,width: 100.w,
                        decoration: BoxDecoration(
                            color: myShopView?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Center(child:Text(shopController.myShop.isEmpty?"":shopController.myShop[0].name!,style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 18.sp,color: Colors.white
                        ),)),
                      ):
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50.h,
                            width: MediaQuery.of(context).size.width-100.w,
                            child: TextField(
                              controller: searchController,
                              onChanged: (va){
          
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: Colors.white), // Set hint text color
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                prefixIcon: Icon(Icons.search, color: Colors.white),
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
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  border: Border.all(color: Colors.white)
                              ),
                              child: IconButton(onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const ShopAddPage(),
                                    ));
                              }, icon: Icon(Icons.add,color: Colors.white,)))
                        ],
                      )
          
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            myShopView=true;
                          });
                        },
                        child: Container(
                          height: 30.h,width: 100.w,
                          decoration: BoxDecoration(
                              color: myShopView?ColorHelper.shopKeeperThemeColor:Colors.grey,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Center(child:Text("My Shop",style: TextStyle(
                              fontWeight: FontWeight.w500,fontSize: 16.sp,color: Colors.white
                          ),)),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            myShopView=false;
                          });
                        },
                        child: Container(
                          height: 30.h,width: 100.w,
                          decoration: BoxDecoration(
                              color: myShopView==false?ColorHelper.shopKeeperThemeColor:Colors.grey,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Center(child:Text("Explore",style: TextStyle(
                              fontWeight: FontWeight.w500,fontSize: 16.sp,color: Colors.white
                          ),)),
                        ),
                      )
                    ],
                  ),
                ),
                myShopView?
                    Obx(()=>Column(
                      children: [
                        SizedBox(height: 10.h,),
                        if( onboardingController.usertype.value=='shopkeepers' &&  shopController.myShop.isNotEmpty)
                          Card(
                            child: InkWell(
                              onTap: (){
                                Get.to(ManageShopDetail());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [ColorHelper.shopKeeperThemeColor, Colors.lightBlueAccent],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        12
                                    )
                                ),
                                height: 150.h,
                                width: MediaQuery.of(context).size.width-40.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't Forget to Check",style: TextStyle(color: Colors.white,fontSize: 20.sp),),
                                    SizedBox(height: 8.h,),
                                    Text("Stay Active Always",style: TextStyle(color: Colors.white,fontSize: 14.sp),),
                                    SizedBox(height: 15.h,),
                                    Container(
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.settings,color: Colors.white,size: 22.sp,),
                                                SizedBox(width: 10.w,),
                                                Text("Manage Your Shop",style: TextStyle(color: Colors.white,fontSize: 18.sp),),
                                              ],
                                            )))
                                  ],
                                ),
                              ),
                            ),
                          )

                        else if(onboardingController.usertype.value=='shopkeepers' && addingShop)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Container(
                                height: 50.h,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Expand your business by adding",style: TextStyle(
                                      fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                  ),),

                                ),
                                decoration: BoxDecoration(
                                    color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                    onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
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
                                  await shopController.addNewShop(true);
                                  shopController.clearFields();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LauncherPage(),
                                      ));
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                      onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
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
                          )
                        else if(onboardingController.usertype.value=='shopkeepers' && addingShop==false)
                            Card(
                              color: Colors.white,
                              child: SizedBox(
                                height: 200.h,
                                width: 325.w,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("You don't have any shop now"),
                                      SizedBox(height: 20.h,),
                                      Icon(Icons.add,size: 50,),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            addingShop=true;
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                borderRadius: BorderRadius.circular(
                                                    12
                                                )
                                            ),
                                            height: 40.h,
                                            width: 300.w,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Add your shop and get orders",style: TextStyle(color: Colors.white,fontSize: 20.sp),),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            SizedBox(),

                        SizedBox(height: 20.h,),
                        Text(addingShop?"":"Delivery Man List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp,color: ColorHelper.shopKeeperThemeColor),),
                        SizedBox(height: 10.h,),
                        Obx(()=>SizedBox(
                          child: shopController.myRiders.length<=0?Center(child:
                          Text("No Delivery Man Joined")): ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: shopController.myRiders.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Container(
                                  height: 50.h,width: 60.w,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      shopController.myRiders[index].image,
                                      height: 50.h,width: 60.w,fit: BoxFit.fill,),),),
                                title: Row(
                                  children: [
                                    Text('Name: ${shopController.myRiders[index].name}'),
                                  SizedBox(width:3.w)
                                  ,shopController.myRiders[index].id!=null &&
                                    shopController.riderBusy(shopController.myRiders[index].id)?
                                        Icon(Icons.bike_scooter,color: ColorHelper.shopKeeperThemeColor,size: 22,):SizedBox()
                                  ],
                                ),
                                subtitle: Text('Contact: ${shopController.myRiders[index].phone}'),
                                trailing: IconButton(
                                  icon:Icon( Icons.highlight_remove),
                                  onPressed: ()async{
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Are you sure?'),
                                          content: Text('Remove rider ${shopController.myRiders[index].name} from your shop'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Remove'),
                                              onPressed: () async{
                                                Navigator.of(context).pop();
                                                await ShopRepository().removeRiderByImage(shopController.myRiders[index].image);
                                                shopController.makeMyRiderList();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                  },
                                ),
                                onTap: () {
                                },
                              );
                            },
                          ),

                        )),
                        SizedBox(height: 15.h,),
                        onboardingController.usertype.value=='shopkeepers' &&  shopController.myorderList.length!=0?Column(
                          children: [
                            Text(addingShop?"":"Order History",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp,color: ColorHelper.shopKeeperThemeColor),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        tab=1;
                                      });
                                    },
                                    child: Container(
                                      width: 80.w,
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: tab==1? [ColorHelper.shopKeeperThemeColor, Colors.lightBlueAccent]:[Colors.grey, Colors.grey],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      child: Center(child: Text("Active",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 14.sp),),),
                                      // other properties like padding, margin, etc. can be added here
                                    ),
                                  ),
                                  InkWell(
                                    onTap:(){
                                      setState(() {
                                        tab=2;
                                      });
                                    },
                                    child: Container(
                                      width: 80.w,
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors:tab==2? [ColorHelper.shopKeeperThemeColor, Colors.lightBlueAccent]:[Colors.grey, Colors.grey],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      child: Center(child: Text("Pending",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 14.sp),),),
                                      // other properties like padding, margin, etc. can be added here
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        tab=3;
                                      });
                                    },
                                    child: Container(
                                      width: 80.w,
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors:tab==3? [ColorHelper.shopKeeperThemeColor, Colors.lightBlueAccent]:[Colors.grey, Colors.grey],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      child: Center(child: Text("History",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 14.sp),),),
                                      // other properties like padding, margin, etc. can be added here
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(tab==1)
                              Obx(()=> addingShop?SizedBox(): SizedBox(
                                height: 280.h,
                                width: MediaQuery.of(context).size.width-20,
                                child: shopController.myorderList.length==0? Center(child: Text("No order added"),):
                                ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: shopController.myorderList.length,
                                  itemBuilder: (context, index) {
                                    var order=shopController.myorderList[index];
                                    return  order.accepted==true && order.userCancel==false && order.shopCancel==false && order.delivered==false?
                                    SizedBox(
                                      width: 280.w,
                                      height: 250.h,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                          onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                          child: Center(
                                            child: SizedBox(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 100.h,
                                                    width: 300.w,
                                                    decoration:  BoxDecoration(
                                                        color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(12),
                                                            topRight: Radius.circular(12))),
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(12),
                                                          topRight: Radius.circular(12)),
                                                      child: Container(
                                                        height: 100.h,
                                                        width: 300.w,
                                                        decoration:  BoxDecoration(
                                                            color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                            onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(12),
                                                                bottomLeft: Radius.circular(12))),
                                                        child: GridView.builder(
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: order.foods.length < 2 ? 1 :2 ,
                                                            childAspectRatio: 1.0,
                                                          ),
                                                          itemCount: order.foods.length,
                                                          itemBuilder: (context, index) {
                                                            return Padding(
                                                                padding: const EdgeInsets.all(1.0),
                                                                child:Stack(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          child: Image.network(width:150.w,height:160.h,order.foods[index].foodImage.toString(), fit: BoxFit.cover,)),
                                                                    ),
                                                                    Positioned(
                                                                      right:10,
                                                                      top:10,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.black.withOpacity(0.4),
                                                                            borderRadius: BorderRadius.circular(12)
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Center(child: Text(order.foods[index].foodName,style: TextStyle(
                                                                              fontWeight: FontWeight.bold,color: Colors.white
                                                                          ),),),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )


                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Obx(()=>onboardingController.usertype.value=='shopkeepers'?
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        //Text("${order.food.foodName.toString()}",style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                                                        Text("Estimated Delivery: 10 minutes",style: TextStyle(color: Colors.white),),
                                                        Text("Set Preparing Time: ${order.prepareTime.toString()} minutes",style: TextStyle(color: Colors.white),),
                                                        // Text("Delivery Status: "+order.prepareTime!=null?"Food Preparing":
                                                        // order.accepted?"Accepted" :order.delivered?"Delivered":""
                                                        //   ,style: TextStyle(color: Colors.white),),

                                                        order.onTheWay?Text("Out for delivery"):
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: (){
                                                                ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 5);
                                                              },
                                                              child: Container(
                                                                height:25.h,width:25.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(90),
                                                                    border: Border.all(color: Colors.black)
                                                                ),
                                                                child: Center(child: Text("5")),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10.w,),
                                                            InkWell(
                                                              onTap: (){
                                                                ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 10);
                                                              },
                                                              child: Container(
                                                                height:25.h,width:25.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(90),
                                                                    border: Border.all(color: Colors.black)
                                                                ),
                                                                child: Center(child: Text("10")),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10.w,),
                                                            InkWell(
                                                              onTap: (){
                                                                ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 15);
                                                              },
                                                              child: Container(
                                                                height:25.h,width:25.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(90),
                                                                    border: Border.all(color: Colors.black)
                                                                ),
                                                                child: Center(child: Text("15")),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        order.shopCancel?Text("Order Canceled"):SizedBox(),
                                                        order.userCancel?Text("Order Canceled"):SizedBox(),
                                                        order.delivered?Text("Order Delivered",style: TextStyle(color: Colors.white),):SizedBox(),
                                                        Row(
                                                          children: [
                                                            order.accepted && order.delivered==false && order.onTheWay==false?
                                                            ElevatedButton(
                                                                onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "shopCancel", true);
                                                              ShopRepository().updateOrderBool(order.orderId, "accepted", false);
                                                            }, child: Text("Cancel Order")):
                                                            order.delivered || order.onTheWay?SizedBox():
                                                            ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "accepted", true);
                                                              ShopRepository().updateOrderBool(order.orderId, "shopCancel", false);
                                                            }, child: Text("Accept Order")),

                                                            SizedBox(width: 5.w,),
                                                            order.accepted==false ||  order.delivered ||  order.shopCancel || order.userCancel?SizedBox():ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "delivered", true);
                                                            }, child: Text("Delivered"))
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                        :Column(
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
                                                        order.delivered?Text("Order Delivered",style: TextStyle(color: Colors.white),):SizedBox(),
                                                        Row(
                                                          children: [
                                                            order.delivered ||  order.accepted ||  order.shopCancel || order.userCancel?SizedBox():  ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "userCancel", true);
                                                            }, child: Text("Cancel Order"))
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ):SizedBox();
                                  },
                                ),
                              ))
                            else if(tab==2)
                              Obx(()=> addingShop?SizedBox(): SizedBox(
                                height: 280.h,
                                width: MediaQuery.of(context).size.width-20,
                                child: shopController.myorderList.length==0? Center(child: Text("No order added"),):
                                ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: shopController.myorderList.length,
                                  itemBuilder: (context, index) {
                                    var order=shopController.myorderList[index];
                                    return  order.accepted==false && order.userCancel==false && order.shopCancel==false && order.delivered==false?
                                    SizedBox(
                                      width: 280.w,
                                      height: 250.h,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                          onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                          child: Center(
                                            child: SizedBox(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 100.h,
                                                    width: 300.w,
                                                    decoration:  BoxDecoration(
                                                        color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                        onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(12),
                                                            topRight: Radius.circular(12))),
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(12),
                                                          topRight: Radius.circular(12)),
                                                      child: Container(
                                                        height: 100.h,
                                                        width: 300.w,
                                                        decoration:  BoxDecoration(
                                                            color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                            onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(12),
                                                                bottomLeft: Radius.circular(12))),
                                                        child: GridView.builder(
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: order.foods.length < 2 ? 1 :2 ,
                                                            childAspectRatio: 1.0,
                                                          ),
                                                          itemCount: order.foods.length,
                                                          itemBuilder: (context, index) {
                                                            return Padding(
                                                                padding: const EdgeInsets.all(1.0),
                                                                child:Stack(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          child: Image.network(width:150.w,height:160.h,order.foods[index].foodImage.toString(), fit: BoxFit.cover,)),
                                                                    ),
                                                                    Positioned(
                                                                      right:10,
                                                                      top:10,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.black.withOpacity(0.4),
                                                                            borderRadius: BorderRadius.circular(12)
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(10.0),
                                                                          child: Center(child: Text(order.foods[index].foodName,style: TextStyle(
                                                                              fontWeight: FontWeight.bold,color: Colors.white
                                                                          ),),),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )


                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Obx(()=>onboardingController.usertype.value=='shopkeepers'?
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                       // Text("${order.food.foodName.toString()}",style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                                                        Text("Estimated Delivery: 10 minutes",style: TextStyle(color: Colors.white),),
                                                        Text("Set Preparing Time: ${order.prepareTime.toString()} minutes",style: TextStyle(color: Colors.white),),
                                                        // Text("Delivery Status: "+order.prepareTime!=null?"Food Preparing":
                                                        // order.accepted?"Accepted" :order.delivered?"Delivered":""
                                                        //   ,style: TextStyle(color: Colors.white),),

                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: (){
                                                                ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 5);
                                                              },
                                                              child: Container(
                                                                height:25.h,width:25.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(90),
                                                                    border: Border.all(color: Colors.black)
                                                                ),
                                                                child: Center(child: Text("5")),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10.w,),
                                                            InkWell(
                                                              onTap: (){
                                                                ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 10);
                                                              },
                                                              child: Container(
                                                                height:25.h,width:25.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(90),
                                                                    border: Border.all(color: Colors.black)
                                                                ),
                                                                child: Center(child: Text("10")),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10.w,),
                                                            InkWell(
                                                              onTap: (){
                                                                ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 15);
                                                              },
                                                              child: Container(
                                                                height:25.h,width:25.h,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(90),
                                                                    border: Border.all(color: Colors.black)
                                                                ),
                                                                child: Center(child: Text("15")),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        order.shopCancel?Text("Order Canceled"):SizedBox(),
                                                        order.userCancel?Text("Order Canceled"):SizedBox(),
                                                        order.delivered?Text("Order Delivered",style: TextStyle(color: Colors.white),):SizedBox(),
                                                        Row(
                                                          children: [
                                                            order.accepted && order.delivered==false?
                                                            ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "shopCancel", true);
                                                              ShopRepository().updateOrderBool(order.orderId, "accepted", false);
                                                            }, child: Text("Cancel Order")):
                                                            order.delivered?SizedBox():
                                                            ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "accepted", true);
                                                              ShopRepository().updateOrderBool(order.orderId, "shopCancel", false);
                                                            }, child: Text("Accept Order")),

                                                            SizedBox(width: 5.w,),
                                                            order.accepted==false ||  order.delivered ||  order.shopCancel || order.userCancel?SizedBox():ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "delivered", true);
                                                            }, child: Text("Delivered"))
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                        :Column(
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
                                                        order.delivered?Text("Order Delivered",style: TextStyle(color: Colors.white),):SizedBox(),
                                                        Row(
                                                          children: [
                                                            order.delivered ||  order.accepted ||  order.shopCancel || order.userCancel?SizedBox():  ElevatedButton(onPressed: (){
                                                              ShopRepository().updateOrderBool(order.orderId, "userCancel", true);
                                                            }, child: Text("Cancel Order"))
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ):SizedBox();
                                  },
                                ),
                              ))
                            else if(tab==3)
                                Obx(()=> addingShop?SizedBox(): SizedBox(
                                  height: 280.h,
                                  width: MediaQuery.of(context).size.width-20,
                                  child: shopController.myorderList.length==0? Center(child: Text("No order added"),):
                                  ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: shopController.myorderList.length,
                                    itemBuilder: (context, index) {
                                      var order=shopController.myorderList[index];
                                      return order.userCancel==true || order.shopCancel==true || order.delivered==true?
                                      SizedBox(
                                        width: 280.w,
                                        height: 250.h,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                            onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                            child: Center(
                                              child: SizedBox(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 100.h,
                                                      width: 300.w,
                                                      decoration:  BoxDecoration(
                                                          color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                          onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(12),
                                                              topRight: Radius.circular(12))),
                                                      child: ClipRRect(
                                                        borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(12),
                                                            topRight: Radius.circular(12)),
                                                        child: Container(
                                                          height: 100.h,
                                                          width: 300.w,
                                                          decoration:  BoxDecoration(
                                                              color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                                              onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(12),
                                                                  bottomLeft: Radius.circular(12))),
                                                          child: GridView.builder(
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: order.foods.length < 2 ? 1 :2 ,
                                                              childAspectRatio: 1.0,
                                                            ),
                                                            itemCount: order.foods.length,
                                                            itemBuilder: (context, index) {
                                                              return Padding(
                                                                  padding: const EdgeInsets.all(1.0),
                                                                  child:Stack(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.black),
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            child: Image.network(width:150.w,height:160.h,order.foods[index].foodImage.toString(), fit: BoxFit.cover,)),
                                                                      ),
                                                                      Positioned(
                                                                        right:10,
                                                                        top:10,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.4),
                                                                              borderRadius: BorderRadius.circular(12)
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(10.0),
                                                                            child: Center(child: Text(order.foods[index].foodName,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,color: Colors.white
                                                                            ),),),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )


                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Obx(()=>onboardingController.usertype.value=='shopkeepers'?
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                         // Text("${order.food.foodName.toString()}",style: TextStyle(color: Colors.white,fontSize: 16.sp),),
                                                          Text("Estimated Delivery: 10 minutes",style: TextStyle(color: Colors.white),),
                                                          Text("Set Preparing Time: ${order.prepareTime.toString()} minutes",style: TextStyle(color: Colors.white),),
                                                          // Text("Delivery Status: "+order.prepareTime!=null?"Food Preparing":
                                                          // order.accepted?"Accepted" :order.delivered?"Delivered":""
                                                          //   ,style: TextStyle(color: Colors.white),),

                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: (){
                                                                  ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 5);
                                                                },
                                                                child: Container(
                                                                  height:25.h,width:25.h,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(90),
                                                                      border: Border.all(color: Colors.black)
                                                                  ),
                                                                  child: Center(child: Text("5")),
                                                                ),
                                                              ),
                                                              SizedBox(width: 10.w,),
                                                              InkWell(
                                                                onTap: (){
                                                                  ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 10);
                                                                },
                                                                child: Container(
                                                                  height:25.h,width:25.h,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(90),
                                                                      border: Border.all(color: Colors.black)
                                                                  ),
                                                                  child: Center(child: Text("10")),
                                                                ),
                                                              ),
                                                              SizedBox(width: 10.w,),
                                                              InkWell(
                                                                onTap: (){
                                                                  ShopRepository().updateOrderPrepAreTime(order.orderId, "prepareTime", 15);
                                                                },
                                                                child: Container(
                                                                  height:25.h,width:25.h,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(90),
                                                                      border: Border.all(color: Colors.black)
                                                                  ),
                                                                  child: Center(child: Text("15")),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 10.h),
                                                          order.shopCancel?Text("Order Canceled"):SizedBox(),
                                                          order.userCancel?Text("Order Canceled"):SizedBox(),
                                                          order.delivered?Text("Order Delivered",style: TextStyle(color: Colors.white),):SizedBox(),
                                                          Row(
                                                            children: [
                                                              order.accepted && order.delivered==false?
                                                              ElevatedButton(onPressed: (){
                                                                ShopRepository().updateOrderBool(order.orderId, "shopCancel", true);
                                                                ShopRepository().updateOrderBool(order.orderId, "accepted", false);
                                                              }, child: Text("Cancel Order")):
                                                              order.delivered?SizedBox():
                                                              ElevatedButton(onPressed: (){
                                                                ShopRepository().updateOrderBool(order.orderId, "accepted", true);
                                                                ShopRepository().updateOrderBool(order.orderId, "shopCancel", false);
                                                              }, child: Text("Accept Order")),

                                                              SizedBox(width: 5.w,),
                                                              order.accepted==false ||  order.delivered ||  order.shopCancel || order.userCancel?SizedBox():ElevatedButton(onPressed: (){
                                                                ShopRepository().updateOrderBool(order.orderId, "delivered", true);
                                                              }, child: Text("Delivered"))
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                          :Column(
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
                                                          order.delivered?Text("Order Delivered",style: TextStyle(color: Colors.white),):SizedBox(),
                                                          Row(
                                                            children: [
                                                              order.delivered ||  order.accepted ||  order.shopCancel || order.userCancel?SizedBox():  ElevatedButton(onPressed: (){
                                                                ShopRepository().updateOrderBool(order.orderId, "userCancel", true);
                                                              }, child: Text("Cancel Order"))
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                    )

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ):SizedBox();
                                    },
                                  ),
                                )),


                          ],
                        ):SizedBox()
                      ],
                    )):
                SizedBox(
                  height: MediaQuery.of(context).size.height-140.h,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Obx(()=>ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:searchController.text ==
                          null ||
                          searchController
                              .text ==
                              ''
                          ?  shopController.shopList.value.length:_suggestions.length, // Example list length
                      itemBuilder: (context, index) {
                        var shop=searchController.text ==
                            null ||
                            searchController
                                .text ==
                                ''
                            ? shopController.shopList[index]:_suggestions[index];
                        return InkWell(
                          onTap: (){
                            searchController.text ==
                                null ||
                                searchController
                                    .text ==
                                    ''
                                ?
                            shopController.selectedShop.value=index:
                            shopController.selectedShop.value=shopController.shopList.indexWhere((element) => element.name==_suggestions[index].name)
                            ;
                            if(onboardingController.usertype.value!='shopkeepers')
                            {
                              shopController.tempOrderFooods.clear();
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
                                  color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                  onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Column(
                                children: [
                                  Stack(
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
                                      Positioned(
                                          top:3.h, right: 3.w,
                                          child: shop.deliveryAvailable?
                                          Image.asset("images/verified.png",height: 35.h,width: 35.h,):SizedBox() )
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:200.w,
                                          child: Text(shop.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                            ),),
                                        ),
                                        Row(
                                          children: [
                                            Text('',style: TextStyle(
                                                fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                            ),),
                                            SizedBox(width: 2.w,),
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
                ),
          
              ],
            ),
          ),
        ):
        Container(
          height: MediaQuery.of(context).size.height-100.h,
          width: MediaQuery.of(context).size.width,
          color:Colors.white,
          child: Column(
            children: [
              Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:  onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                  onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: MediaQuery.of(context).size.width-100.w,
                        child: TextField(
                          controller: searchController,
                          onChanged: (va){

                          },
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.white), // Set hint text color
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: Colors.white)
                        ),
                          child: IconButton(onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ShopAddPage(),
                                ));
                          }, icon: Icon(Icons.add,color: Colors.white,)))
                    ],
                  )

                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height-160.h,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Obx(()=>ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:searchController.text ==
                        null ||
                        searchController
                            .text ==
                            ''
                        ?  shopController.shopList.value.length:_suggestions.length, // Example list length
                    itemBuilder: (context, index) {
                      var shop=searchController.text ==
                          null ||
                          searchController
                              .text ==
                              ''
                          ? shopController.shopList[index]:_suggestions[index];
                      return InkWell(
                        onTap: (){
                          searchController.text ==
                              null ||
                              searchController
                                  .text ==
                                  ''
                              ?
                          shopController.selectedShop.value=index:
                          shopController.selectedShop.value=shopController.shopList.indexWhere((element) => element.name==_suggestions[index].name)
                          ;
                          if(onboardingController.usertype.value!='shopkeepers')
                            {
                              shopController.tempOrderFooods.clear();
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
                                color: onboardingController.usertype=="users"? ColorHelper.userThemeColor :
                                onboardingController.usertype=="shopkeepers"?ColorHelper.shopKeeperThemeColor:ColorHelper.adminThemeColor,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Column(
                              children: [
                                Stack(
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
                                    Positioned(
                                      top:3.h, right: 3.w,
                                        child: shop.deliveryAvailable?
                                        Image.asset("images/verified.png",height: 35.h,width: 35.h,):SizedBox() )
                                  ],
                                ),
                                SizedBox(height: 8.h,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:200.w,
                                        child: Text(shop.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                        ),),
                                      ),
                                      Row(
                                        children: [
                                          Text('',style: TextStyle(
                                              fontWeight: FontWeight.w500,fontSize: 20.sp,color: Colors.white
                                          ),),
                                          SizedBox(width: 2.w,),
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
      ),
    );
  }


}


