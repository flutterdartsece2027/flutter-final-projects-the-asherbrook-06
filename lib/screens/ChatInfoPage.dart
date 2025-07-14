// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

// model
import 'package:buzz/models/User.dart';
import 'package:buzz/models/Chat.dart';

// components
import 'package:buzz/controllers/UserController.dart';
import 'package:buzz/components/ProfilePicture.dart';

class ChatInfoPage extends StatefulWidget {
  const ChatInfoPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  final UserController _userController = UserController();
  List<UserModel?> members = [];

  void getMembers() async {
    List<UserModel?> fetchedMembers = [];
    for (final memberId in widget.chat.members) {
      final user = await _userController.getUserById(memberId);
      fetchedMembers.add(user);
    }
    setState(() {
      members = fetchedMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info"),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedBubbleChat),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.settings.name == '/dashboard');
              Navigator.of(context).pushNamed('/chat', arguments: widget.chat);
            },
          ),
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedCall02),
            onPressed: () {
              // TODO: Call Actions
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ProfilePicture(radius: 64, imageURL: widget.chat.profilePicURL),
                SizedBox(height: 16),
                Text(
                  (widget.chat.displayName.isNotEmpty) ? widget.chat.displayName : members.last!.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 4),
                Text(members.last!.email, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
