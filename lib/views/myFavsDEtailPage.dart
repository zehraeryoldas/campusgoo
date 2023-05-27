import 'package:campusgoo/utility/color.dart';
import 'package:campusgoo/views/ads.dart';
import 'package:campusgoo/views/urunDetayMesaj.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utility/firebaseChat.dart';


class MyFavsDEtailPage extends StatefulWidget {
  const MyFavsDEtailPage(
      {super.key,
      required this.id,
      required this.idx,
      required this.resim,
      required this.name,
      required this.price,
      required this.durum,
      required this.aciklama,
      required this.konum,
      });
  final String id;
  final String idx;
  final String resim;
  final String name;
  final int price;
  final String durum;
  final String aciklama;
  final String konum;
 

  @override
  State<MyFavsDEtailPage> createState() => _MyFavsDEtailPageState();
}

class _MyFavsDEtailPageState extends State<MyFavsDEtailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white70,
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => adsPage()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.share,color: Colors.black,))
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
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: mainColor.color,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ))),
              title: const Text("Profil Bilgileri",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              // subtitle: Text(
              //   "${widget.user}",
              //   style: TextStyle(
              //     color: Colors.grey.shade800,
              //   ),
              // ),
            ),
            _myDivider(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print("000000000");
                        print(widget.id);
                        print("000000000");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => urunDetayMesajlasma(
                                      postUserId: widget.id, price: widget.price, name: widget.name, resim: widget.resim,
                                    ))));
                      },
                      icon: Icon(Icons.message),
                      label: Text("Sohbet"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(mainColor.color),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black)))),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                        onPressed: () {
                                Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => chat(
                                      
                                    ))));

                        },
                        icon: Icon(Icons.handshake_outlined),
                        label: Text("Yüzyüze Talep"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(mainColor.color),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black))))),
                  ),
                ],
              ),
            )
          ],
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
