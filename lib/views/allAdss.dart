import 'package:campusgoo/utility/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'allAdsDetail.dart';

class allAds extends StatefulWidget {
  const allAds({
    super.key,
  });
  @override
  State<allAds> createState() => _ilanlarimState();
}

class _ilanlarimState extends State<allAds> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('productss')
      .where("productStatus", isEqualTo: 1)
      .where('user.userStatus', isEqualTo: 1)
      .snapshots();

  @override
  void initState() {
    super.initState();

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

    // favorites.forEach((element) {
    //   print('element : ' + element);
    // });
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
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // veri bekleniyor göstergesi
          } else if (snapshot.hasError) {
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
                        side:
                            BorderSide(width: 1.0, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(children: [
                          _imagesContainer(data: data),
                          _favoributton(postId)
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
        }));
  }



  Positioned _favoributton(String postId) {
    return Positioned(
      left: 120,
      bottom: 70,
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
    );
  }
}

class _imagesContainer extends StatelessWidget {
  const _imagesContainer({
    super.key,
    required this.data,
  });

  final DocumentSnapshot<Object?> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: mainColor.color,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: NetworkImage(data['images']),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.40,
      height: MediaQuery.of(context).size.height * 0.14,
    );
  }
}
