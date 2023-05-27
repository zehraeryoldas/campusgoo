import 'package:cloud_firestore/cloud_firestore.dart';

class productModel {
  String? name;
  String? status;
  String? description;

  int? price;
  String? id;
  String? categoryId;
  String? userId;
  String? location;
  String? images;
  //bool? productsStatus;

  productModel({
    this.name,
    this.status,
    this.description,
    this.price,
    this.id,
    this.categoryId,
    this.userId,
    this.location,
    this.images,
   // this.productsStatus,
  });

  productModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    description = json['description'];

    price = json['price'];
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['userId'];
    location = json['location'];
    images = json['images'];
    //productsStatus = json['productsStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    data['description'] = this.description;

    data['price'] = this.price;
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['userId'] = this.userId;
    data['location'] = this.location;
    data['images'] = this.images;
    //data['productsStatus'] = this.productsStatus;
    return data;
  }
  factory productModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return productModel(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      price: data['price'],
      status: data['status'],
      location:data['location'],
      images:data['images']
    );
  }
}
