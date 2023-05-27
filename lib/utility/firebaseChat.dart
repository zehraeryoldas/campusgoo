import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {

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
    //uygulama ilk açıldığında kurulum fonksiyonunu gerçekleştiriyoruz. Bununla işlerimizi halledebiliyoruz.
    androidKurulum();
  }

  Future<void> bildirimGoster() async {
    var androidBildirimDetay = const AndroidNotificationDetails(
        "kanal id", "kanal başlık",
        channelDescription: "kanal açıklama",
        priority: Priority.high,
        importance: Importance.max);
    var iosBildirimDetay=const DarwinNotificationDetails(); //detaylandırma gerek yok ios bunu kendi hallediyor.
    //bu iki yapıyı birleştirelim
    var bildirimDetay=NotificationDetails(android: androidBildirimDetay,iOS: iosBildirimDetay);
    //mesajın gösterilmesi için başlık,içerik, detay bilgilerini verdik.
    await flp.show(0, "Zehra", "Son fiyat nedir", bildirimDetay,payload: "payload içerik");
  }
   Future<void> gecikmeliBildirimGoster() async {
    var androidBildirimDetay = const AndroidNotificationDetails(
        "kanal id", "kanal başlık",
        channelDescription: "kanal açıklama",
        priority: Priority.high,
        importance: Importance.max);
    var iosBildirimDetay=const DarwinNotificationDetails(); //detaylandırma gerek yok ios bunu kendi hallediyor.
    //bu iki yapıyı birleştirelim
    var bildirimDetay=NotificationDetails(android: androidBildirimDetay,iOS: iosBildirimDetay);
    //mesajın gösterilmesi için başlık,içerik, detay bilgilerini verdik.
   tz.initializeTimeZones();
   var gecikme=tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)); //.add sayesinde gecikme ekliyoruz.mevcut zamanda gecikme yaptık.
   await flp.zonedSchedule(0, "fatmanur",
    "fiyat ne kadar",
     gecikme, 
     bildirimDetay, 
     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
     androidAllowWhileIdle: true //telefon ekranı kapalıyken bildirim geldiğinde ekranın uyanmasını sağlıyor.
     ,payload: "Payload içerik gecikmeli" //bildirime tıklandığında bilgi eklenir.

     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bildirim kullanımı.."),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () {
              bildirimGoster();
            }, child: Text("Bildirim olustur")),
            ElevatedButton(
                onPressed: () {
                  gecikmeliBildirimGoster();
                }, child: Text("Gecikmeli Bildirim olustur"))
          ],
        ),
      ),
    );
  }
}
