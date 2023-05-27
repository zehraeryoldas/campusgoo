

import 'package:campusgoo/utility/color.dart';
import 'package:flutter/material.dart';

import 'myAds.dart';
import 'myFavs.dart';

class adsPage extends StatefulWidget {
  @override
  State<adsPage> createState() => _adsPageState();
}

class _adsPageState extends State<adsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                _logoText(),
              ],
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
                //overlayColor: MaterialStateProperty.all(Colors.red),
                unselectedLabelColor: Colors.grey,
                indicatorColor: mainColor.color,
                labelColor: mainColor.color,
                tabs: [
                  _myTab("İlanlarım",
                      Icon(Icons.ads_click, color: mainColor.color)),
                  _myTab(
                      "Favorilerim",
                      Icon(
                        Icons.favorite,
                        color: mainColor.color,
                      ))
                ]),
          ),
          body: TabBarView(
            children: [
              ilanlarim(),
              favorilerim(),
            ],
          ),
        ),
      ),
    );
  }

  Text _logoText() {
    return Text(
      "CampusGo",
      style: TextStyle(
          fontSize: 20, color: mainColor.color, fontWeight: FontWeight.w500),
    );
  }

  Tab _myTab(String text, Icon icon) {
    return Tab(
        child: Text(text
            //style: TextStyle(color: mainColor.color),
            ),
        icon: icon);
  }
}
