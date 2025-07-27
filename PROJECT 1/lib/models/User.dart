// models
import 'package:buzz/models/Updates.dart';
import 'package:buzz/models/Call.dart';

/// Model to store User Details
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String about;
  final String phoneNumber;
  final String profilePic;
  final List<String> contacts;
  final List<Call> calls;
  final Updates updates;
  bool isSelected;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.about,
    required this.phoneNumber,
    required this.profilePic,
    required this.contacts,
    required this.calls,
    required this.updates,
    this.isSelected = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      about: map['about'],
      phoneNumber: map['phoneNumber'] ?? "",
      profilePic: map['profilePic'],
      contacts: List<String>.from(map['contacts'] ?? []),
      calls: (map['calls'] as List<dynamic>?)?.map((e) => Call.fromMap(e)).toList() ?? [],
      updates: Updates.fromMap(map['Updates'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'about': about,
    'phoneNumber': phoneNumber,
    'profilePic': profilePic,
    'contacts': contacts,
    'calls': calls.map((e) => e.toMap()).toList(),
    'Updates': updates.toMap(),
  };
}
