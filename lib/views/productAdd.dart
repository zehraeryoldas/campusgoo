// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_new

import 'dart:io';

import 'package:campusgoo/utility/color.dart';
import 'package:campusgoo/views/call_backDropDown.dart';
import 'package:campusgoo/services/products_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:path/path.dart';

class payPage extends StatefulWidget {
  const payPage({super.key});

  @override
  State<payPage> createState() => _payPageState();
}

class _payPageState extends State<payPage> {
  void showMessage(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Kayıt Başarılı'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);

        //sonradan eklendi
                //imagesController.text=_photo.toString();

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

        //        //sonradan eklendi
        //imagesController.text=_photo.toString();
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
  String? indirmeBaglantisi;

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination).child(FirebaseAuth.instance.currentUser!.uid)
          .child('file/');
      ref.putFile(_photo!);
      String url=await(await ref.putFile(_photo!)).ref.getDownloadURL();
      setState(() {
         indirmeBaglantisi=url; 
      imagesController.text=url as String; 
      });
    } catch (e) {
      print('error occured');
    }
  }

  TextEditingController descriptionController = TextEditingController();
  TextEditingController imagesController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final CategoryIdController = TextEditingController();
  final locationIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  CollectionReference sneakers =
      FirebaseFirestore.instance.collection("category");
  CollectionReference location =
      FirebaseFirestore.instance.collection("location");
  String? dropdownValue;
  String? dropdownValue1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(
          "Ne Satıyorsun",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    mainColor.color,
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder?>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)))),
              onPressed: () {
                
                showMessage(context);
                productService().addHedef(
                    nameController.text,
                    statusController.text,
                    descriptionController.text,
                    imagesController.text,
                    int.parse(priceController.text),
                    CategoryIdController.text,
                    locationIdController.text);
                    
                   
              },
              icon: Icon(Icons.save),
              label: Text("Kaydet")),
          Divider(
            color: mainColor.color,
            thickness: 3,
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
                child: Column(
              children: [
                _myTextField("Ürün adı*", nameController, TextInputType.none),
                _myTextField("Ne sattığını açıkla*", descriptionController,
                    TextInputType.none),
                _myTextField("Fiyat*", priceController, TextInputType.number),
                CallBackDropDown(onUserselected: (CallBackUser? user) {
                  statusController.text = user!.name.toString();
                }),
                _category(),
                _location(),
                imageMethod(context),
                
              ],
            ))
          ],
        ),
      ),
    );
  }

  GestureDetector imageMethod(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: mainColor.color,
        child: _photo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  _photo!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                width: 100,
                height: 100,
                child: Lottie.network(
                    "https://assets7.lottiefiles.com/packages/lf20_urbk83vw.json")),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
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
            ),
          );
        });
  }

  Widget _myTextField(
      String metin, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(metin),
          // border:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.pink))
        ),
        controller: controller,
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> _category() {
    return StreamBuilder<QuerySnapshot>(
        stream: sneakers.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return Container(
            width: double.infinity,
            child: DropdownButton<String>(
              hint: Text("Kategori"),
              onChanged: (String? newValue) {
                setState(() {
                  CategoryIdController.text = newValue!;
                  dropdownValue = newValue;
                });
              },
              value: dropdownValue,
              items: snapshot.data!.docs.map((DocumentSnapshot doc) {
                return DropdownMenuItem(
                  child: Text(doc['name']),
                  value: doc.reference.id.toString(),
                );
              }).toList(),
            ),
          );
        });
  }

  StreamBuilder<QuerySnapshot<Object?>> _location() {
    return StreamBuilder<QuerySnapshot>(
        stream: location.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return Container(
            width: double.infinity,
            child: DropdownButton<String>(
              hint: Text("Konum"),
              onChanged: (String? newValue) {
                setState(() {
                  locationIdController.text = newValue!;
                  dropdownValue1 = newValue;
                });
              },
              value: dropdownValue1,
              items: snapshot.data!.docs.map((DocumentSnapshot doc) {
                return DropdownMenuItem(
                  child: Text(doc['name']),
                  //value: doc.reference.id.toString(),
                  value: doc['name'].toString(),
                );
              }).toList(),
            ),
          );
        });
  }
}
