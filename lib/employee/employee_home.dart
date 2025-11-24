import 'package:flutter/material.dart';
import 'employee_profile_screen.dart';
import 'employee_tasks_screen.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  int _index = 0;

  final Color bgColor = const Color(0xFF0D0D0D);
  final Color navColor = const Color(0xFF1A1A1A);
  final Color mainColor = const Color(0xFF5C7AFF);

  final List<Widget> _pages = const [
    EmployeeProfileScreen(),
    EmployeeTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: Text(
          _index == 0 ? 'My Profile' : 'Tasks',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: _pages[_index],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navColor,
          border: Border(
            top: BorderSide(color: Colors.grey.shade900, width: 0.7),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          backgroundColor: navColor,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.white70,
          elevation: 0,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              label: 'Tasks',
            ),
          ],
        ),
      ),
    );
  }
}
