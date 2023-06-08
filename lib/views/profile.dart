// ignore_for_file: unnecessary_new, prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'dart:ui';

import 'package:campusgoo/utility/color.dart';
import 'package:campusgoo/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class profilePagee extends StatefulWidget {
  const profilePagee({super.key});

  @override
  State<profilePagee> createState() => _profilePageState();
}

class _profilePageState extends State<profilePagee> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  String? indirmeBaglantisi;

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = Path.basename(_photo!.path);
    final destination = 'userProfil/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('userProfile/');
      ref.putFile(_photo!);
      String url = await (await ref.putFile(_photo!)).ref.getDownloadURL();
      setState(() {
        indirmeBaglantisi = url;
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'images': imagesController.text = url as String});

        //imagesController.text = url as String;
      });
    } catch (e) {
      print('error occured');
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    return await auth.signOut();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deleteUser() async {
    User? user = _auth.currentUser;
    await user!.delete();
    // Kullanıcı hesabı silindi
  }

  Future<void> profilInfo() async {}
  Future<void> cikisYap() async {
    await Navigator.pushReplacement(
        context, (MaterialPageRoute(builder: (context) => const UserLogin())));
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('userStatus', isEqualTo: 1)
      .snapshots();

  void accountDelete() {
    FirebaseFirestore.instance
        .collection("productss")
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((document) {
        document.reference.update({'user.userStatus': 0, 'productStatus': 0});
      });
    });

    FirebaseFirestore.instance
        .collection("users")
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((document) {
        document.reference.update({'userStatus': 0});
      });

      //deleteUser();
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => UserLogin())));
    });

    // Navigator.of(context).pop();
  }

  TextEditingController imagesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  (MaterialPageRoute(builder: (context) => const UserLogin())));
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: mainColor.color,
            ))
      ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('hatalı işlem');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              String images = data['images']!;
              print("******");
              print(data['name']);
              print("******");

              return Column(
                children: [
                  Center(
                    child: Text(
                      "Profilim",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 22),
                    ),
                  ),
                  _sizedBox(),
                  Stack(children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((context) {
                              return Container(
                                child: new Wrap(
                                  children: <Widget>[
                                    new ListTile(
                                        leading: new Icon(Icons.photo_library),
                                        title: new Text('Gallery'),
                                        onTap: () {
                                          imgFromGallery();
                                          Navigator.of(context).pop();
                                        }),
                                    new ListTile(
                                      leading: new Icon(Icons.photo_camera),
                                      title: new Text('Camera'),
                                      onTap: () {
                                        imgFromCamera();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }));
                      },
                      child: SizedBox(
                          width: 150,
                          height: 150,
                          child: CircleAvatar(
                            child: _photo == null
                                ? SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CircleAvatar(
                                      backgroundColor: mainColor.color,
                                      backgroundImage: NetworkImage(
                                          data['images'].toString()),
                                    ),
                                  )
                                : SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: CircleAvatar(
                                          backgroundColor: mainColor.color,
                                          backgroundImage: FileImage(_photo!),
                                        ))),
                            backgroundColor: Colors.black,
                          )),
                    ),
                    Positioned(
                      top: 100,
                      left: 105,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_enhance_outlined,
                              color: mainColor.color,
                            )),
                      ),
                    )
                  ]),
                  _sizedBox(),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 100, right: 50),
                      child: Text(
                        data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 90, right: 50),
                      child: Text(
                        "@" + data['email'],
                      ),
                    ),
                  ),
                  _myButton(320, 50, "Profil bilgileri", profilInfo),
                  _sizedBox(),
                  SizedBox(
                    width: 320,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {},
                        child: ListTile(
                            title: Text(
                              "Hesabı Sil",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                            trailing: PopupMenuButton(
                              icon: Icon(
                                Icons.navigate_next,
                                size: 30,
                              ),
                              itemBuilder: ((context) => [
                                    PopupMenuItem(
                                      child: Text("Hesabı Sil"),
                                      value: 1,
                                    )
                                  ]),
                              onSelected: (value) {
                                if (value == 1) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Hesabı sil"),
                                          content: Text(
                                              "Hesabı silmek istediğinize emin misiniz?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Vazgeç")),
                                            TextButton(
                                              onPressed: () {
                                                accountDelete();
                                              },
                                              child: Text('Sil'),
                                            )
                                          ],
                                        );
                                      });
                                }
                              },
                            ))),
                  ),
                  _sizedBox(),
                  _myButton(320, 50, "Çıkış Yap", cikisYap),
                ],
              );
            }).toList());
          }),
    );
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 20,
    );
  }

  SizedBox _myButton(
      double width, double height, String metin, Future<void> fonksiyon()) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: () {},
          child: ListTile(
            title: Text(
              metin,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            trailing: IconButton(
                onPressed: fonksiyon,
                icon: Icon(
                  Icons.navigate_next,
                  size: 30,
                )),
          )),
    );
  }
}
//Icons.keyboard_arrow_down,
