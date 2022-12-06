import 'dart:async';

import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:practica6/firebase/auth_services.dart';
import 'package:practica6/models/user.dart';
import 'package:practica6/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../decorations/input_decorations.dart';
import '../firebase/user_services.dart';
import '../provider/login_form_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthServices>(context);
    final userServices = Provider.of<UserServices>(context);

    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 200),
        CardContainer(
            child: Column(children: [
          Text('Autenticación', style: Theme.of(context).textTheme.headline4),
          const _LoginForm(),
        ])),
        const SizedBox(
          height: 10,
        ),
      ]),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authProvider = Provider.of<AuthServices>(context);
    final userServices = Provider.of<UserServices>(context);

    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();

    return Form(
      key: loginForm.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            style: const TextStyle(color: Colors.black),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Correo electrónico',
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(
                  Icons.mail,
                ),
              ),
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : "Error! en el correo";
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
              style: const TextStyle(color: Colors.black),
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.password,
                  ),
                ),
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null) && (value.length >= 6)
                    ? null
                    : 'Error! en Password';
              }),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Color.fromARGB(148, 158, 158, 158),
              elevation: 0,
              color: Color.fromARGB(255, 0, 131, 197),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!loginForm.isValidForm()) {
                        btnController.error();
                        await Future.delayed(const Duration(seconds: 2));
                        btnController.reset();
                      }
                      loginForm.isLoading = true;
                      await Future.delayed(const Duration(seconds: 2));
                      UserDAO us =
                          await authProvider.signInWithEmailAndPassword(
                              email: loginForm.email,
                              password: loginForm.password);
                      if (us != null) {
                        loginForm.isLoading = false;
                        userServices.loadUser(us);
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        btnController.error();
                        await Future.delayed(const Duration(seconds: 2));
                        btnController.reset();
                        loginForm.isLoading = false;
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? "Iniciando..." : 'Iniciar sesión',
                    style: const TextStyle(color: Colors.white),
                  ))),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Color.fromARGB(148, 158, 158, 158),
              elevation: 0,
              color: Color.fromARGB(255, 0, 131, 197),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/register',
                );
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? "..." : 'Registrarse con Correo',
                    style: const TextStyle(color: Colors.white),
                  ))),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'O iniciar sesión con:',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlutterSocialButton(
                onTap: () async {
                  UserDAO us = (await authProvider.signInWithGoogle())!;
                  userServices.loadUser(us);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                mini: true,
                buttonType: ButtonType.google,
              ),
              FlutterSocialButton(
                onTap: () async {
                  UserDAO us = await authProvider.signInWithFacebook();
                  userServices.loadUser(us);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                mini: true,
                buttonType: ButtonType.facebook,
              ),
              FlutterSocialButton(
                onTap: () {},
                mini: true,
                buttonType: ButtonType.github,
              ),
            ],
          )
        ],
      ),
    );
  }
}
