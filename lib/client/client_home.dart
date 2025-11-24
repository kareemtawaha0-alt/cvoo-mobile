import 'package:flutter/material.dart';
import 'client_create_order_screen.dart';
import 'client_orders_screen.dart';
import 'client_profile_screen.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _index = 0;

  final List<Widget> _pages = const [
    ClientCreateOrderScreen(),
    ClientOrdersScreen(),
    ClientProfileScreen(),
  ];

  final Color bgColor = const Color(0xFF0D0D0D);
  final Color bottomBarColor = const Color(0xFF1A1A1A);
  final Color mainColor = const Color(0xFF5C7AFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bottomBarColor,
        elevation: 0,
        title: Text(
          ['Create Order', 'My Orders', 'Profile'][_index],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: _pages[_index],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bottomBarColor,
          border: Border(top: BorderSide(color: Colors.grey.shade800, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: bottomBarColor,
          currentIndex: _index,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.white70,
          elevation: 0,
          onTap: (i) => setState(() => _index = i),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

