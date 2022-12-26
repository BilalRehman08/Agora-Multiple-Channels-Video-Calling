import 'package:agora_ui_kit/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsConstant.backgroundColor,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            accountName: Text(
              'John Doe',
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(
              'johndoe@example.com',
              style: TextStyle(fontSize: 15),
            ),
            currentAccountPicture: CircleAvatar(
                // backgroundImage: AssetImage('assetName'),
                ),
          ),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            trailing: const Icon(Icons.settings, color: Colors.white),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            trailing: const Icon(Icons.logout, color: Colors.white),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
