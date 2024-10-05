class UserModel {
  String? name;
  String? id;
  String? email;
  String? address;
  String? favShop;
  String? favFood;
  String? phone;
  String? image;
  String? shopId;
  int? income;

  UserModel({
    this.name,
    this.income,
    this.id,
    this.email,
    this.address,
    this.favShop,
    this.favFood,
    this.phone,
    this.image,
    this.shopId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      income: json['income'],
      id: json['id'],
      email: json['email'],
      address: json['address'],
      favShop: json['favshop'],
      favFood: json['favfood'],
      phone: json['phone'],
      image: json['image'],
      shopId: json['shopid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['income'] = income;
    data['id'] = id;
    data['email'] = email;
    data['address'] = address;
    data['favshop'] = favShop;
    data['favfood'] = favFood;
    data['phone'] = phone;
    data['image'] = image;
    data['shopid'] = shopId;
    return data;
  }
}
