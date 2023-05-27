// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:campusgo/utility/color.dart';
// import 'package:campusgo/views/allAdsDetail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class urunDetayMesajlasma extends StatefulWidget {
//   urunDetayMesajlasma(
//       {super.key,
//       this.postId,
//       this.postUserId,
//       this.user,
//       this.resim,
//       this.name,
//       this.price,
//       this.durum,
//       this.aciklama,
//       this.konum,
//       this.userId,
//       this.conversationId});
//   final String? postId;
//   final String? postUserId;
//   final String? user;
//   final String? resim;
//   final String? name;
//   final int? price;
//   final String? durum;
//   final String? aciklama;
//   final String? konum;
//   final String? userId;
//   final String? conversationId;

//   @override
//   State<urunDetayMesajlasma> createState() => _urunDetayMesajlasmaState();
// }

// class _urunDetayMesajlasmaState extends State<urunDetayMesajlasma> {
//   TextEditingController messageController = TextEditingController();
//   String user = FirebaseAuth.instance.currentUser!.uid;

//   // void messageAdded(String text, String userName) {
//   //   //final user = FirebaseAuth.instance.currentUser!.uid;
//   //   if (user != null) {
//   //     FirebaseFirestore.instance.collection("chats").add({
//   //       'message': text,
//   //       'timeStamp': DateTime.now(),
//   //       'senderId': user,
//   //       'senderName': userName,
//   //       'receiverId': widget.postUserId,
//   //       'product_id': widget.postId,
//   //       'product_name': widget.name,
//   //       'images': widget.resim,
//   //       'users': [widget.postUserId, user],
//   //     }).then((value) {
//   //       messageController.text = '';
//   //       bildirimGoster(text);
//   //     }).catchError((error) {
//   //       print("Error adding message: $error");
//   //     });
//   //   }
//   // }

//   void messageAdded(String text) {
//   final user = FirebaseAuth.instance.currentUser!.uid;
  
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(user)
//       .get()
//       .then((snapshot) {
//     if (snapshot.exists) {
//       String username = snapshot.data()!['name'];
//       FirebaseFirestore.instance.collection('chats').add({
//         'message': text,
//         'timeStamp': DateTime.now(),
//         'senderId': user,
//         'senderName': username,
//         'receiverId': widget.postUserId,
//         'product_id': widget.postId,
//         'product_name': widget.name,
//         'images': widget.resim,
//         'users': [widget.postUserId, user],
//       }).then((value) {
//         messageController.text = '';
//         bildirimGoster(text);
//       }).catchError((error) {
//         print('Mesaj ekleme hatası: $error');
//       });
//     } else {
//       print('Kullanıcı adı bulunamadı');
//     }
//   }).catchError((error) {
//     print('Kullanıcı adını alma hatası: $error');
//   });
// }


//   void messageRemoved() {
//     FirebaseFirestore.instance
//         .collection("chats")
//         // .doc(widget.postId)
//         // .collection("chats")
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
//         document.reference.delete();
//       });
//     }).catchError((error) {
//       print("Error removing messages: $error");
//     });
//   }

//   var flp = FlutterLocalNotificationsPlugin();

//   Future<void> androidKurulum() async {
//     var androidAyari =
//         const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var iosAyari = const DarwinInitializationSettings();
//     //ayarlar oluşturulduktan sonra birleştiriyorum
//     var kurulumAyari =
//         InitializationSettings(android: androidAyari, iOS: iosAyari);
//     await flp.initialize(kurulumAyari,
//         onDidReceiveNotificationResponse: bildirimSecilme);
//     //bu şekilde hem android hem ios için ayarlar verildi,
//     //birleştirildi kurulum gerçekleştrildi.
//   }

//   Future<void> bildirimSecilme(
//       NotificationResponse notificationResponse) async {
//     var payLoad = notificationResponse.payload;
//     if (payLoad != null) {
//       print("Bildirim seçildi,$payLoad");
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //uygulama ilk açıldığında
//     //kurulum fonksiyonunu gerçekleştiriyoruz.
//     // Bununla işlerimizi halledebiliyoruz.
//     // androidKurulum();
//   }

//   Future<void> bildirimGoster(String message) async {
//     var androidBildirimDetay = const AndroidNotificationDetails(
//         "kanal id", "kanal başlık",
//         channelDescription: "kanal açıklama",
//         priority: Priority.high,
//         importance: Importance.max);
//     var iosBildirimDetay =
//         const DarwinNotificationDetails(); //detaylandırma gerek yok ios bunu kendi hallediyor.
//     //bu iki yapıyı birleştirelim
//     var bildirimDetay = NotificationDetails(
//         android: androidBildirimDetay, iOS: iosBildirimDetay);
//     await androidKurulum(); // Bildirimleri başlat
//     //mesajın gösterilmesi için başlık,içerik, detay bilgilerini verdik.
//     await flp.show(0, widget.user!, message, bildirimDetay,
//         payload: "payload içerik");
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final String userId = "pceXDyA3HagfmzQ8vyXw8vokOaz1";
//     final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
//         .collection('chats')
//         .where("users", isEqualTo: [widget.postUserId, user])
//         .where("product_id", isEqualTo: widget.postId)
//         .orderBy("timeStamp", descending: false)
//         .snapshots();

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => AllAdsDetailPage(
//                             postId: widget.postId,
//                             resim: widget.resim,
//                             name: widget.name,
//                             price: widget.price,
//                             durum: widget.durum,
//                             aciklama: widget.aciklama,
//                             konum: widget.konum,
//                             user: widget.user,
//                           )));
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             )),
//         title: Row(
//           children: [
//             SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Image.network(widget.resim.toString())),
//             Expanded(
//                 child: ListTile(
//               title: Text(
//                 widget.user.toString(),
//                 style: TextStyle(color: Colors.black),
//               ),
//               subtitle: Text(
//                 widget.name.toString(),
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//             ))
//           ],
//         ),
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.call,
//                     color: Colors.black,
//                   )),
//               _messageRemovedPopupMenuButton(),
//             ],
//           )
//         ],
//       ),
//       body: StreamBuilder(
//           stream: messageStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Error : ${snapshot.error}');
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text("Loading...");
//             }

//             return Column(children: [
//               _messageGet(snapshot),
//               Divider(
//                 thickness: 3,
//               ),
//               Row(
//                 children: [_messageSenderButton()],
//               )
//             ]);
//           }),
//     );
//   }

//   Expanded _messageGet(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
//     if (snapshot.hasData) {
//       return Expanded(
//         child: ListView(
//           children: snapshot.data!.docs
//               .map((doc) => Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: _myMessageScreen(doc),
//                   ))
//               .toList(),
//         ),
//       );
//     } else {
//       return Expanded(child: Container()); // Veri henüz yüklenmedi
//     }
//   }

//   ListTile _myMessageScreen(QueryDocumentSnapshot<Object?> doc) {
//     final bool isCurrentUser = widget.userId == doc['senderId'];

//     return ListTile(
//       title: Align(
//           alignment:
//               isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//               padding: EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                   color: isCurrentUser
//                       ? mainColor.color
//                       : Colors.green, // Mesaj gönderenin ve alıcının renkleri
//                   borderRadius: BorderRadius.horizontal(
//                     left: Radius.circular(10),
//                     right: Radius.circular(10),
//                   )),
//               child:
//                   Text(doc['message'], style: TextStyle(color: Colors.white)))),
//     );
//   }

//   Expanded _messageSenderButton() {
//     void submitMessage(String text) {
//       String message = messageController.text;
//       messageAdded(message,
//           ); // Kullanıcı adını burada belirtin veya dinamik olarak ayarlayın
//       bildirimGoster(message);
//     }

//     return Expanded(
//         child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.horizontal(
//                     left: Radius.circular(25), right: Radius.circular(25))),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     onSubmitted: submitMessage,
//                     decoration: InputDecoration(hintText: "Mesaj"),
//                     controller: messageController,
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       String message = messageController.text;
//                       messageAdded(message);
//                       bildirimGoster(message);
//                     },
//                     icon: Icon(Icons.send))
//               ],
//             )));
//   }

//   PopupMenuButton<int> _messageRemovedPopupMenuButton() {
//     return PopupMenuButton(
//       icon: Icon(
//         Icons.more_vert,
//         color: Colors.black,
//       ),
//       itemBuilder: ((context) => [
//             PopupMenuItem(
//               child: Text("Sohbeti sil"),
//               value: 1,
//             ),
//           ]),
//       onSelected: ((value) {
//         if (value == 1) {
//           messageRemoved();
//         }
//       }),
//     );
//   }
// }

