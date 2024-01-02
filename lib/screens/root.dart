import 'package:climia/screens/home_screen.dart';
import 'package:climia/screens/notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class Root extends StatefulWidget {

  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}


class _RootState extends State<Root> {
  int selectedIndex = 0;
  Future<void> getPermission() async {
    bool locationEnabled;
    LocationPermission permission;

    locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }
  final pages = [
    HomeScreen( ),
    NotificationScreen(),
  ];
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
