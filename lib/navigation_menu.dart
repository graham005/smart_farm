import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_farm/pages/home_page.dart';
import 'package:smart_farm/pages/tasks/task_manager.dart';
import 'package:smart_farm/pages/weather_page.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    TaskManagerPage(),
    Center(child: Text('Calculator Page')),
    WeatherPage(),
  ];

  void _onDestinationSelected(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 70,
        elevation: 0,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.task_alt_rounded), label: 'Tasks'),
          NavigationDestination(
            icon: Icon(Icons.calculate), label: 'Calculator'),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.cloudSunRain), label: 'Weather'),
        ]),
        body: _pages[_selectedIndex],
    );
  }
}


