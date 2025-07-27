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

  // Optional: create global keys to access state of each tab
  final chatsKey = GlobalKey<State<StatefulWidget>>();
  final groupsKey = GlobalKey<State<StatefulWidget>>();
  final broadcastsKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void _refreshCurrentTab() {
    switch (_tabController.index) {
      case 0:
        (chatsKey.currentState as dynamic)?.refreshChats();
        break;
      case 1:
        (groupsKey.currentState as dynamic)?.refreshChats();
        break;
      case 2:
        (broadcastsKey.currentState as dynamic)?.refreshChats();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text("Buzz"),
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
          tabs: const [
            Tab(text: "Chats"),
            Tab(text: "Groups"),
            Tab(text: "Broadcasts"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatsListPage(key: chatsKey),
          GroupsListPage(key: groupsKey),
          BroadcastsListPage(key: broadcastsKey),
        ],
      ),
      floatingActionButton: GlobalSpeedDial(onActionComplete: _refreshCurrentTab),
    );
  }
}
