import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/order_model.dart';
import 'package:firebase/models/user_model.dart';

import '../models/shop_model.dart';

class ShopRepository{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> updateInvoice({
    required String deliverymanId,
    required int newIncome,
    required String shopId,
    required int newTotalSell,
    required int newPlatformFee,
  }) async {
    try {


      await updateShopDetails(shopId, newTotalSell, newPlatformFee);

      await updateDeliverymanIncome(deliverymanId, newIncome);


      print("Documents updated successfully.");
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  Future<void> updateDeliverymanIncome(String deliverymanId, int newIncome) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch and update the deliveryman document
      await firestore.collection('deliveryman').doc(deliverymanId).get().then((doc) {
        if (doc.exists) {
          int currentIncome = doc['income'] ?? 0;
          doc.reference.update({
            'income': currentIncome + 20
          });
        }
      });

      print('Income updated successfully.');
    } catch (e) {
      print('Error updating deliveryman income: $e');
    }
  }

  Future<void> updateShopDetails(String shopId, int newTotalSell, int newPlatformFee) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the collection to find the document where the id matches the passed shopId
      QuerySnapshot querySnapshot = await firestore.collection('shops')
          .where('id', isEqualTo: shopId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document that matches the query
        DocumentSnapshot doc = querySnapshot.docs.first;

        int currentTotalSell = doc['totalSell'] ?? 0;
        int currentPlatformFee = doc['platformFee'] ?? 0;
        int currentTotalDelivery = doc['totalDelivery'] ?? 0;

        // Update the fields in the found document
        await doc.reference.update({
          'totalSell': currentTotalSell + newTotalSell,
          'platformFee': currentPlatformFee + newPlatformFee,
          'totalDelivery': currentTotalDelivery + 1
        });

        print('Shop details updated successfully.');
      } else {
        print("No shop found with id: $shopId");
      }
    } catch (e) {
      print('Error updating shop details: $e');
    }
  }

  Future<void> clearShopDue(String shopId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the collection to find the document where the id matches the passed shopId
      QuerySnapshot querySnapshot = await firestore.collection('shops')
          .where('id', isEqualTo: shopId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document that matches the query
        DocumentSnapshot doc = querySnapshot.docs.first;


        // Update the fields in the found document
        await doc.reference.update({
          'platformFee': 0
        });

        print('Shop details updated successfully.');
      } else {
        print("No shop found with id: $shopId");
      }
    } catch (e) {
      print('Error updating shop details: $e');
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getShopList() {
    return _db.collection("shops").snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrderList() {
    return _db.collection("orders").snapshots();
  }

  Future<void> addRestaurantToFirestore(Restaurant restaurant) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add the restaurant data to the Firestore collection "shops"
      await firestore.collection('shops').add({
        'totalSell':restaurant.totalSell,
        'platformFee': restaurant.platformFee,
        'totalDelivery':restaurant.totalDelivery,
        'rating': restaurant.rating,
        'rated_by': restaurant.ratedBy,
        'reviews': restaurant.reviews,
        'id': restaurant.id,
        'email': restaurant.email,
        'name': restaurant.name,
        'ownerId': restaurant.ownerId,
        'image': restaurant.image,
        'lat': restaurant.lat,
        'long': restaurant.long,
        'address': restaurant.address,
        'visited': restaurant.visited,
        'delivery_available': restaurant.deliveryAvailable,
        'deliveryManId': restaurant.deliveryManId,
        'orderList': restaurant.orderList,
        'foods': [],
        'sellLimit': 2,
      });
    } catch (e) {
      // Handle any errors that might occur
      print('Error adding restaurant to Firestore: $e');
      throw e;
    }
  }

  Future<void> addFoodToShop(String shopName, Food food) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'foods': FieldValue.arrayUnion([food.toJson()])
          });
        });
      });

      print('Food added to shop successfully');
    } catch (e) {
      print('Error adding food to shop: $e');
    }
  }


  Future<void> updateShopClick(String shopName, int clicks) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'visited': clicks
          });
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }

  Future<void> updateShopDeliveryStatus(String shopName, bool value) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'delivery_available': value
          });
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }


  Future<void> removeShop(String shopName) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }


  Future<void> updateShop(String shopName, String newName, String imgLink) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'name': newName,
            'image': imgLink
          });
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }

  Future<void> updateFoodIntegers(
      {required String fieldName,required String shopName,required String foodName,required int value}) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query for the shop document where name matches
      QuerySnapshot shopQuerySnapshot = await firestore.collection('shops').where('name', isEqualTo: shopName).get();

      // Iterate through the shop documents
      for (QueryDocumentSnapshot shopDoc in shopQuerySnapshot.docs) {
        // Get the foodList from the shop document
        List<dynamic> foodList = shopDoc['foods'];

        // Iterate through the foodList to find the matching food item by name
        for (var foodItem in foodList) {
          // Check if the food item name matches the provided foodName
          if (foodItem['foodName'] == foodName) {
            // Update the count of the matching food item
            int currentCount = foodItem[fieldName]??0;
            // int newCount = currentCount + value;

            // Update the count in the foodList
            foodItem[fieldName] = value;
          }
        }

        // Update the shop document with the modified foodList
        await shopDoc.reference.update({
          'foods': foodList,
        });
      }

      print('Clicks added to food successfully');
    } catch (e) {
      print('Error adding clicks to shop: $e');
      throw e;
    }
  }

  Future<void> updateFoodIDeliveryStat(
      {required String shopName,required String foodName,required bool value}) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query for the shop document where name matches
      QuerySnapshot shopQuerySnapshot = await firestore.collection('shops').where('name', isEqualTo: shopName).get();

      // Iterate through the shop documents
      for (QueryDocumentSnapshot shopDoc in shopQuerySnapshot.docs) {
        // Get the foodList from the shop document
        List<dynamic> foodList = shopDoc['foods'];

        // Iterate through the foodList to find the matching food item by name
        for (var foodItem in foodList) {
          // Check if the food item name matches the provided foodName
          if (foodItem['foodName'] == foodName) {
            // Update the count of the matching food item
            // int newCount = currentCount + value;

            // Update the count in the foodList
            foodItem["deliveryOn"] = value;
          }
        }

        // Update the shop document with the modified foodList
        await shopDoc.reference.update({
          'foods': foodList,
        });
      }

      print('Clicks added to food successfully');
    } catch (e) {
      print('Error adding clicks to shop: $e');
      throw e;
    }
  }
  Future<List<UserModel>> getRidersByShopId(String shopId) async {
    List<UserModel> userList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('deliveryman')
          .where('shopid', isEqualTo: shopId)
          .get();

      querySnapshot.docs.forEach((doc) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String,dynamic>);
        userList.add(user);
      });
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error as needed
    }

    return userList;
  }

  Future<void> removeRiderByImage(String imageValue) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('deliveryman')
          .where('image', isEqualTo: imageValue)
          .get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    } catch (e) {
      print('Error removing user document: $e');
      // Handle error as needed
    }
  }

  Future<void> deleteFood(
      {required String shopName,required String foodName}) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query for the shop document where name matches
      QuerySnapshot shopQuerySnapshot = await firestore.collection('shops').where('name', isEqualTo: shopName).get();

      // Iterate through the shop documents
      for (QueryDocumentSnapshot shopDoc in shopQuerySnapshot.docs) {
        // Get the foodList from the shop document
        List<dynamic> foodList = shopDoc['foods'];

            foodList.removeWhere((food) => food['foodName'] == foodName);


        // Update the shop document with the modified foodList
        await shopDoc.reference.update({
          'foods': foodList,
        });
      }

      print('Clicks added to food successfully');
    } catch (e) {
      print('Error adding clicks to shop: $e');
      throw e;
    }
  }

  Future<void> deleteShopReview(
      {required String shopName,required String review}) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query for the shop document where name matches
      QuerySnapshot shopQuerySnapshot = await firestore.collection('shops').where('name', isEqualTo: shopName).get();

      // Iterate through the shop documents
      for (QueryDocumentSnapshot shopDoc in shopQuerySnapshot.docs) {
        // Get the foodList from the shop document
        List<dynamic> revList = shopDoc['reviews'];

        revList.removeWhere((rev) => rev == review);


        // Update the shop document with the modified foodList
        await shopDoc.reference.update({
          'reviews': revList,
        });
      }

      print('Clicks added to food successfully');
    } catch (e) {
      print('Error adding clicks to shop: $e');
      throw e;
    }
  }


  Future<void> updateOrderBool(String orderId, String fieldName, bool value) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('orders').where('orderId', isEqualTo: orderId).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            fieldName: value
          });
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }

  Future<void> riderDeliveryAccept(String orderId, String deliverymanId, bool value) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('orders').where('orderId', isEqualTo: orderId).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            "onTheWay": value,
            "deliveryManId":deliverymanId
          });
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }

  Future<void> updateOrderPrepAreTime(String orderId, String fieldName, int time) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('orders').where('orderId', isEqualTo: orderId).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            fieldName: time
          });
        });
      });

      print('clicks  added to shop successfully');
    } catch (e) {
      print('clicks adding food to shop: $e');
    }
  }

  Future<void> addReveiwToShop(String shopName, String reveiw) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'reviews': FieldValue.arrayUnion([reveiw.toString()])
          });
        });
      });

      print('Food added to shop successfully');
    } catch (e) {
      print('Error adding food to shop: $e');
    }
  }

  Future<void> addReviewToFood(String shopName, String foodName, String review) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query for the shop document where name matches
      QuerySnapshot shopQuerySnapshot = await firestore.collection('shops').where('name', isEqualTo: shopName).get();

      // Iterate through the shop documents
      for (QueryDocumentSnapshot shopDoc in shopQuerySnapshot.docs) {
        // Get the foodList from the shop document
        List<dynamic> foodList = shopDoc['foods'];

        // Iterate through the foodList to find the matching food item by name
        for (var foodItem in foodList) {
          // Check if the food item name matches the provided foodName
          if (foodItem['foodName'] == foodName) {
            // Update the reviews array of the matching food item
            List<String> currentReviews = List<String>.from(foodItem['reviews']);
            currentReviews.add(review);
            // Update the reviews in the foodList
            foodItem['reviews'] = currentReviews;
          }
        }

        // Update the shop document with the modified foodList
        await shopDoc.reference.update({
          'foods': foodList,
        });
      }

      print('Review added to shop successfully');
    } catch (e) {
      print('Error adding review to shop: $e');
      throw e;
    }
  }


  Future<void> addRatingToShop(String shopName, int rating, int ratedby) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the shop document where name matches
      await firestore.collection('shops').where('name', isEqualTo: shopName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'rating': rating,
            'rating': ratedby
          });
        });
      });

      print('Food added to shop successfully');
    } catch (e) {
      print('Error adding food to shop: $e');
    }
  }

  Future<void> makeOrder(OrderModel orderModel) async {

    int total=0;
    if(orderModel.foods!=null)
      {
        for(var order in orderModel.foods!)
        {
          if(order.price!=null)
            {
              total=total+order.price!;
            }
        }
      }
    orderModel.totalPrice=total+30;
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add the restaurant data to the Firestore collection "orders"
      DocumentReference docRef = await firestore.collection('orders').add(orderModel.toJson());

      // Get the ID of the newly added document
      String orderId = docRef.id;

      // Set the ID in the OrderModel
      orderModel.orderId = orderId;

      // Update the document with the modified OrderModel
      await docRef.update(orderModel.toJson());
    } catch (e) {
      // Handle any errors that might occur
      print('Error adding order to Firestore: $e');
      throw e;
    }
  }

}