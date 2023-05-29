import 'package:campusgoo/arayuz.dart';
import 'package:campusgoo/utility/color.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageDetail extends StatefulWidget {
  MessageDetail(
      {super.key,
      this.postId,
      this.postUserId,
      this.user,
      this.resim,
      // this.name,
      this.product_name,
      this.userId,
      required this.roomId});
  final String? postId;
  final String? postUserId;
  final String? user;
  final String? resim;
  //final String? name;
  final String? product_name;
  final String? userId;
  final String roomId;

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  TextEditingController messageController = TextEditingController();

  void messageAdded(String text) {
    // Geçerli kullanıcının kimliğini alın
    final user = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        //kullanıcının adının firebase veritabanında bulunup bulunmadığını kontrol etmek için kullanılır
        String username = snapshot.data()!['name'];

        FirebaseFirestore.instance
            .collection('chat_rooms')
            .doc(widget.roomId)
            .collection('messages')
            .add({
          'date': DateTime.now(),
          'from': user,
          'to': widget.postUserId,
          'message': messageController.text,
        }).then((value) {
          FirebaseFirestore.instance
              .collection("chat_rooms")
              .doc(widget.roomId)
              .update({'lastMessage': messageController.text});
          //mesaj firebase başarıyla kaydedildiğinde bu satır çalışır
          messageController.text = '';
          bildirimGoster(text);
        }).catchError((error) {
          //mesajın kaydedilme sırasında eğer bir hata verirlirse bu satır çalışır
          print('Mesaj ekleme hatası: $error');
        });
      } else {
        //Eğer kullanıcı adı veritabanında bulunmazsa, kullanıcı adının bulunamadığını belirten bir mesaj yazdıralım
        print('Kullanıcı adı bulunamadı');
      }
    }).catchError((error) {
      print('Kullanıcı adını alma hatası: $error');
    });
  }

  void messageRemoved() {
    FirebaseFirestore.instance
        .collection("chats")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
        document.reference.delete();
      });
    }).catchError((error) {
      print("Error removing messages: $error");
    });
  }

  var flp = FlutterLocalNotificationsPlugin();

  Future<void> androidKurulum() async {
    var androidAyari =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosAyari = const DarwinInitializationSettings();
    //ayarlar oluşturulduktan sonra birleştiriyorum
    var kurulumAyari =
        InitializationSettings(android: androidAyari, iOS: iosAyari);
    await flp.initialize(kurulumAyari,
        onDidReceiveNotificationResponse: bildirimSecilme);
    //bu şekilde hem android hem ios için ayarlar verildi,
    //birleştirildi kurulum gerçekleştrildi.
  }

  Future<void> bildirimSecilme(
      NotificationResponse notificationResponse) async {
    var payLoad = notificationResponse.payload;
    if (payLoad != null) {
      print("Bildirim seçildi,$payLoad");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //uygulama ilk açıldığında
    //kurulum fonksiyonunu gerçekleştiriyoruz.
    // Bununla işlerimizi halledebiliyoruz.
    // androidKurulum();
  }

  Future<void> bildirimGoster(String message) async {
    var androidBildirimDetay = const AndroidNotificationDetails(
        "kanal id", "kanal başlık",
        channelDescription: "kanal açıklama",
        priority: Priority.high,
        importance: Importance.max);
    var iosBildirimDetay =
        const DarwinNotificationDetails(); //detaylandırma gerek yok ios bunu kendi hallediyor.
    //bu iki yapıyı birleştirelim
    var bildirimDetay = NotificationDetails(
        android: androidBildirimDetay, iOS: iosBildirimDetay);
    await androidKurulum(); // Bildirimleri başlat
    //mesajın gösterilmesi için başlık,içerik, detay bilgilerini verdik.
    await flp.show(0, widget.user!, message, bildirimDetay,
        payload: "payload içerik");
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.roomId)
        .collection('messages')
        .orderBy('date', descending: false)
        .snapshots();
    //final String userId = "pceXDyA3HagfmzQ8vyXw8vokOaz1";
    // final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
    //     .collection('chats')
    //     .where("users", isEqualTo: [currentUser, widget.user])
    //     .where("product_id", isEqualTo: widget.postId)
    //     .orderBy("timeStamp", descending: false)
    //     .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Arayuz()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        // title: Text(
        //   widget.product_name.toString(),
        //   style: const TextStyle(color: Colors.black, fontSize: 15),
        // ),
        title: Row(
          children: [
            SizedBox(
                width: 50,
                height: 50,
                child: Image.network(widget.resim.toString())),
            Expanded(
                child: ListTile(
              // title: Text(
              //   widget.name.toString(),
              //   style: const TextStyle(
              //       color: Colors.black,
              //       fontSize: 12,
              //       fontWeight: FontWeight.bold),
              // ),
              subtitle: Text(
                widget.product_name.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
            ))
          ],
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.black,
                  )),
              _messageRemovedPopupMenuButton(),
            ],
          )
        ],
      ),
      body: StreamBuilder(
          stream: chatStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            return Column(children: [
              _messageGet(snapshot),
              const Divider(
                thickness: 3,
              ),
              Row(
                children: [_messageSenderButton()],
              )
            ]);
          }),
    );
  }

  Expanded _messageGet(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.hasData) {
      return Expanded(
        child: ListView(
          children: snapshot.data!.docs
              .map((doc) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _myMessageScreen(doc),
                  ))
              .toList(),
        ),
      );
    } else {
      return Expanded(child: Container()); // Veri henüz yüklenmedi
    }
  }

  ListTile _myMessageScreen(QueryDocumentSnapshot<Object?> doc) {
    final bool isCurrentUser = widget.userId == doc['from'];

    return ListTile(
      title: Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: isCurrentUser
                      ? mainColor.color
                      : Colors.green, // Mesaj gönderenin ve alıcının renkleri
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  )),
              child: Text(doc['message'],
                  style: const TextStyle(color: Colors.white)))),
    );
  }

  Expanded _messageSenderButton() {
    void submitMessage(String text) {
      String message = messageController.text;
      messageAdded(
        message,
      ); // Kullanıcı adını burada belirtin veya dinamik olarak ayarlayın
      bildirimGoster(message);
    }

    return Expanded(
        child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(25), right: Radius.circular(25))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: submitMessage,
                    decoration: const InputDecoration(hintText: "Mesaj"),
                    controller: messageController,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      String message = messageController.text;
                      messageAdded(message);
                      bildirimGoster(message);
                    },
                    icon: const Icon(Icons.send))
              ],
            )));
  }

  PopupMenuButton<int> _messageRemovedPopupMenuButton() {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      itemBuilder: ((context) => [
            const PopupMenuItem(
              value: 1,
              child: Text("Sohbeti sil"),
            ),
          ]),
      onSelected: ((value) {
        if (value == 1) {
          messageRemoved();
        }
      }),
    );
  }
}
