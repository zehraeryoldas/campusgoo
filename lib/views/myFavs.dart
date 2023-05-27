import 'package:campusgoo/models/products_model.dart';
import 'package:campusgoo/utility/color.dart';
import 'package:campusgoo/views/myFavsDEtailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // dart:async kütüphanesini içe aktar

// Diğer kodlarınız

class favorilerim extends StatefulWidget {
  @override
  State<favorilerim> createState() => _favorilerimState();
}

class _favorilerimState extends State<favorilerim> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<productModel>> getFavoriteProducts() async {
    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection("favorites")
        .get();
    // favoritesSnapshot nesnesinin belgelerinin
    //post_id alanlarını içeren bir liste oluşturuldu
    // ve favoritesList değişkenine atandı.
    final favoritesList =
        favoritesSnapshot.docs.map((doc) => doc.data()['post_id']).toList();

    final productsSnapshot =
        await FirebaseFirestore.instance.collection('productss').get();
    final productList = productsSnapshot.docs
        .map((doc) => productModel.fromDocumentSnapshot(doc))
        .toList();

    final favoriteProducts = productList
        .where((product) => favoritesList.contains(product.id))
        .toList();

    return favoriteProducts;
  }

  @override
  void initState() {
    super.initState();
    print("hello");
    getFavorites();
  }

  Future<void> getFavorites() async {
    print("sajdksnödksö");

    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('favorites')
        .get()
        .then((value) {
      print('value length  ' + value.docs.length.toString());
      value.docs.forEach((element) {
        setState(() {
          favorites.add(element.get('post_id'));
        });
        // print(element.get('post_id'));
      });
    });
  }

  var favorites = <String>[];

  Future<void> removeFromFavoritesCollection(String postId) async {
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('favorites')
        .doc(postId)
        .delete()
        .then((value) {
      setState(() {
        favorites.remove(postId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<productModel>>(
          future: getFavoriteProducts(),
          builder: (BuildContext context,
              AsyncSnapshot<List<productModel>> snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return CircularProgressIndicator(); // veri bekleniyor göstergesi
            // } 
             if (snapshot.hasError) {
              return Text('Bir hata oluştu: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final favoriteProducts = snapshot.data!;

              if (favoriteProducts.isEmpty) {
                return Text('Favori ürün yok.');
              } else {
                return ListView.builder(
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];
                    String postId = product.id.toString();
                    String postUserId = product.userId.toString();
                    String images = product.images.toString();
                    int price = product.price!.toInt();
                    String name = product.name.toString();
                    String description = product.description.toString();
                    String status = product.status.toString();
                    String location = product.location.toString();
                    

                    print("????????");
                    print("******");
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyFavsDEtailPage(
                                      id: postUserId,
                                      idx: postId,
                                      resim: images,
                                      name: name,
                                      price: price,
                                      durum: status,
                                      aciklama: description,
                                      konum: location,
                                      //user: userInfo
                                    )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30.0,
                          ),
                        ),
                        child: Row(children: [
                          Container(
                            //color: Colors.red,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey.shade300),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        product.images.toString()))),
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                          Expanded(
                            child: Container(
                              width: 40,
                              height: MediaQuery.of(context).size.height * 0.12,
                              child: ListTile(
                                title: Text(
                                    product.price.toString() + " \u20ba",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontFamily: "RobotoCondensed")),
                                subtitle: Text(product.name.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "RobotoCondensed")),
                                trailing: favorites.contains(postId)
                                    ? IconButton(
                                        onPressed: () async {
                                          removeFromFavoritesCollection(postId);
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: mainColor.color,
                                        ))
                                    : IconButton(
                                        onPressed: () async {
                                          print("0000000");
                                          print("0000000");
                                        },
                                        icon: Icon(
                                          Icons.favorite_border,
                                        )),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              }
            }
             else {
              return Text('Bir şeyler ters gitti.');
            }
          },
        ),
      ),
    );
  }
}
