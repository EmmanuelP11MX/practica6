import 'package:practica6/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../decorations/input_decorations.dart';
import '../firebase/auth_services.dart';
import '../provider/login_form_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 270),
        CardContainer(
            child: Column(children: [
          Text('Registro', style: Theme.of(context).textTheme.headline4),
          ChangeNotifierProvider(
              create: (_) => LoginFormProvider(), child: const _RegisterForm())
        ])),
      ]),
    )));
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({super.key});

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  AuthServices? _emailAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailAuth = AuthServices();
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

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
                  Icons.email,
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
                    : 'Error! en el password';
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
                      _emailAuth!
                          .createUserWithEmailAndPassword(
                              email: loginForm.email,
                              password: loginForm.password)
                          .then((value) {
                        print(value);
                      });
                      loginForm.isLoading = false;
                      Navigator.pushReplacementNamed(context, '/login');
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? "Creando..." : 'Crear cuenta',
                    style: const TextStyle(color: Colors.white),
                  ))),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
