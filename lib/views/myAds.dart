import 'package:campusgoo/views/myAdsDetail.dart';
import 'package:campusgoo/views/myAdsUpdate.dart';
import 'package:campusgoo/views/productAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ilanlarim extends StatefulWidget {
  @override
  State<ilanlarim> createState() => _ilanlarimState();
}

class _ilanlarimState extends State<ilanlarim> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("productss")
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('productStatus', isEqualTo: 1)
      .where('user.userStatus', isEqualTo: 1)
      .snapshots();

  String? dropdownValue = 'Sil';

  payPage newyork = payPage();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('hatalı işlem');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                String postId = data['id']!.toString();

                String id = data['userId']!;
                String resim = data['images'].toString();
                String name = data['name'].toString();
                int price = data['price'];
                String durum = data['status'];
                String aciklama = data['description'];
                String konum = data['location'];
                String kategori = data['category_id'];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAdsDetail(
                                  id: id,
                                  resim: resim,
                                  name: name,
                                  price: price,
                                  durum: durum,
                                  aciklama: aciklama,
                                  konum: konum,
                                  idx: postId,
                                  kategori: kategori,
                                )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    // elevation: 10,
                    child: Row(children: [
                      Container(
                        //color: Colors.red,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                                image:
                                    NetworkImage(data['images'].toString()))),
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.12,
                      ),
                      Expanded(
                        child: Container(
                          width: 40,
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: ListTile(
                            title: Text(data['name'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                    fontFamily: "RobotoCondensed")),
                            subtitle:
                                Text(data['price'].toString() + " \u20ba"),
                            trailing: PopupMenuButton(
                              child: Icon(Icons.more_vert),
                              itemBuilder: ((context) => [
                                    PopupMenuItem(
                                      child: Text("İlanı kaldır"),
                                      value: 1,
                                    ),
                                    PopupMenuItem(
                                      child: Text("İlanı Güncelle"),
                                      value: 2,
                                    ),
                                  ]),
                              onSelected: (menuItemValue) {
                                if (menuItemValue == 1) {
                                  print("silindi");
                                  showDialog(
                                   // useSafeArea: true,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("İlanı kaldır"),
                                          content: Text(
                                              "İlanı kaldırmak istiyor musunuz?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Vazgeç")),
                                            TextButton(
                                                onPressed: () {
                                                  _urunSilme(data);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Kaldır'))
                                          ],
                                        );
                                      });
                                }
                                if (menuItemValue == 2) {
                                  print("güncellendi");
                                  setState(() {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyAdsUpdate(
                                                  id: postId,
                                                  name: name,
                                                  aciklama: aciklama,
                                                  durum: durum,
                                                  idx: postId,
                                                  konum: konum,
                                                  kategori: kategori,
                                                  price: price,
                                                  resim: resim,
                                                )));
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }));
        });
  }

  void _urunSilme(DocumentSnapshot<Object?> data) {
    return setState(() {
      FirebaseFirestore.instance
          .collection("productss")
          .where('name', isEqualTo: data['name'])
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((document) {
          document.reference.update({'productStatus': 0});
        });
      });
    });
  }
}
