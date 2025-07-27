// packages
import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// controllers
import 'package:buzz/controllers/ChatController.dart';

// models
import 'package:buzz/models/Chat.dart';

class CameraPreviewPage extends StatefulWidget {
  const CameraPreviewPage({super.key, required this.path, required this.chat});

  final String path;
  final Chat chat;

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  final TextEditingController _captionController = TextEditingController();
  final ChatController _chatController = ChatController();

  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Preview", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Image.file(
                      File(widget.path),
                      fit: BoxFit.contain,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                  );
                },
              ),
            ),
            // Input bar
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 64,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: TextFormField(
                    controller: _captionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withAlpha(125),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hint: Text("Add Caption", style: TextStyle(color: Colors.white)),
                      prefixIcon: Icon(HugeIcons.strokeRoundedImageAdd01, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                IconButton(
                  icon: _isSending
                      ? CircularProgressIndicator(color: Colors.white)
                      : Icon(HugeIcons.strokeRoundedSent, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    padding: EdgeInsets.all(14),
                  ),
                  onPressed: _isSending
                      ? null
                      : () async {
                          setState(() => _isSending = true);

                          final file = File(widget.path);
                          final fileName = file.path.split('/').last;

                          final ref = FirebaseStorage.instance
                              .ref()
                              .child('chat_files')
                              .child(widget.chat.chatID)
                              .child(fileName);

                          try {
                            // Upload the image
                            await ref.putFile(file);
                            final downloadUrl = await ref.getDownloadURL();

                            // Create message in Firestore
                            final messagesRef = _chatController.getMessages(widget.chat.chatID);
                            final messageRef = messagesRef.doc();

                            await messageRef.set({
                              'messageID': messageRef.id,
                              'status': 'sent',
                              'sender': _chatController.currentUserId,
                              'isEdited': false,
                              'replyTo': '',
                              'text': _captionController.text.trim(),
                              'url': downloadUrl,
                              'messageType': 'image',
                              'sentAt': Timestamp.now(),
                            });

                            await FirebaseFirestore.instance.collection('chats').doc(widget.chat.chatID).update({
                              'lastMessage': '[Image]',
                              'lastMessageSender': _chatController.currentUserId,
                              'lastMessageTime': Timestamp.now(),
                            });
                          } catch (e) {
                            log("Upload failed: $e");
                          }

                          setState(() => _isSending = false);
                          if (context.mounted) {
                            Navigator.popUntil(context, (route) => route.settings.name == '/chat');
                          }
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
