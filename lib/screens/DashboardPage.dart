// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

// Screens
import 'package:buzz/screens/BroadcastsListPage.dart';
import 'package:buzz/screens/GroupsListPage.dart';
import 'package:buzz/screens/ChatsListPage.dart';

// components
import '../components/GlobalSpeedDial.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text("Buzz"),
        actions: [
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedUser02),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          dividerHeight: 0.5,
          tabs: [
            Tab(text: "Chats"),
            Tab(text: "Groups"),
            Tab(text: "Broadcasts"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [ChatsListPage(), GroupsListPage(), BroadcastsListPage()],
      ),
    );
  }
}
