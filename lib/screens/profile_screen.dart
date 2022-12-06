import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica6/decorations/input_decorations.dart';
import 'package:practica6/firebase/user_services.dart';
import 'package:practica6/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 42,
            ),
            const _Image(),
            const SizedBox(
              height: 10,
            ),
            CardContainer(
              child: Column(children: const [
                SizedBox(height: 0),
                _ProfileFrom(),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserServices>(context);
    final picker = ImagePicker();
    return Column(
      children: [
        Hero(
          tag: "hero",
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: profile.userDAO.image != ""
                  ? Image(
                      height: 350,
                      width: 350,
                      fit: BoxFit.cover,
                      image: NetworkImage(profile.userDAO.image!),
                    )
                  : const Image(
                      height: 350,
                      width: 350,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://i.pinimg.com/736x/ce/9f/5d/ce9f5dcf5e84a012b34b61ec3e4dbdb3.jpg'),
                    )),
        ),
        const SizedBox(
          height: 5,
        ),
        ImageControls(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 100);
                    if (pickedFile != null) {
                      print('Path ${pickedFile.path}');
                      File image = File(pickedFile.path);
                      profile.selectImage(image);
                    }
                  },
                  icon: const Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () async {
                    final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 100);
                    if (pickedFile != null) {
                      print(pickedFile.path);
                      File image = File(pickedFile.path);
                      profile.selectImage(image);
                    }
                  },
                  icon: const Icon(Icons.image, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileFrom extends StatelessWidget {
  const _ProfileFrom({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<UserServices>(context);
    final RoundedLoadingButtonController btnController =
        RoundedLoadingButtonController();
    return Form(
      key: profile.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.black),
            autocorrect: false,
            initialValue:
                profile.userDAO.fullName != "" ? profile.userDAO.fullName : "",
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre',
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
            onChanged: (value) => profile.userDAO.fullName = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            style: const TextStyle(color: Colors.black),
            autocorrect: false,
            initialValue:
                profile.userDAO.email != "" ? profile.userDAO.email : "",
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              prefixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(
                  Icons.email,
                ),
              ),
            ),
            onChanged: (value) => profile.userDAO.email = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
              style: const TextStyle(color: Colors.black),
              autocorrect: false,
              initialValue:
                  profile.userDAO.phone != "" ? profile.userDAO.phone : "",
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Numero de Telefono',
                prefixIcon: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.phone_android,
                  ),
                ),
              ),
              onChanged: (value) => profile.userDAO.phone = value,
              validator: (value) {
                return (value != null) && (value.length >= 10)
                    ? null
                    : 'ERROR! Numero Incompleto';
              }),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Color.fromARGB(146, 69, 69, 69),
              elevation: 15,
              color: Color.fromARGB(255, 1, 146, 224),
              onPressed: profile.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!profile.isValidForm()) {
                        btnController.error();
                        await Future.delayed(const Duration(seconds: 2));
                        btnController.reset();
                        return;
                      }
                      profile.isLoading = true;
                      profile.updateUser();
                      await Future.delayed(const Duration(seconds: 2));
                      profile.isLoading = false;
                      Navigator.pop(context);
                    },
              child: Container(
                  padding:
                      //const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Text(
                    profile.isLoading ? "Guardando..." : 'Guardar',
                    style: const TextStyle(color: Colors.white),
                  ))),
        ],
      ),
    );
  }
}
