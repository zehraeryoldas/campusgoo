
import 'package:campusgoo/models/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class productService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<String?> addHedef(
    String? name,
    String? status,
    String? description,
    String? images,
    int? price,
    //int? id,
    String? categoryId,
    //String? userId,
    String? location,
  ) async {
    productModel product_Model = productModel(
      name: name,
      status: status,
      description: description,
      price: price,
      //id: id,
      categoryId: categoryId,
      location: location,
      images: images,
    );

    String sonuc = "";

    DocumentReference sonuc2 = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var userId = sonuc2.id;

    DocumentReference sonuc3 = await FirebaseFirestore.instance
        .collection("productss")
        .add(product_Model.toJson());

    // var idx = sonuc1.id;
    var ids = sonuc3.id;
    print("******");
    // print(idx);
    print("******");

    FirebaseFirestore.instance.collection("productss").doc(ids).update({
      'id': ids,
      'userId': userId,
      'productStatus': 1,
    });

    //öncelikle eklenecek belgenin bulunduğu koleksiyonun referansını alıyoruz
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    //ekleneck belgenin referansını alıyoruz. Ve eklenecek dokumanının adını belirtiyoruz.
    DocumentReference orderRef =
        FirebaseFirestore.instance.collection('productss').doc(ids);
    //eklenecek belgeyi önce alınan koleksiyon referansından getiriyoruz
    DocumentSnapshot userSnapshot =
        await usersRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    //son olarak eklenecek belgeyi hedef belgenin veri alanına ekliyoruz.
    orderRef.update({'user': userSnapshot.data()});
    return null;
  }
}
