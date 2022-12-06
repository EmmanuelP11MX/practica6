import 'package:practica6/firebase/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final User user = ModalRoute.of(context)!.settings.arguments as User;
    final authProvider = Provider.of<AuthServices>(context);
    final userProvider = Provider.of<UserServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardScreen'),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context)
                .primaryColor //This will change the drawer background to blue.
            //other styles
            ),
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: userProvider.userDAO.fullName!.isNotEmpty
                    ? Text(userProvider.userDAO.fullName!)
                    : const Text('Usuario'),
                accountEmail: userProvider.userDAO.email!.isNotEmpty
                    ? Text(userProvider.userDAO.email!)
                    : const Text('Email'),
                currentAccountPicture: Hero(
                  tag: "hero",
                  child: CircleAvatar(
                    backgroundImage: userProvider.userDAO.image!.isNotEmpty
                        ? NetworkImage(userProvider.userDAO.image!)
                        : const NetworkImage(
                            'https://i.pinimg.com/736x/ce/9f/5d/ce9f5dcf5e84a012b34b61ec3e4dbdb3.jpg'),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                      'https://www.fairmont-mayakoba.com/wp-content/uploads/2020/09/christmas-tree-new-year-glare-merry-christmas-happy-new-year-1147x717.jpg'),
                  fit: BoxFit.cover,
                  opacity: 50,
                )),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Cerras Sesión',
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  await authProvider.signOut().then((value) {
                    Navigator.pushReplacementNamed(context, '/login');
                  });
                },
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
