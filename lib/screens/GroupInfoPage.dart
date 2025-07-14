// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

// model
import 'package:buzz/models/Chat.dart';
import 'package:buzz/models/User.dart';

// controller
import 'package:buzz/controllers/UserController.dart';

// components
import 'package:buzz/components/ProfilePicture.dart';
import 'package:buzz/components/ContactCard.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final UserController _userController = UserController();
  List<UserModel?> fetchedMembers = [];

  @override
  void initState() {
    super.initState();
    getMembers();
  }

  void getMembers() async {
    List<UserModel?> loadedMembers = [];
    for (final memberId in widget.chat.members) {
      final user = await _userController.getUserById(memberId);
      if (user != null) {
        loadedMembers.add(user);
      }
    }
    setState(() {
      fetchedMembers = loadedMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> memberWidgets = [
      Row(
        children: [
          SizedBox(width: 16),
          Text("Members", style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(width: 16),
        ],
      ),
      Divider(indent: 16, endIndent: 16),
      SizedBox(height: 8),
    ];

    memberWidgets.addAll(
      List.generate(fetchedMembers.length, (index) {
        return ContactCard(contactModel: fetchedMembers[index]!);
      }),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
          if (widget.chat.isGroup && !widget.chat.isBroadcast)
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
            margin: EdgeInsets.only(top: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ProfilePicture(
                  radius: 64,
                  imageURL: widget.chat.profilePicURL,
                  isBroadcast: widget.chat.isBroadcast,
                  isGroup: widget.chat.isGroup,
                ),
                SizedBox(height: 16),
                Text(
                  (widget.chat.displayName.isNotEmpty)
                      ? widget.chat.displayName
                      : fetchedMembers.isNotEmpty
                      ? fetchedMembers.last!.name
                      : '',
                  style: Theme.of(context).textTheme.headlineMedium,
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: memberWidgets),
          ),
        ],
      ),
    );
  }
}
