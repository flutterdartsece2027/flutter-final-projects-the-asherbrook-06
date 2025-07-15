// packages
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget ShimmerMessage({required BuildContext context, required bool isMe, required String type}) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primaryContainer,
      highlightColor: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [Icon(HugeIcons.strokeRoundedFile01, color: Colors.white)])
      ),
    ),
  );
}
