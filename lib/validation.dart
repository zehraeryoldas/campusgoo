
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'arayuz.dart';
import 'login.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _userLoginState();
}

class _userLoginState extends State<UserLogin> {
  void showMessage(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('email ve şifre bilgilerini kontrol ediniz!'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
   void showMessage2(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Mail hesabına sıfırlama linki gönderildi!'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String sifre = "şifre";
  String email = "email";

  String kayitOl1 = "Kayıt Ol";
  String girisYap1 = "Giriş Yap";
  String url =
      "https://cdn.pixabay.com/photo/2019/06/06/16/02/technology-4256272_960_720.jpg";

  bool _isObscure = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
   showMessage2(context);

  }

  Future<void> girisYap() async {
    try {
      await auth
          .signInWithEmailAndPassword(
              email: emailcontroller.text, password: sifreController.text)
          .then((kullanici) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Arayuz()));
      });
    } on Exception catch (e) {
      showMessage(context);
      // TODO
    }
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
                    "CAMPUS, \nGO!",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _myContainers(
                        email,
                        emailcontroller,
                        TextInputType.emailAddress,
                        Icon(
                          Icons.email,
                          color: Colors.white70,
                        )),
                  ),
                  sifrecontainer(),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        resetPassword(emailcontroller.text);
                      },
                      child: Text(
                        "-------------Şifremi Unuttum-------------",
                        style: TextStyle(color: Colors.pink.shade200),
                      ),
                    ),
                  ),
                  _elevatedButton(girisYap1, Icon(Icons.start), girisYap),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(color: Colors.pink.shade200),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Container sifrecontainer() {
    return Container(
      //decoration: BoxDecoration(color: Colors.transparent),
      width: 273,
      height: 54,
      child: TextField(
        obscureText: _isObscure,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.white),
        controller: sifreController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
          ),
          prefixIcon: Icon(
            Icons.password,
            color: Colors.white70,
          ),
          label: Text(
            "sifre",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Container topImageContainer(double height, String topImage) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          
          image: AssetImage(topImage,),
          
        ),
      ),
    );
  }

  Padding _elevatedButton(String text, Icon icon, Future<void> fonksiyon()) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff31274F))),
          icon: icon,
          onPressed: fonksiyon,
          label: Text(text)),
    );
  }

  Container _myContainers(String metin, TextEditingController controller,
      TextInputType type, Icon icon) {
    return Container(
     
      width: 273,
      height: 54,
      child: TextField(
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.white),
        keyboardType: type,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          label: Text(
            metin,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
