// packages
import 'package:flutter/material.dart';

// models
import 'package:buzz/models/User.dart';

// components
import '../components/ProfilePicture.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contactModel, this.onTap, this.trailing});

  final UserModel contactModel;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(contactModel.name, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(
          contactModel.email,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
        leading: Stack(
          children: [
            ProfilePicture(radius: 24, imageURL: contactModel.profilePic),
            if (contactModel.isSelected)
              Positioned(
                right: 4,
                bottom: 4,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.check, size: 8, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
          ],
        ),
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}
