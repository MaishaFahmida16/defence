class Restaurant {
  int? rating;
  int? ratedBy;
  int? visited;
  int totalDelivery;
  int totalSell;
  int platformFee;
  int? sellLimit;
  String? id;
  List<String>? reviews;
  String? email;
  String? name;
  String? ownerId;
  String? image;
  double? lat;
  double? long;
  String? address;
  bool? deliveryAvailable;
  List<String>? deliveryManId;
  List<String>? orderList;
  List<Food>? foods;

  Restaurant({
    this.rating,
    this.sellLimit,
    required this.totalDelivery,
    required this.totalSell,
    required this.platformFee,
    this.ratedBy,
    this.visited,
    this.reviews,
    this.id,
    this.email,
    this.name,
    this.ownerId,
    this.image,
    this.lat,
    this.long,
    this.address,
    this.deliveryAvailable,
    this.deliveryManId,
    this.orderList,
    this.foods,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      rating: json['rating'],
      sellLimit: json['sellLimit'],
      totalDelivery: json['totalDelivery'],
      totalSell: json['totalSell'],
      platformFee: json['platformFee'],
      ratedBy: json['rated_by'],
      id: json['id'],
      visited: json['visited'],
      reviews: json['reviews'] != null ? List<String>.from(json['reviews']) : null,
      email: json['email'],
      name: json['name'],
      ownerId: json['ownerId'],
      image: json['image'],
      lat: json['lat'],
      long: json['long'],
      address: json['address'],
      deliveryAvailable: json['delivery_available'],
      deliveryManId: json['deliveryManId'] != null ? List<String>.from(json['deliveryManId']) : null,
      orderList: json['orderList'] != null ? List<String>.from(json['orderList']) : null,
      foods: json['foods'] != null ? (json['foods'] as List).map((item) => Food.fromJson(item)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['sellLimit'] = this.sellLimit;
    data['totalDelivery'] = this.totalDelivery;
    data['totalSell'] = this.totalSell;
    data['platformFee'] = this.platformFee;
    data['id'] = this.id;
    data['visited'] = this.visited;
    data['rated_by'] = this.ratedBy;
    data['reviews'] = this.reviews;
    data['email'] = this.email;
    data['name'] = this.name;
    data['ownerId'] = this.ownerId;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    data['delivery_available'] = this.deliveryAvailable;
    data['deliveryManId'] = this.deliveryManId;
    data['orderList'] = this.orderList;
    data['foods'] = this.foods != null ? this.foods!.map((food) => food.toJson()).toList() : null;
    return data;
  }
}

class Food {
  String? foodName;
  String? foodImage;
  String? category;
  bool? deliveryOn;
  int? rating;
  int? price;
  int? discount;
  int? ordered;
  int? visited;
  int? ratedBy;
  List<String>? reviews;

  Food({
    this.foodName,
    this.deliveryOn,
    this.ordered,
    this.visited,
    this.foodImage,
    this.rating,
    this.ratedBy,
    this.reviews,
    this.category,
    this.discount,
    this.price
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodName: json['foodName'],
      deliveryOn: json['deliveryOn'],
      ordered: json['ordered'],
      visited: json['visited'],
      foodImage: json['foodImage'],
      price: json['price'],
      discount: json['discount'],
      category: json['category'],
      rating: json['rating'],
      ratedBy: json['rated_by'],
      reviews: json['reviews'] != null ? List<String>.from(json['reviews']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodName'] = this.foodName;
    data['deliveryOn'] = this.deliveryOn;
    data['ordered'] = this.ordered;
    data['visited'] = this.visited;
    data['foodImage'] = this.foodImage;
    data['rating'] = this.rating;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['category'] = this.category;
    data['rated_by'] = this.ratedBy;
    data['reviews'] = this.reviews;
    return data;
  }
}
