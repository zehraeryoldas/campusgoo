
import 'package:campusgoo/services/user_service.dart';
import 'package:campusgoo/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController namecontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController telefonNocontroller = TextEditingController();

  TextEditingController sifreController = TextEditingController();
  TextEditingController sifretekrarController = TextEditingController();
  TextEditingController imagesController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  String name = "kullanıcı adı";
  String email = "email";
  String telefonno = "telefon";

  String sifre = "şifre";
  String sifreTekrar = "şifre doğrula";

  String kayitOl1 = "Kayıt Ol";
  String girisYap1 = "Giriş Yap";

  void showMessage(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Şifreler Uyuşmuyor'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void showMessage2(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Kayıt Başarılı!'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  signOut() async {
    return await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String topImage = "assets/images/topImage.png";
    return Scaffold(
        backgroundColor: Color(0xff21254A),
        body: SafeArea(
          child: ListView(
            children: [
              topImageContainer(height, topImage),
              Column(
                children: [
                  Text(
                    "WELCOME, \nBACK!",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  _myContainers(
                      name,
                      namecontroller,
                      TextInputType.name,
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                  _myContainers(
                      email,
                      emailcontroller,
                      TextInputType.emailAddress,
                      Icon(
                        Icons.email,
                        color: Colors.white,
                      )),
                  _myContainers(
                      telefonno,
                      telefonNocontroller,
                      TextInputType.phone,
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                      )),
                  _myContainers(
                      sifre,
                      sifreController,
                      TextInputType.name,
                      Icon(
                        Icons.password,
                        color: Colors.white,
                      )),
                  _myContainers(
                      sifreTekrar,
                      sifretekrarController,
                      TextInputType.name,
                      Icon(
                        Icons.password,
                        color: Colors.white,
                      )),
                  _elevatedButton(kayitOl1, Icon(Icons.start)),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserLogin()));
                      },
                      child: Text("Giris Sayfasina Dön",
                          style: TextStyle(color: Colors.pink.shade200)))
                ],
              ),
            ],
          ),
        ));
  }

  Container topImageContainer(double height, String topImage) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
         fit: BoxFit.fitHeight,
          image: AssetImage(topImage),
        ),
      ),
    );
  }

  Padding _elevatedButton(
    String text,
    Icon icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff31274F))),
          icon: icon,
          onPressed: () async {
            showMessage2(context);
            if (sifreController.text == sifretekrarController.text) {
              await auth.createUserWithEmailAndPassword(
                  email: emailcontroller.text, password: sifreController.text);
            } else {
              showMessage(context);
            }
            userService().addHedef2(
              emailcontroller.text,
              namecontroller.text,
              int.tryParse(telefonNocontroller.text),
              imagesController.text,
            );
          },
          label: Text(text)),
    );
  }

  Container _myContainers(String metin, TextEditingController controller,
      TextInputType type, Icon icon) {
    return Container(
      width: 273,
      height: 50,
      child: TextField(
        style: TextStyle(color: Colors.white),
        keyboardType: type,
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: icon,
          label: Text(
            metin,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
