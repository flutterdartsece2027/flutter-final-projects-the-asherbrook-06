// packages
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// pages
import 'package:fixit/screens/HomePage.dart';
import 'package:fixit/screens/MapPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Widget> screens = [HomePage(), MapPage()];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedHome01), label: ""),
          BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedMaps), label: ""),
        ],
        onTap: (value) => setState(() {
          currentPage = value;
        }),
      ),
      body: screens[currentPage],
    );
  }
}
