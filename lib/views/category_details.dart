

import 'package:campusgoo/utility/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../arayuz.dart';
import 'allAdsDetail.dart';

class categoryDetails extends StatefulWidget {
  const categoryDetails(
      {super.key, required this.category_id, this.category_name});
  final String category_id;
  final String? category_name;

  @override
  State<categoryDetails> createState() => _categoryDetailsState();
}

class _categoryDetailsState extends State<categoryDetails> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
  String? _category_id;
  Stream<QuerySnapshot>? _categoryStream;

  @override
  void initState() {
    super.initState();
    _category_id = widget.category_id;

    _categoryStream = FirebaseFirestore.instance
        .collection('productss')
        .where("productStatus", isEqualTo: 1)
        .where('user.userStatus', isEqualTo: 1)
        .where('category_id', isEqualTo: _category_id)
        //normalde isEqualTo: widget.category_id yazacaktık ama başlatıcı hatası alındı.
        // widget.category_id initstate içinde bir değişkene atanarak bu şekilde erişim sağlanabilindi.
        .snapshots();
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
      });
    });
  }

  var favorites = <String>[];

  Future<void> addToFavoritesCollection(String postId) async {
    var data = <String, dynamic>{'post_id': postId};
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('favorites')
        .doc(postId)
        .set(data)
        .then((value) {
      setState(() {
        favorites.add(postId);
      });
    });
  }

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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Arayuz()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          widget.category_name.toString(),
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _categoryStream,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // veri bekleniyor göstergesi
            }else if (snapshot.hasError) {
              return Text('Bir hata oluştu: ${snapshot.error}');
            }
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                String postUserId = data['userId'].toString();
                String postId = data['id'].toString();
                String resim = data['images'].toString();
                String name = data['name'].toString();
                int price = data['price'];
                String durum = data['status'];
                String aciklama = data['description'];
                String konum = data['location'];
                String user = data['user.name'].toString();

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllAdsDetailPage(
                                  postId: postId,
                                  postUserId: postUserId,
                                  price: price,
                                  name: name,
                                  resim: resim,
                                  durum: durum,
                                  aciklama: aciklama,
                                  konum: konum,
                                  user: user,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.0, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(18)),
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(children: [
                            Container(
                              //color: mainColor.color,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  image: NetworkImage(data['images']),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.80,
                              height: MediaQuery.of(context).size.height * 0.16,
                            ),
                            Positioned(
                              left: 120,
                              bottom: 90,
                              child: favorites.contains(postId)
                                  ? IconButton(
                                      onPressed: () {
                                        removeFromFavoritesCollection(postId);
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: mainColor.color,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        addToFavoritesCollection(postId);
                                      },
                                      icon: Icon(
                                        Icons.favorite_border,
                                      ),
                                    ),
                            )
                          ]),
                          Text(
                            data['name'],
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18.0,
                                fontFamily: "RobotoCondensed"),
                          ),
                          Text(
                            data['price'].toString() + "\u20ba",
                            style: TextStyle(
                                color: mainColor.color,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          })),
    );
  }
}
