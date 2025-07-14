// packages
import 'package:image_picker/image_picker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// controllers
import 'package:buzz/controllers/UserController.dart';

// models
import 'package:buzz/models/User.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserController contactManager = UserController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _aboutController.text = widget.user.about;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    await contactManager.updateUser(
      UserModel(
        uid: widget.user.uid,
        name: _nameController.text.trim(),
        email: widget.user.email,
        about: _aboutController.text.trim(),
        phoneNumber: widget.user.phoneNumber,
        profilePic: _pickedImage != null ? _pickedImage!.path : widget.user.profilePic,
        contacts: widget.user.contacts,
        calls: widget.user.calls,
        updates: widget.user.updates,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
                            : (widget.user.profilePic != '' ? NetworkImage(widget.user.profilePic) : null),
                        child: (_pickedImage == null && widget.user.profilePic == '')
                            ? Icon(
                                HugeIcons.strokeRoundedUser02,
                                size: 48,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            HugeIcons.strokeRoundedPen01,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(HugeIcons.strokeRoundedUser02),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _aboutController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'About',
                    prefixIcon: Icon(HugeIcons.strokeRoundedProfile02),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(HugeIcons.strokeRoundedMail01),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 36),
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(HugeIcons.strokeRoundedFloppyDisk),
                  label: const Text("Save"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
