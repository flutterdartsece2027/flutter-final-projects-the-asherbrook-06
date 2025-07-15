// packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// components
import 'package:buzz/components/ProfilePicture.dart';

// models
import 'package:buzz/models/Chat.dart';
import 'package:buzz/models/User.dart';

// controllers
import 'package:buzz/controllers/ChatController.dart';
import 'package:buzz/controllers/UserController.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({super.key, required this.chatModel, required this.currentUserId});

  final Chat chatModel;
  final String currentUserId;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final UserController _userController = UserController();
  final ChatController _chatController = ChatController();
  late Future<String> displayNameFuture;
  late Future<String?> profilePicFuture;

  @override
  void initState() {
    super.initState();
    displayNameFuture = _getDisplayName();
    profilePicFuture = _getProfilePictureURL();
  }

  Future<String> _getDisplayName() async {
    if (widget.chatModel.isGroup || widget.chatModel.isBroadcast) {
      if (widget.chatModel.displayName.isNotEmpty) return widget.chatModel.displayName;

      List<String> memberNames = [];

      for (String uid in widget.chatModel.members) {
        if (uid == widget.currentUserId) continue;
        UserModel? contact = await _userController.getUserById(uid);
        memberNames.add(contact!.name);
      }

      return memberNames.join(', ');
    }

    for (String uid in widget.chatModel.members) {
      if (uid != widget.currentUserId) {
        UserModel? contact = await _userController.getUserById(uid);
        return contact?.name ?? "Unknown";
      }
    }

    return "Unknown";
  }

  Future<String?> _getProfilePictureURL() async {
    if (widget.chatModel.isGroup || widget.chatModel.isBroadcast) {
      return widget.chatModel.profilePicURL;
    }

    for (String uid in widget.chatModel.members) {
      if (uid != widget.currentUserId) {
        UserModel? contact = await _userController.getUserById(uid);
        return contact?.profilePic;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Offset tapPosition = Offset.zero;

    return GestureDetector(
      onTapDown: (details) => tapPosition = details.globalPosition,
      onLongPress: () async {
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, tapPosition.dx, tapPosition.dy),
          items: [
            PopupMenuItem(
              child: const Text("View Profile"),
              onTap: () {
                Navigator.pushNamed(context, '/chatInfo', arguments: widget.chatModel);
              },
            ),
            PopupMenuItem(
              child: const Text("Clear History"),
              onTap: () {
                Future.delayed(Duration.zero, () async {
                  await _chatController.clearHistory(widget.chatModel.chatID);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                      closeIconColor: Theme.of(context).colorScheme.onSurface,
                      content: Text("Chat history cleared", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    ),
                  );
                });
              },
            ),
            PopupMenuItem(
              child: const Text("Delete Chat"),
              onTap: () {
                Future.delayed(Duration.zero, () async {
                  await _chatController.deleteChat(widget.chatModel.chatID);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      closeIconColor: Theme.of(context).colorScheme.onSurface,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                      content: Text("Chat deleted", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([displayNameFuture, profilePicFuture]),
        builder: (context, snapshot) {
          final displayName = snapshot.hasData ? snapshot.data![0] as String : "Loading...";
          final profilePicURL = snapshot.hasData ? snapshot.data![1] as String? : null;

          return ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
            title: Text(displayName, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: widget.chatModel.lastMessage.isEmpty
                ? Text(
                    "New Chat",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : _buildMessagePreview(),
            leading: ProfilePicture(
              radius: 24,
              imageURL: profilePicURL ?? '',
              isGroup: widget.chatModel.isGroup,
              isBroadcast: widget.chatModel.isBroadcast,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat.jm().format(widget.chatModel.lastMessageTime.toDate())),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/chat', arguments: widget.chatModel);
            },
          );
        },
      ),
    );
  }

  Widget _buildMessagePreview() {
    String senderPrefix = "";

    if (widget.chatModel.lastMessageSender == widget.currentUserId) {
      senderPrefix = "You: ";
    } else if (widget.chatModel.isGroup || widget.chatModel.isBroadcast) {
      return FutureBuilder<UserModel?>(
        future: _userController.getUserById(widget.chatModel.lastMessageSender),
        builder: (context, snapshot) {
          String sender = snapshot.data?.name ?? "Someone";
          return Text(
            "$sender: ${widget.chatModel.lastMessage}",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
          );
        },
      );
    }

    return Text(
      "$senderPrefix${widget.chatModel.lastMessage}",
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
    );
  }
}
