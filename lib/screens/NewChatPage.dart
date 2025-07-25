// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

// models
import 'package:buzz/models/Chat.dart';
import 'package:buzz/models/User.dart';

// controllers
import 'package:buzz/controllers/UserController.dart';
import 'package:buzz/controllers/ChatController.dart';

// components
import 'package:buzz/components/ContactCard.dart';

// auth
import 'package:buzz/auth/Auth.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final TextEditingController _searchController = TextEditingController();
  UserController contactsManager = UserController();
  ChatController chatController = ChatController();
  bool _isLoading = false;

  List<UserModel?> _filteredContacts = [];
  List<UserModel?> _contacts = [];
  UserModel? _currentUser;
  int? selectedIndex;

  Future<void> _refreshContacts() async {
    setState(() {
      _isLoading = true;
    });

    final user = await contactsManager.getUserById((await Auth().getCurrentUser(context))!.uid);
    final fetchedContacts = await Future.wait(
      user!.contacts.map((uid) async => await contactsManager.getUserById(uid)).toList(),
    );

    setState(() {
      _currentUser = user;
      _contacts = fetchedContacts;
      _filteredContacts = fetchedContacts;
      _isLoading = false;
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
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
            Text("New Chat"),
            Text("${_filteredContacts.length} contacts", style: Theme.of(context).textTheme.labelMedium),
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
      floatingActionButton: (selectedIndex == null)
          ? null
          : FloatingActionButton(
              elevation: 1,
              child: Icon(HugeIcons.strokeRoundedSent),
              onPressed: () async {
                final selectedUser = _filteredContacts[selectedIndex!];
                if (selectedUser == null || _currentUser == null) return;

                final members = [_currentUser!.uid, selectedUser.uid]..sort();

                // Check if a chat already exists between the two users
                final existingChats = await chatController.getChatsForUser(_currentUser!.uid);
                final existingChat = existingChats.cast<Chat?>().firstWhere(
                  (chat) =>
                      !chat!.isGroup &&
                      chat.members.toSet().containsAll(members) &&
                      chat.members.length == members.length,
                  orElse: () => null,
                );

                if (existingChat != null) {
                  if (context.mounted) {
                    Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
                    Navigator.pushNamed(context, '/chat', arguments: existingChat);
                  }
                  return;
                }

                // Auto-generate new chatID
                final docRef = FirebaseFirestore.instance.collection('chats').doc();
                final chatID = docRef.id;

                // Create new Chat
                final newChat = Chat(
                  admins: [],
                  isGroup: false,
                  chatID: chatID,
                  displayName: '',
                  lastMessage: '',
                  members: members,
                  profilePicURL: "",
                  isBroadcast: false,
                  lastMessageSender: '',
                  createdAt: Timestamp.now(),
                  lastMessageTime: Timestamp.now(),
                );

                await chatController.createChat(newChat);

                if (context.mounted) {
                  Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
                  Navigator.pushNamed(context, '/chat', arguments: newChat);
                }
              },
            ),
      body: (_isLoading)
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshContacts,
              color: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              elevation: 0,
              child: CustomScrollView(
                slivers: [
                  if (_contacts.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: _SearchBar(controller: _searchController),
                    ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (_filteredContacts.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(child: SizedBox()),
                              SvgPicture.asset("assets/$theme/add_contact.svg", width: 220),
                              const SizedBox(height: 24),
                              Text("No contacts found", style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 4),
                              Text("Try a different name or email", style: Theme.of(context).textTheme.bodyMedium),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        );
                      }
                      return ContactCard(
                        contactModel: _filteredContacts[index]!,
                        onTap: () {
                          setState(() {
                            if (selectedIndex != null && selectedIndex! < _filteredContacts.length) {
                              _filteredContacts[selectedIndex!]!.isSelected = false;
                            }
                            if (selectedIndex == index) {
                              selectedIndex = null;
                            } else {
                              _filteredContacts[index]!.isSelected = true;
                              selectedIndex = index;
                            }
                          });
                        },
                      );
                    }, childCount: _filteredContacts.isEmpty ? 1 : _filteredContacts.length),
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
