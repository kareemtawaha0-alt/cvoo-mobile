import 'package:flutter/material.dart';

Widget clientNav(int idx)=> NavigationBar(selectedIndex: idx, destinations: const [
  NavigationDestination(icon: Icon(Icons.create), label: 'Create Order'),
  NavigationDestination(icon: Icon(Icons.list_alt), label: 'My Orders'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
  NavigationDestination(icon: Icon(Icons.info_outline), label: 'About Us'),
]);

Widget employeeNav(int idx)=> NavigationBar(selectedIndex: idx, destinations: const [
  NavigationDestination(icon: Icon(Icons.assignment), label: 'Orders'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
]);
