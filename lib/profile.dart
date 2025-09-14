import 'package:flutter/material.dart';
import 'address_screen.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'sheets.dart';


class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          _buildItem(Icons.inventory_2_outlined, "My Orders"),
          const Divider(height: 1),
          _buildItem(Icons.person_outline, "My Details"),
          _buildItem(
            Icons.home_outlined,
            "Address Book",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressPage()),
              );
            },
          ),
          _buildItem(Icons.help_outline, "FAQs"),
          _buildItem(Icons.headset_mic_outlined, "Help Center"),
          SizedBox(height: 70,),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              LogoutDialog.show(context);
            },
          ),
          SizedBox(height: 80,)
        ],
      ),

    );
  }

  Widget _buildItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }


}