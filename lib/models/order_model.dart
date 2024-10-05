import 'package:firebase/models/shop_model.dart';

class OrderModel {
  String? orderId;
  String? userId;
  String? shopId;
  String? status;
  String? address;
  String? distance;
  String? deliveryManId;
  int? prepareTime;
  int? totalPrice;
  bool? accepted;
  bool? onTheWay;
  bool? userCancel;
  bool? shopCancel;
  bool? delivered;
  List<Food>? foods;
  String? datetime; // Nullable datetime field

  OrderModel({
    this.orderId,
    this.totalPrice,
    this.userId,
    this.deliveryManId,
    this.shopId,
    this.status,
    this.userCancel,
    this.shopCancel,
    this.address,
    this.distance,
    this.prepareTime,
    this.accepted,
    this.onTheWay,
    this.delivered,
    this.foods,
    this.datetime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var foodList = json['foods'] as List;
    List<Food> foodItems = foodList.map((foodItem) => Food.fromJson(foodItem)).toList();

    return OrderModel(
      orderId: json['orderId'],
      totalPrice: json['totalPrice'],
      userCancel: json['userCancel'],
      deliveryManId: json['deliveryManId'],
      shopCancel: json['shopCancel'],
      userId: json['userId'],
      shopId: json['shopId'],
      status: json['status'],
      address: json['address'],
      distance: json['distance'],
      prepareTime: json['prepareTime'],
      accepted: json['accepted'],
      onTheWay: json['onTheWay'],
      delivered: json['delivered'],
      foods: foodItems,
      datetime: json['datetime'], // Assign datetime field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'totalPrice': totalPrice,
      'deliveryManId': deliveryManId,
      'userId': userId,
      'userCancel': userCancel,
      'shopCancel': shopCancel,
      'shopId': shopId,
      'status': status,
      'address': address,
      'distance': distance,
      'prepareTime': prepareTime,
      'accepted': accepted,
      'onTheWay': onTheWay,
      'delivered': delivered,
      'foods': foods?.map((foodItem) => foodItem.toJson()).toList(),
      'datetime': datetime, // Include datetime field in JSON
    };
  }
}
