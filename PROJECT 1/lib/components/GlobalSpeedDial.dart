// packages
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

class GlobalSpeedDial extends StatelessWidget {
  final VoidCallback? onActionComplete;

  const GlobalSpeedDial({super.key, this.onActionComplete});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: HugeIcons.strokeRoundedPlusSign,
      activeIcon: HugeIcons.strokeRoundedCancel01,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimaryContainer),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      buttonSize: const Size.square(48),
      elevation: 2,
      renderOverlay: false,
      children: [
        SpeedDialChild(
          child: Icon(HugeIcons.strokeRoundedBubbleChat),
          label: 'New Chat',
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () async {
            await Navigator.pushNamed(context, '/newChat');
            onActionComplete?.call();
          },
        ),
        SpeedDialChild(
          child: Icon(HugeIcons.strokeRoundedUserGroup02),
          label: 'New Group',
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () async {
            await Navigator.pushNamed(context, '/newGroup');
            onActionComplete?.call();
          },
        ),
        SpeedDialChild(
          child: Icon(HugeIcons.strokeRoundedMegaphone02),
          label: 'New Broadcast',
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () async {
            await Navigator.pushNamed(context, '/newBroadcast');
            onActionComplete?.call();
          },
        ),
      ],
    );
  }
}
