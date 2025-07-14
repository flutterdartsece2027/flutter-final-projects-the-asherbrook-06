// packages
import 'package:buzz/components/ContactCard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// components
import 'package:buzz/components/ProfilePicture.dart';

// models
import 'package:buzz/models/User.dart';

// controllers
import 'package:buzz/controllers/UserController.dart';
import 'package:buzz/controllers/ChatController.dart';

// auth
import 'package:buzz/auth/Auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ChatController chatController = ChatController();
  UserController contactsManager = UserController();
  List<UserModel> contacts = [];
  UserModel? _user;

  Future<void> _loadContacts() async {
    if (_user != null) {
      final fetchedContacts = await Future.wait(
        (await contactsManager.getContactsList(_user!.uid)).map((uid) => contactsManager.getUserById(uid)),
      );
      setState(() {
        contacts = fetchedContacts.whereType<UserModel>().toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Auth().getCurrentUser(context).then((firebaseUser) async {
      if (firebaseUser != null) {
        final userModel = await contactsManager.getUserById(firebaseUser.uid);
        setState(() {
          _user = userModel;
        });
        await _loadContacts();
      }
    });
  }

  void _handleLogout() async {
    await Auth().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text("Profile"),
        leading: IconButton(icon: Icon(HugeIcons.strokeRoundedArrowLeft01), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedLogout01, color: Theme.of(context).colorScheme.error),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadContacts,
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        elevation: 0,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 8, left: 8, right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: _user == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ProfilePicture(radius: 64, imageURL: _user!.profilePic),
                        SizedBox(height: 16),
                        Text(_user!.name, style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(height: 4),
                        Text(_user!.email, style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () async {
                            final updated = await Navigator.pushNamed(context, '/editProfile', arguments: _user!);

                            if (updated == true) {
                              final firebaseUser = await Auth().getCurrentUser(context);
if (firebaseUser != null) {
  final updatedUser = await contactsManager.getUserById(firebaseUser.uid);
  setState(() => _user = updatedUser);
}

                            }
                          },
                          child: Text("Edit Profile"),
                        ),
                      ],
                    ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              margin: EdgeInsets.only(top: 8, left: 8, right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Text("Contacts", style: Theme.of(context).textTheme.headlineMedium),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: Icon(HugeIcons.strokeRoundedUserAdd02),
                        onPressed: () async {
                          // TODO: Add Contact
                          await _loadContacts();
                        },
                      ),
                      SizedBox(width: 24),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: List.generate(
                      contacts.length,
                      (index) => ContactCard(
                        contactModel: contacts[index],
                        trailing: PopupMenuButton(
                          color: Theme.of(context).colorScheme.surfaceContainerHigh,
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: 'chat',
                              child: Text('Chat'),
                              onTap: () async {
                                final chat = await chatController.getChatById(contacts[index].uid);
                                if (!mounted) return;
                                Navigator.pushNamed(context, '/chat', arguments: chat);
                              },
                            ),

                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                              onTap: () async {
                                // TODO: Edit Contact
                              },
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                              onTap: () async {
                                // TODO: Delete Contact
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
