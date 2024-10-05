
import 'dart:io';

import 'package:firebase/auth_service.dart';
import 'package:firebase/models/order_model.dart';
import 'package:firebase/models/shop_model.dart';
import 'package:firebase/repository/shop_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class ShopController extends GetxController{

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController reveiwController = TextEditingController();
  var shopList=[].obs;
  var tempOrderFooods=[].obs;
  var tempshopList=[].obs;
  var orderList=[].obs;
  var myorderList=[].obs;
  var mydeliveryList=[].obs;
  var trendyshopList=[].obs;
  var trendyFoodList=[].obs;
  var selectedShop=0.obs;
  var selectedFood=0.obs;
  var selectedtrendyShop=0.obs;
  var myShop=[].obs;
  var ordering=false.obs;
  var imageFile = Rxn<File>();

  List<String> foodCat=["Select","Snacks", "Lunch", "Breakfast", "Fast Foods", "Fruits", "Drinks"];
  List<String> foodCatTabs=["All","Snacks", "Lunch", "Breakfast", "Fast Foods", "Fruits","Drinks"];

var DelShopId="";

  @override
  void onInit() {
    getShopList();
    getOrderList();
    super.onInit();
  }
  var selectedCat="Snacks".obs;
  var topSellerIdList=[].obs;
  var topSellerShopList=[].obs;
  var myRiders=[].obs;
  getOrderList() {
    ShopRepository.getOrderList().listen((event) {
      orderList.value = List.generate(event.docs.length,
              (index) => OrderModel.fromJson(event.docs[index].data()));
      print("asfhksdkjksdORDERjkfkjsad : ${orderList.length}");
       orderList.value.sort((b, a) => DateTime.parse(a.datetime).compareTo(DateTime.parse(b.datetime)));
      topSellerIdList.value=sortByFrequency(orderList);
      topSellerIdList.value=topSellerIdList.toSet().toList();
      topSellerShopList.clear();
      for(int i=0;i<topSellerIdList.length;i++)
        {
        int index=shopList.indexWhere((shop) => shop.id == topSellerIdList[i]);
        if(index>=0)
          {
            topSellerShopList.add(shopList[index]);
          }

          print("sdkjskjdfkjkjsdkjf: ${topSellerShopList.length.toString()}");
        }
      makeMyOrderLis();
      makeDeliveryList(DelShopId);
    });
  }

  int calculatePrice(var foods){
    int total=0;
    for(var food in foods)
    {
      if(food.price!=null)
      {
        total=total+int.parse(food.price!.toString());
      }
    }
    return total;

  }

  Future<void> makeMyRiderList() async{
    myRiders.value= await ShopRepository().getRidersByShopId(myShop[0].id);
    print("jasdkksdfsjdkjdf ${myRiders.length.toString()}");
  }

  int findOrderStatCount(String stat){
    int count=0;
    for(int i=0;i<orderList.length;i++)
      {
        if(stat=="delivered" && orderList[i].delivered==true)
          {
            count++;
          }
        else if(stat=="accepted" && orderList[i].accepted==false)
        {
          count++;
        }
        else if(stat=="userCancel" && orderList[i].userCancel==true)
        {
          count++;
        }
        else if(stat=="shopCancel" && orderList[i].shopCancel==true)
        {
          count++;
        }
      }
    return count;
  }

  List<String> sortByFrequency(var orders) {
    // Count occurrences of each shopId
    Map<String, int> frequencyMap = {};
    for (var order in orders) {
      frequencyMap[order.shopId!] = (frequencyMap[order.shopId] ?? 0) + 1;
    }

    // Sort shopIds by their frequency in ascending order
    var sortedEntries = frequencyMap.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Create a list of shopIds sorted by frequency
    List<String> sortedShopIds = [];
    for (var entry in sortedEntries) {
      for (var i = 0; i < entry.value; i++) {
        sortedShopIds.add(entry.key);
      }
    }

    return sortedShopIds;
  }

  makeMyOrderLis(){
    myorderList.clear();
    for(int i=0;i<orderList.length;i++)
      {
        if(orderList[i].userId== AuthService.user!.uid || orderList[i].shopId== AuthService.user!.uid)
          {
            myorderList.add(orderList[i]);
          }
      }
    print("asfhksdkjksdMYORDERjkfkjsad : ${myorderList.length}");
  }

  makeDeliveryList(String shopId){
    mydeliveryList.clear();
    for(int i=0;i<orderList.length;i++)
    {
      if(orderList[i].shopId== shopId && orderList[i].accepted)
      {
        mydeliveryList.add(orderList[i]);
      }
    }
    print("asfhksdkjksdRjkfkjsad : ${mydeliveryList.length}");
  }
var shopNames=[].obs;
  getShopList() {
    ShopRepository.getShopList().listen((event) {
      shopList.value = List.generate(event.docs.length,
              (index) => Restaurant.fromJson(event.docs[index].data()));
      print("asfhksdkjjkfkjsad : ${shopList.length}");
      tempshopList.value=shopList.value;
      shopNames.value=shopList.map((shop) => shop.name).toList();
      shopNames.toSet().toList();
      getMyshopData();
      makeTrendyshopList();
    });
  }

  makeTrendyshopList(){
    trendyshopList.value = List.from(shopList);
    // Sort the copied list based on the 'visited' field in descending order
    trendyshopList.sort((a, b) => b.visited.compareTo(a.visited));
    makeTrendFoodList();
  }

  makeTrendFoodList(){
    trendyFoodList.clear();
    for(int i=0;i<shopList.length;i++)
      {
        trendyFoodList.addAll(shopList[i].foods);
      }
    trendyFoodList.value = List.from(trendyFoodList);
    // Sort the copied list based on the 'visited' field in descending order
    trendyFoodList.sort((a, b) => b.visited.compareTo(a.visited));
  }

  clearFields(){
    nameController.text='';
    addressController.text='';
    imageFile.value=null;
  }

var myShopIndex=-1;
  Future<void> getMyshopData() async{
myShop.clear();
 myShopIndex = shopList.indexWhere((restaurant) => restaurant.id == AuthService.user!.uid);

 if(myShopIndex!=-1)
   {
     myShop.add(shopList[myShopIndex]);
   }
    print(" SAKJDFHNJKLSD   ${myShopIndex.toString()} : ${myShop.length.toString()}");
 if(myShop.isNotEmpty){
   makeMyRiderList();
 }

  }

  var shopadding=false.obs;
  Future<void> addNewShop(bool byOwner) async{
  EasyLoading.show();
    shopadding.value=true;
    String imgUrl= await uploadImageToFirestore(imageFile.value!);
    Restaurant restaurant= Restaurant(
      totalDelivery: 0,
      totalSell: 0,
      platformFee: 0,
      name: nameController.text,
      id: byOwner?AuthService.user!.uid:'',
      visited: 0,
      email: '',
      image: imgUrl??'',
      ratedBy: 0,
      rating: 0,
      reviews: [],
      ownerId: '',
      lat: 0,
      long: 0,
      address: addressController.text,
      deliveryAvailable: false,
      deliveryManId: [],
      orderList: [],
      foods: []
    );
    await ShopRepository().addRestaurantToFirestore(restaurant);
  EasyLoading.dismiss();
    shopadding.value=false;
  }

  bool riderBusy(String targetId) {
    for (var order in myorderList) {
      if (order.deliveryManId!=null && order.deliveryManId == targetId && order.delivered==false) {
        return true;
      }
    }
    return false;
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      } else {
        print('No image selected.');
        imageFile.value = null;
      }
    } catch (e) {
      print('Error picking image: $e');
      imageFile.value = null;
    }
  }
  Future<String> uploadImageToFirestore(File imageFile) async {
    String basename='images';
    try {
      String imagePath =
          'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      // Handle any errors that might occur during the upload process
      print('Error uploading image to Firestore: $e');
      throw e;
    }
  }
}