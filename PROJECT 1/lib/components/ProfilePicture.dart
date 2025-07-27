import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.radius,
    required this.imageURL,
    this.isGroup = false,
    this.isBroadcast = false,
  });

  final String imageURL;
  final bool isBroadcast;
  final bool isGroup;
  final int radius;

  @override
  Widget build(BuildContext context) {
    IconData getIcon() {
      if (isGroup && isBroadcast) return HugeIcons.strokeRoundedMegaphone02;
      if (isGroup && !isBroadcast) return HugeIcons.strokeRoundedUserGroup02;
      return HugeIcons.strokeRoundedUser;
    }

    return CircleAvatar(
      radius: radius.toDouble(),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: imageURL.isEmpty
          ? Icon(getIcon(), size: radius.toDouble())
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius.toDouble()),
              child: Image.network(
                imageURL,
                fit: BoxFit.cover,
                width: radius * 2.0,
                height: radius * 2.0,
              ),
            ),
    );
  }
}
