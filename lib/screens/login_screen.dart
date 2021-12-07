import 'package:app1/screens/home_screen.dart';
import 'package:app1/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //Form Anahtarı
  final _formKey=GlobalKey<FormState>();

  //Düzenleyici Kontrolleri
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //Firebase işlemleri
  final _auth = FirebaseAuth.instance;




  @override
  Widget build(BuildContext context) {
    //Email Alanı
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value)
      {
        if(value!.isEmpty)
        {
          return  ("Lütfen E-Posta adresinizi girin");
        }
        //E-posta geçersiz ise uyarı mesajı veren metod
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
        {
          return ("Lütfen geçerli bir e-posta adresi girin");
        }
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "E-Posta Adresiniz",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),


    );

    //Şifre Alanı
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value){
        RegExp regex = new RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return ("Şifreniz giriş için gereklidir");
        }
        if(!regex.hasMatch(value)){
          return ("Geçerli bir şifre girin(Min. 6 karakter)");
        }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifreniz",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    final loginButton = Material(
       elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);


        },
        child: Text("Giriş Yap" , textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 200,
                      child: Image.asset("assets/logo.png",
                        fit: BoxFit.contain,
                      )),
                    SizedBox(height: 45),

                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        Text("Hesabınız yok mu?"),
                        GestureDetector(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                        },
                          child: Text("  Kayıt Ol",
                            style: TextStyle(
                              color: Colors.redAccent,
                                fontWeight: FontWeight.bold, fontSize: 15),),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



//Giriş fonksiyonu
void signIn(String email,String password) async {
  if(_formKey.currentState!.validate())
    await _auth.signInWithEmailAndPassword(email: email, password: password)
     .then((uid) => {
       Fluttertoast.showToast(msg: "Giriş Başarılı"),
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())),

    }).catchError((e)
    {
      Fluttertoast.showToast(msg: e!.message);

    });
  }
}

