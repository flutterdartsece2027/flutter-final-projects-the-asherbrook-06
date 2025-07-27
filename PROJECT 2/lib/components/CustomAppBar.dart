// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, required this.showReturn, this.actions});

  final String title;
  final bool showReturn;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: showReturn,
      leading: (showReturn)
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
            )
          : null,
      actions: actions,
    );
  }
}
