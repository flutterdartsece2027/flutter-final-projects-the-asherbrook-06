// packages
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

// components
import 'package:buzz/components/ChatCard.dart';

// controllers
import 'package:buzz/controllers/UserController.dart';
import 'package:buzz/controllers/ChatController.dart';

// models
import 'package:buzz/models/User.dart';
import 'package:buzz/models/Chat.dart';

class BroadcastsListPage extends StatefulWidget {
  const BroadcastsListPage({super.key});

  @override
  State<BroadcastsListPage> createState() => _BroadcastsListPageState();
}

class _BroadcastsListPageState extends State<BroadcastsListPage> {
  final TextEditingController _searchController = TextEditingController();
  final UserController _userController = UserController();
  final ChatController _chatController = ChatController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final Map<String, UserModel?> _contactsMap = {};
  List<Chat> _filteredChats = [];
  List<Chat> _chats = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_filterChats);
  }

  Future<void> _initializeData() async {
    final userContacts = await _userController.getContactsList(currentUserId);
    final contactsMap = <String, UserModel?>{};

    for (var userId in userContacts) {
      contactsMap[userId] = await _userController.getUserById(userId);
    }
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = _chats.where((chat) {
        final chatDisplayName = chat.displayName;
        final matchesDisplayName = chatDisplayName.toLowerCase().contains(query);

        final matchesMember = chat.members.any((uid) {
          final contact = _contactsMap[uid];
          if (contact == null) return false;
          return contact.name.toLowerCase().contains(query) || contact.email.toLowerCase().contains(query);
        });

        return matchesDisplayName || matchesMember;
      }).toList();
    });
  }

  Future<void> _refreshChats() async {
    final updatedChats = await _chatController.getChatsForUser(currentUserId);
    final filtered = updatedChats.where((chat) => chat.isGroup && chat.isBroadcast).toList();
    setState(() {
      _chats = filtered;
      _filteredChats = _searchController.text.isEmpty ? _chats : _filteredChats;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.light ? "light" : "dark";

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshChats,
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: StreamBuilder<List<Chat>>(
          stream: _chatController.getChatsOverviewStream(currentUserId, true, true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState(context, theme, hasChats: false);
            }

            _chats = snapshot.data!.where((chat) => chat.isGroup && chat.isBroadcast).toList();
            _filteredChats = _searchController.text.isEmpty ? _chats : _filteredChats;

            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
                  floating: false,
                  delegate: SearchBar(controller: _searchController),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (_filteredChats.isEmpty) {
                      return _buildEmptyState(context, theme, hasChats: true);
                    }
                    return ChatCard(chatModel: _filteredChats[index], currentUserId: currentUserId);
                  }, childCount: _filteredChats.isEmpty ? 1 : _filteredChats.length),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String theme, {required bool hasChats}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          SvgPicture.asset("assets/$theme/begin_chat.svg", width: 220),
          const SizedBox(height: 24),
          Text(
            hasChats ? "No Broadcasts found" : "It's a bit lonely in here",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            hasChats ? "Try a different name or email" : "Create a broadcast to get started",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class SearchBar extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  SearchBar({required this.controller});

  @override
  double get minExtent => 0;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Opacity(
      opacity: shrinkOffset < maxExtent ? 1.0 : 0.0,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            hintText: 'Search broadcasts...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SearchBar oldDelegate) => false;
}
