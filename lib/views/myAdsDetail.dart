
import 'package:campusgoo/views/ads.dart';
import 'package:campusgoo/views/myAdsUpdate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyAdsDetail extends StatefulWidget {
  const MyAdsDetail({
    super.key,
    required this.id,
    required this.idx,
    required this.resim,
    required this.name,
    required this.price,
    required this.durum,
    required this.aciklama,
    required this.konum,
    required this.kategori,
  });

  final String id;
  final String idx;
  final String resim;
  final String name;
  final int price;
  final String durum;
  final String aciklama;
  final String konum;
  final String kategori;

  @override
  State<MyAdsDetail> createState() => _MyAdsDetailState();
}

class _MyAdsDetailState extends State<MyAdsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => adsPage()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                    )),
                PopupMenuButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  itemBuilder: ((context) => [
                        PopupMenuItem(
                          child: Text("Güncelle"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Sil"),
                          value: 2,
                        ),
                      ]),
                  onSelected: (menuItemValue) {
                    if (menuItemValue == 1) {
                      print("güncellendi");
                      setState(() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAdsUpdate(
                                      id: widget.idx,
                                      name: widget.name,
                                      aciklama: widget.aciklama,
                                      durum: widget.durum,
                                      idx: widget.idx,
                                      konum: widget.konum,
                                      price: widget.price,
                                      resim: widget.resim,
                                      kategori: widget.kategori,
                                    )));
                      });
                    }
                    if (menuItemValue == 2) {
                      setState(() {
                        FirebaseFirestore.instance
                            .collection("productss")
                            .where('name', isEqualTo: "${widget.name}")
                            .get()
                            .then((snapshot) {
                          snapshot.docs.forEach((document) {
                            document.reference.delete();
                          });
                        });
                      });
                    }
                  },
                )
              ],
            )
          ],
        ),
        body: ListView(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage("${widget.resim}"),
              )),
            ),
            _myDivider(),
            ListTile(
              title: Text("${widget.price}" + " \u20ba",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              subtitle:
                  Text("${widget.name}", style: const TextStyle(fontSize: 16)),
            ),
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
            ListTile(
              title: const Text(" Açıklama",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(
                "  ${widget.aciklama}",
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            _myDivider(),
            ListTile(
              title: const Text(" Konum",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(
                "  ${widget.konum}",
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            _myDivider(),
          ],
        ));
  }

  Divider _myDivider() {
    return const Divider(
      height: 10,
      color: Colors.black,
    );
  }
}
