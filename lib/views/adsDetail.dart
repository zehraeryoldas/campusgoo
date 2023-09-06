// ignore_for_file: unnecessary_string_interpolations
import 'package:campusgoo/utility/color.dart';
import 'package:campusgoo/views/messageDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../arayuz.dart';
import '../utility/firebaseChat.dart';
import 'myAdsUpdate.dart';

class AllAdsDetailPage extends StatefulWidget {
  final String? postId;
  final String? postUserId;
  final String? user;
  final String? resim;
  final String? name;
  final int? price;
  final String? durum;
  final String? aciklama;
  final String? konum;
  final String? category;

  const AllAdsDetailPage({
    super.key,
    this.postId,
    this.postUserId,
    this.resim,
    this.name,
    this.price,
    this.durum,
    this.aciklama,
    this.konum,
    this.user,
    this.category,
  });

  @override
  State<AllAdsDetailPage> createState() => _AllAdsDetailPageState();
}

class _AllAdsDetailPageState extends State<AllAdsDetailPage> {
  void edit() {
    setState(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyAdsUpdate(
                    id: widget.postId.toString(),
                    name: widget.name.toString(),
                    aciklama: widget.aciklama.toString(),
                    durum: widget.durum.toString(),
                    idx: widget.postId.toString(),
                    konum: widget.konum.toString(),
                    price: widget.price!.toInt(),
                    resim: widget.resim.toString(),
                    kategori: widget.category.toString(),
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name.toString(),
            style: const TextStyle(color: Colors.black),
          ),
          leading: _arrowBackButton(context),
          actions: [
            widget.postUserId == currentUser
                ? _myAds()
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                    ))
          ],
        ),
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _imageContainer(context),
            _myDivider(),

            _myListtile("${widget.price} " " \u20ba", "${widget.name}",
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            _myDivider(),
            const Text("    Detaylar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(
              height: 10,
            ),
            Text(
              "     DURUM:                 ${widget.durum}",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            _myDivider(),
            _myListtile(" Açıklama", "  ${widget.aciklama}",
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            _myDivider(),
            _myListtile(" Konum", "  ${widget.konum}",
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            _myDivider(),
            //_myListtile(metin, metin2)
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: mainColor.color,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ))),
              title: const Text("Profil Bilgileri",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(
                "${widget.user}",
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            _myDivider(),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.postUserId == currentUser
                      ? Container()
                      : _sohbetButton(context),
                  widget.postUserId == currentUser
                      ? Container()
                      : _yuzyuzeTalepButton(context),
                ],
              ),
            )
          ],
        ));
  }

  ListTile _myListtile(String metin, String metin2, TextStyle style) {
    return ListTile(
      title: Text(metin, style: style),
      subtitle: Text(metin2, style: const TextStyle(fontSize: 16)),
    );
  }

  Container _imageContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage("${widget.resim}"),
      )),
    );
  }

  IconButton _arrowBackButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Arayuz()));
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ));
  }

  Row _myAds() {
    return Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: Colors.black,
            )),
        IconButton(
            onPressed: () {
              edit();
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ))
      ],
    );
  }

  SizedBox _yuzyuzeTalepButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const chat())));
          },
          icon: const Icon(Icons.handshake_outlined),
          label: const Text("Yüzyüze Talep"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(mainColor.color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.black))))),
    );
  }

  SizedBox _sohbetButton(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        onPressed: () {
          print('here');
          //burada öncelikle sohbet odası var ise eğer bir daha oluşturmayıp detay sayfasına geçiyor
          var uid = FirebaseAuth.instance.currentUser!.uid;
          FirebaseFirestore.instance
              .collection("chat_rooms")
              .where('product_id', isEqualTo: widget.postId)
              .where('users', arrayContains: uid)
              .get()
              .then((value) {
            //value.docs ifadesi bu koleksiyondaki tüm belgeleri içeren bir liste döndürür
            if (value.docs.isNotEmpty) {
              print('is not new');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageDetail(
                    userId: FirebaseAuth.instance.currentUser!.uid.toString(),
                    postId: widget.postId,
                    resim: widget.resim,
                    product_name: widget.name,
                    user: widget.user,
                    roomId: value.docs[0].id,
                    postUserId: widget.postUserId,
                  ),
                ),
              );
            } else {
              //eğer sohbet odası yok ise de json formatında yeniden oluşturuyoruz.
              print('is new');
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get()
                  .then((snapshot) {
                if (snapshot.exists) {
                  String username = snapshot.data()!['name'];
                  FirebaseFirestore.instance.collection('chat_rooms').add({
                    'lastMessage': '',
                    'timeStamp': DateTime.now(),
                    'senderName': username,
                    'senderId': uid,
                    'status': 0,
                    'receiverId': widget.postUserId,
                    'product_id': widget.postId,
                    'product_name': widget.name,
                    'images': widget.resim,
                    'users': [widget.postUserId, uid],
                  }).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetail(
                          userId:
                              FirebaseAuth.instance.currentUser!.uid.toString(),
                          postId: widget.postId,
                          //name: senderName.toString(),
                          resim: widget.resim,
                          product_name: widget.name,
                          user: username,
                          roomId: value.id,
                        ),
                      ),
                    );
                  });
                }
              });
            }
          });
        },
        icon: const Icon(Icons.message),
        label: const Text("Sohbet"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(mainColor.color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.black)))),
      ),
    );
  }

  Divider _myDivider() {
    return const Divider(
      height: 10,
      color: Colors.black,
    );
  }
}
