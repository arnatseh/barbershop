import 'package:auth_buttons/auth_buttons.dart';
import 'package:barber_shop/page/product.dart';
import 'package:barber_shop/page/register.dart';
import 'package:barber_shop/service/auth_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController(text: "ping@gmail.com");
  final TextEditingController _password = TextEditingController(text: "123456");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          buildEmailInput(),
                          buildPasswordInput(),
                        ],
                      ),
                    ),
                    buildEmailSignin(),
                    buildEmailSignup(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailSignup() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ));
            },
            child: const Text("Register now !"),
          )
        ],
      ),
    );
  }
  
  Widget buildEmailSignin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EmailAuthButton(
        style: AuthButtonStyle(
          buttonColor: Colors.green
        ),
        onPressed: () {
          AuthService()
              .signInWithEmail(_email.text, _password.text)
              .then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const  ProductPage(),
                  )));
        },
      ),
    );
  }

  TextFormField buildEmailInput() {
    return TextFormField(
      controller: _email,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
        ),
        labelText: "E-mail",
        labelStyle: TextStyle()
      ),
    );
  }

  TextFormField buildPasswordInput() {
    return TextFormField(
      controller: _password,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
    );
  }
}
