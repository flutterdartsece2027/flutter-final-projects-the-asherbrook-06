// packages
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.file(File(widget.path), fit: BoxFit.contain,),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 56,
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
                        prefixIcon: Icon(
                          HugeIcons.strokeRoundedImageAdd01,
                          color: Colors.white,
                          size: 24,
                        ),
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
                            // TODO: Send File
                            setState(() => _isSending = false);
                            if (context.mounted) {
                              Navigator.popUntil(
                                context,
                                (route) => route.settings.name == '/chat',
                              );
                            }
                          },
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
