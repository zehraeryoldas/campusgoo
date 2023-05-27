// ignore_for_file: prefer_const_literals_to_create_immutables



import 'package:campusgoo/views/Conversation.dart';
import 'package:campusgoo/views/ads.dart';
import 'package:campusgoo/views/conversationn.dart';
import 'package:campusgoo/views/homee.dart';
import 'package:campusgoo/views/productAdd.dart';
import 'package:campusgoo/views/profile.dart';
import 'package:flutter/material.dart';

class Arayuz extends StatefulWidget {
  const Arayuz({Key? key}) : super(key: key);

  @override
  State<Arayuz> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<Arayuz> {
  int guncel_no = 0;
  late List<Widget> icerikler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icerikler = [
      //ImageUploads(),

      const homePage(),
      Conversation(),
      const payPage(),
      adsPage(),

      const profilePagee(),
    ];
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: icerikler[guncel_no],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: guncel_no,
        selectedItemColor: Color.fromARGB(255, 79, 50, 135),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "AnaSayfa"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: "Sohbet"),
          const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ekle"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.ads_click), label: "ilanlar"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (int tiklama) {
          setState(() {
            guncel_no = tiklama;
          });
        },
      ),
    );
  }
}
