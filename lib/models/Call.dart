// packages
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model to store Call Details
class Call {
  final int callDuration;
  final List<String> callMembers;

  Call({required this.callDuration, required this.callMembers});

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callDuration: (map['callDuration'] as Timestamp).seconds,
      callMembers: List<String>.from(map['callMembers']),
    );
  }

  Map<String, dynamic> toMap() => {
        'callDuration': Timestamp.fromMillisecondsSinceEpoch(callDuration * 1000),
        'callMembers': callMembers,
      };
}
