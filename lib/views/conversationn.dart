import 'package:campusgoo/utility/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'messageDetail.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  String user = FirebaseAuth.instance.currentUser!.uid;



  void deleteChatRoom(String roomId) {
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .update({'status': 0}).then((value) {
      FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(roomId)
          .collection("messages")
          .where("from", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot document) {
          document.reference.update({'status': 0});
        });
      });
      print('Sohbet silindi!');
    }).catchError((error) {
      print('Sohbet silinirken hata oluştu: $error');
    });
  }

    final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('chat_rooms')
      .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .where("status", isEqualTo: 1)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 280, top: 40),
            child: Text(
              "CampusGo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: mainColor.color,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Text(
                  "Sohbetler",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    PopupMenuButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 1,
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Sohbeti Sil",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 1) {
                          print("Sohbet silindi");
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No messages');
              }
              return Expanded(
                  child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  String receiverId = data['receiverId'].toString();
                  String senderId = data['senderId'].toString();
                  String senderName = data['senderName'].toString();
                  String message = data['lastMessage'].toString();
                  String product_id = data['product_id'].toString();
                  String images = data['images'].toString();
                  String product_name = data['product_name'].toString();

                  var lastMessage = '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageDetail(
                            userId: FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            postId: product_id.toString(),
                            //name: senderName.toString(),
                            resim: images.toString(),
                            product_name: product_name.toString(),
                            // user: senderId.toString(),
                            user: senderName.toString(),
                            roomId: data.id,
                            postUserId: receiverId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: images.toString() == ""
                                  ? const CircleAvatar(
                                      child: Text("No img"),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(images),
                                    ),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  senderName,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "RobotoCondensed",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  message,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontFamily: "RobotoCondensed",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 30),
                          Column(
                            children: [
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text("Sohbeti Sil"),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 1) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Sohbeti Sil'),
                                          content: const Text(
                                              'Bu sohbeti silmek istediğinize emin misiniz?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Vazgeç'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Sil'),
                                              onPressed: () {
                                                // Sohbeti silme işlemi burada odanın id'si alınarak mesaj silme işlemi tamamlandı
                                                deleteChatRoom(data.id);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
