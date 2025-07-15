// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

// models
import 'package:buzz/models/Chat.dart';
import 'package:buzz/models/User.dart';

// controllers
import 'package:buzz/controllers/ChatController.dart';
import 'package:buzz/controllers/UserController.dart';

// components
import 'package:buzz/components/ContactCard.dart';

// auth
import 'package:buzz/auth/Auth.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final TextEditingController _searchController = TextEditingController();
  final UserController _contactsManager = UserController();
  UserModel? _currentUser;

  List<UserModel?> filteredContacts = [];
  List<UserModel> groupMembers = [];
  List<UserModel?> contacts = [];

  Future<void> _refreshContacts() async {
    final user = await _contactsManager.getUserById((await Auth().getCurrentUser(context))!.uid);

    final fetchedContacts = await Future.wait(
      user!.contacts.map((uid) async => await _contactsManager.getUserById(uid)).toList(),
    );
    setState(() {
      _currentUser = user;
      contacts = fetchedContacts;
      filteredContacts = fetchedContacts;
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact!.name.toLowerCase().contains(query) || contact.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
    _refreshContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = (View.of(context).platformDispatcher.platformBrightness == Brightness.light) ? "light" : "dark";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Group"),
            Text("${filteredContacts.length} contacts", style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        leading: IconButton(icon: Icon(HugeIcons.strokeRoundedArrowLeft01), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedUserAdd02),
            onPressed: () async {
              if (_currentUser != null) {
                await Navigator.pushNamed(context, '/addContact');
                await _refreshContacts();
              }
            },
          ),
        ],
      ),
      floatingActionButton: groupMembers.length < 2
          ? null
          : FloatingActionButton(
              elevation: 1,
              child: Icon(HugeIcons.strokeRoundedSent),
              onPressed: () async {
                final TextEditingController groupNameController = TextEditingController();

                final groupName = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Group Name'),
                    content: TextField(
                      controller: groupNameController,
                      decoration: const InputDecoration(hintText: "Enter group name"),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, groupNameController.text.trim()),
                        child: const Text("Create"),
                      ),
                    ],
                  ),
                );

                if (groupName != null && groupName.isNotEmpty && _currentUser != null) {
                  try {
                    final ChatController chatController = ChatController();

                    // Generate group chat ID using timestamp and user UID
                    final chatID = 'group_${_currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}';

                    // Prepare member UIDs
                    final memberUIDs = groupMembers.map((u) => u.uid).toList();
                    memberUIDs.add(_currentUser!.uid); // Add current user too

                    // Create group chat
                    final newGroupChat = Chat(
                      admins: [_currentUser!.uid],
                      isGroup: true,
                      chatID: chatID,
                      displayName: groupName,
                      lastMessage: '',
                      members: memberUIDs,
                      profilePicURL: '',
                      isBroadcast: false,
                      lastMessageSender: '',
                      createdAt: Timestamp.now(),
                      lastMessageTime: Timestamp.now(),
                    );

                    await chatController.createChat(newGroupChat);

                    if (!mounted) return;
                    Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
                    Navigator.pushNamed(context, '/chat', arguments: newGroupChat);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create group: $e')));
                  }
                }
              },
            ),
      body: RefreshIndicator(
        onRefresh: _refreshContacts,
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        elevation: 0,
        child: CustomScrollView(
          slivers: [
            if (contacts.isNotEmpty)
              SliverPersistentHeader(pinned: true, floating: true, delegate: _SearchBar(controller: _searchController)),
            filteredContacts.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        SvgPicture.asset("assets/$theme/add_contact.svg", width: 220),
                        const SizedBox(height: 24),
                        Text("No contacts found", style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text("Try a different name or email", style: Theme.of(context).textTheme.bodyMedium),
                        const Spacer(),
                      ],
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final contact = filteredContacts[index];
                      return ContactCard(
                        contactModel: contact!,
                        onTap: () {
                          setState(() {
                            contact.isSelected = !contact.isSelected;
                            contact.isSelected ? groupMembers.add(contact) : groupMembers.remove(contact);
                          });
                        },
                      );
                    }, childCount: filteredContacts.length),
                  ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  _SearchBar({required this.controller});

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search contacts...",
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchBar oldDelegate) => false;
}
