// packages
import 'package:buzz/components/ContactCard.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// model
import 'package:buzz/models/User.dart';
import 'package:buzz/models/Chat.dart';

// components
import 'package:buzz/controllers/UserController.dart';
import 'package:buzz/components/ProfilePicture.dart';

// TODO: modify this page
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
  void initState() {
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoading = members.isEmpty;
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
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surfaceContainer,
              highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                height: (widget.chat.isGroup) ? 265 : 235,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SizedBox(),
              ),
            )
          : ListView(
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
                      ProfilePicture(radius: 64, imageURL: widget.chat.profilePicURL),
                      SizedBox(height: 16),
                      Text(
                        (widget.chat.displayName.isNotEmpty) ? widget.chat.displayName : members.last!.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 4),
                      if (!widget.chat.isGroup && !widget.chat.isBroadcast)
                        Text(members.last!.email, style: Theme.of(context).textTheme.bodyMedium),
                      if (widget.chat.isGroup || widget.chat.isBroadcast)
                        TextButton(
                          child: Text("Edit Info"),
                          onPressed: () {
                            // TODO: Edit Group/Broadcast Details
                          },
                        ),
                    ],
                  ),
                ),
                if (widget.chat.isGroup || widget.chat.isBroadcast)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 16),
                            Text("Members", style: Theme.of(context).textTheme.headlineMedium),
                            Expanded(child: SizedBox()),
                            IconButton(
                              icon: Icon(HugeIcons.strokeRoundedUserAdd02),
                              onPressed: () {
                                // TODO: Add Group Members
                              },
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            members.length,
                            (index) => ContactCard(contactModel: members[index]!),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
