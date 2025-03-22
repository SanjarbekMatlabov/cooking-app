import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  // Navigatsiya marshrutlari
  static const List<String> _routes = [
    '/home',
    '/add-recipe',
    '/profile',
  ];

  // Tugma bosilganda marshrutni o‘zgartirish
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      context.go(_routes[index]);
    }
  }

  // Joriy marshrutga qarab indeksni aniqlash
  int _getCurrentIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/add-recipe':
        return 1;
      case '/profile':
        return 2;
      default:
        return 0; // Agar marshrut topilmasa, standart /home
    }
  }

  @override
  Widget build(BuildContext context) {
    // Joriy marshrutni olish
    final String currentLocation = GoRouterState.of(context).matchedLocation;
    _selectedIndex = _getCurrentIndex(currentLocation);

    return Scaffold(
      body: widget.child, // Sahifa kontenti
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bosh Sahifa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Qo‘shish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Belgilangan joylashuv
      ),
    );
  }
}