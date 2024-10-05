import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnBoardRep{

  Future<void> addUserToFirestore(UserModel user, String path, String docId) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a document reference with the provided docId
      final DocumentReference docRef = firestore.collection(path).doc(docId);

      // Set the data of the document using the UserModel.toJson() method
      await docRef.set(user.toJson());

      print('User added to Firestore with ID: $docId');
    } catch (e) {
      // Handle any errors that might occur
      print('Error adding user to Firestore: $e');
      throw e;
    }
  }

  Future<String> getUserType(String docId) async {
    // Assume you have access to Firestore instance
    // and your collections are named "users" and "shopkeepers"

    // Check if docId exists in "users" collection
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(docId).get();
    if (userDoc.exists) {
      return 'users';
    }

    // Check if docId exists in "shopkeepers" collection
    var shopkeeperDoc = await FirebaseFirestore.instance.collection('shopkeepers').doc(docId).get();
    if (shopkeeperDoc.exists) {
      return 'shopkeepers';
    }

    var deliveryManrDoc = await FirebaseFirestore.instance.collection('deliveryman').doc(docId).get();
    if (deliveryManrDoc.exists) {
      return 'deliveryman';
    }

    // DocId not found in either collection
    return '';
  }

  Future<int> getSizeOfCollection(String path) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(path)
        .get();

    return querySnapshot.size;
  }

  Future<UserModel> getUserModelFromFirestore(String path, String docId) async {
    try {
      // Get a reference to the Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the document snapshot
      DocumentSnapshot docSnapshot = await firestore.collection(path).doc(docId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Convert the data into a UserModel object
        return UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        // Document not found
        throw Exception('Document not found');
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error fetching user from Firestore: $e');
      rethrow;
    }
  }

}