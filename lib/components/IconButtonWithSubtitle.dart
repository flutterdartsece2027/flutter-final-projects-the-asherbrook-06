// packages
import 'package:flutter/material.dart';

class IconButtonWithSubtitle extends StatelessWidget {
  const IconButtonWithSubtitle({
    super.key,
    required this.icon,
    required this.subtitle,
    required this.size,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          CircleAvatar(
            radius: size * 2,
            child: Icon(icon, size: size * 2),
          ),
          SizedBox(height: 4),
          Text(subtitle),
        ],
      ),
    );
  }
}
