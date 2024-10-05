import 'dart:io';

import 'package:firebase/auth_service.dart';
import 'package:firebase/models/user_model.dart';
import 'package:firebase/repository/OnBoardRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingController extends GetxController{
  var collectionName=''.obs;
  var usertype=''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  var shopList=[].obs;
  var selectedShop="Select".obs;
  var userProfile=[].obs;
  var imageFile = Rxn<File>();

  var shopadding=false.obs;
  var shopIdforDM="";
  Future<void> completeProfile({required bool deliveryMan}) async{
    EasyLoading.show();
    User? user = FirebaseAuth.instance.currentUser;
    shopadding.value=true;
    String imgUrl= await uploadImageToFirestore(imageFile.value!);
    UserModel userModel= UserModel(
      id: AuthService.user==null?"":AuthService.user!.uid,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      favFood: '',
      favShop: '',
      shopId: deliveryMan?shopIdforDM: '',
      image: imgUrl
    );
    await OnBoardRep().addUserToFirestore(userModel,collectionName.value, user!.uid);
    EasyLoading.dismiss();
    shopadding.value=false;
  }
  var totalUser=0.obs;
  var totalDel=0.obs;
  Future<void> getTotalUsers() async{

    totalUser.value= await OnBoardRep().getSizeOfCollection("users");
    totalDel.value= await OnBoardRep().getSizeOfCollection("deliveryman");

    print("$totalDel   $totalUser");

  }
  Future<void> checkuserType(String uid) async{
    usertype.value= await OnBoardRep().getUserType(uid);
    print("UserType:  ${usertype.value}     UserId: ${AuthService.user!.uid}");
  }

  clearFields(){
    nameController.text='';
    addressController.text='';
    emailController.text='';
    phoneController.text='';
    imageFile.value=null;
  }

  bool allOk(){
    if( nameController.text =='' || addressController.text=='' || emailController.text=='' || phoneController.text=='' || imageFile.value==null)
      {
        return false;
      }
    else {
      return true;
    }
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

  Future<void> getProfile() async{
    User? user = FirebaseAuth.instance.currentUser;
    checkuserType(user!.uid);
    userProfile.clear();
    userProfile.value.add(await OnBoardRep().getUserModelFromFirestore(usertype.value, user!.uid));
    print("ghggjjgjh: ${userProfile.length.toString()}");
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User logged out successfully');
    } catch (e) {
      print('Error logging out user: $e');
    }
  }


}