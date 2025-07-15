// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

// screens
import 'package:buzz/components/CameraScreen.dart';
import 'package:buzz/screens/PreviewPage.dart';

// controllers
import 'package:buzz/controllers/ChatController.dart';
import 'package:buzz/controllers/UserController.dart';

// models
import 'package:buzz/models/User.dart';
import 'package:buzz/models/Chat.dart';

// components
import '../components/IconButtonWithSubtitle.dart';
import '../components/ProfilePicture.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final UserController _userController = UserController();
  final ChatController _chatController = ChatController();
  late Stream<QuerySnapshot> _messageStream;
  List<UserModel?> members = [];
  String? _editingMessageId;
  bool _isEditing = false;
  late bool _isAdmin;

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
    _messageStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chat.chatID)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots();

    _isAdmin = widget.chat.admins.any((UID) => UID == _chatController.currentUserId);
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    final theme = View.of(context).platformDispatcher.platformBrightness == Brightness.light ? 'light' : 'dark';
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        toolbarHeight: 64,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Row(
          children: [
            ProfilePicture(
              radius: 24,
              imageURL: widget.chat.profilePicURL,
              isGroup: widget.chat.isGroup,
              isBroadcast: widget.chat.isBroadcast,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (widget.chat.displayName.isNotEmpty)
                        ? widget.chat.displayName
                        : (members.isNotEmpty && members.last != null)
                        ? members.last!.name
                        : widget.chat.members.last,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (!widget.chat.isBroadcast && !widget.chat.isGroup)
                    Text(
                      (members.isNotEmpty && members.last != null) ? members.last!.email : widget.chat.members.last,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
                    ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!widget.chat.isBroadcast)
            IconButton(
              icon: Icon(HugeIcons.strokeRoundedCall02),
              onPressed: () {
                // TODO: Implement Call Functionality
              },
            ),
          PopupMenuButton(
            icon: Icon(HugeIcons.strokeRoundedMoreVertical),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("View Profile"),
                onTap: () {
                  Navigator.pushNamed(context, '/chatInfo', arguments: widget.chat);
                },
              ),
              PopupMenuItem(
                onTap: () {
                  Future.delayed(Duration.zero, () async {
                    await _chatController.clearHistory(widget.chat.chatID);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        showCloseIcon: true,
                        closeIconColor: Theme.of(context).colorScheme.onSurface,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                        content: Text(
                          "Chat history cleared",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    );
                  });
                },
                child: Text("Clear History"),
              ),
              PopupMenuItem(
                onTap: () {
                  Future.delayed(Duration.zero, () async {
                    await _chatController.deleteChat(widget.chat.chatID);
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
                child: Text("Delete Chat"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/$theme/begin_chat.svg', width: 200),
                      SizedBox(height: 24),
                      Text("Looks like... Nothing", style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text("Send a message to Get Started", style: Theme.of(context).textTheme.labelLarge),
                    ],
                  );
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final isMe = message['sender'] == _chatController.currentUserId;

                    // Determine whether to show the sender's name
                    bool showSenderName = false;
                    String? senderName;

                    if (widget.chat.isGroup || widget.chat.isBroadcast) {
                      final prevSender = index > 0
                          ? (messages[index - 1].data() as Map<String, dynamic>)['sender']
                          : null;
                      if (message['sender'] != prevSender) {
                        showSenderName = true;
                        for (final user in members) {
                          if (user != null && user.uid == message['sender']) {
                            senderName = user.name;
                            break;
                          }
                        }
                      }
                    }
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (showSenderName && senderName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(senderName, style: Theme.of(context).textTheme.labelMedium),
                            ),
                          GestureDetector(
                            onLongPress: isMe
                                ? () async {
                                    final selected = await showMenu<String>(
                                      context: context,
                                      // TODO: Adjust Positioning
                                      position: RelativeRect.fromLTRB(100, 300, 0, 0),
                                      items: const [
                                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                                        PopupMenuItem(value: 'unsend', child: Text('Unsend')),
                                      ],
                                    );

                                    if (selected == 'edit' && message['type'] == 'text') {
                                      setState(() {
                                        _isEditing = true;
                                        _editingMessageId = messages[index].id;
                                        _messageController.text = message['text'] ?? '';
                                      });
                                    } else if (selected == 'unsend') {
                                      await _chatController.unsendMessage(widget.chat.chatID, messages[index].id);
                                    }
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : Theme.of(context).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: () {
                                final type = message['messageType'];
                                final url = message['url'] ?? '';
                                switch (type) {
                                  case 'text':
                                    return Text(
                                      message['text'] ?? '[Unsupported]',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    );
                                  case 'image':
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(url, width: MediaQuery.of(context).size.width * 0.6),
                                    );
                                  case 'file':
                                    final fileName = Uri.decodeFull(Uri.parse(url).pathSegments.last).split('/').last;
                                    return GestureDetector(
                                      onTap: () => launchUrl(Uri.parse(url)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(HugeIcons.strokeRoundedFile01, size: 20),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              fileName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  default:
                                    return Text('[Unsupported Message Type]');
                                }
                              }(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: !(widget.chat.isBroadcast && !_isAdmin),
                      keyboardType: TextInputType.multiline,
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 3,
                      onSubmitted: (value) async {
                        final text = value.trim();
                        if (text.isEmpty) return;

                        await _chatController.sendMessage(widget.chat.chatID, text, _chatController.currentUserId, "");
                        _messageController.clear();
                      },
                      decoration: InputDecoration(
                        hintText: (widget.chat.isBroadcast && !_isAdmin) ? "You can't send messages" : "Type a message",
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
                        prefixIcon: (_isEditing) ? Icon(HugeIcons.strokeRoundedPen01) : null,
                        suffixIcon: (_isEditing)
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                    _editingMessageId = null;
                                    _messageController.clear();
                                  });
                                },
                                icon: Icon(HugeIcons.strokeRoundedCancel01),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(HugeIcons.strokeRoundedAttachment02),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (builder) => Container(
                                          height: 240,
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(36),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text("Choose File", style: Theme.of(context).textTheme.headlineSmall),
                                              SizedBox(height: 32),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  IconButtonWithSubtitle(
                                                    icon: HugeIcons.strokeRoundedFile01,
                                                    subtitle: 'Document',
                                                    size: 16,
                                                    onTap: () async {
                                                      final result = await FilePicker.platform.pickFiles();
                                                      if (result != null && result.files.single.path != null) {
                                                        // final file = File(result.files.single.path!);
                                                        // TODO: Send Media Files
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(width: 32),
                                                  IconButtonWithSubtitle(
                                                    icon: HugeIcons.strokeRoundedImage02,
                                                    subtitle: 'Images',
                                                    size: 16,
                                                    onTap: () async {
                                                      final picker = ImagePicker();
                                                      final pickedFile = await picker.pickImage(
                                                        source: ImageSource.gallery,
                                                      );

                                                      if (pickedFile != null && context.mounted) {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => CameraPreviewPage(
                                                              path: pickedFile.path,
                                                              chat: widget.chat,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(width: 32),
                                                  IconButtonWithSubtitle(
                                                    icon: HugeIcons.strokeRoundedCamera02,
                                                    subtitle: 'Camera',
                                                    size: 16,
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => CameraScreen(chat: widget.chat),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.all(14),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Icon(HugeIcons.strokeRoundedSent, size: 24),
                    onPressed: () async {
                      final text = _messageController.text.trim();
                      if (text.isEmpty) return;

                      if (_isEditing && _editingMessageId != null) {
                        await _chatController.editMessage(widget.chat.chatID, _editingMessageId!, text);
                        setState(() {
                          _isEditing = false;
                          _editingMessageId = null;
                        });
                      } else {
                        await _chatController.sendMessage(widget.chat.chatID, text, _chatController.currentUserId, '');
                      }

                      _messageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
