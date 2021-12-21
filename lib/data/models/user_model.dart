import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.username,
    required this.id,
    required this.email,
    this.profilePict,
    required this.lastSeen,
    required this.isOnline,
  });

  final String username;
  final String id;
  final String email;
  final String? profilePict;
  final Timestamp lastSeen;
  final bool isOnline;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json['username'],
        id: json['id'],
        email: json['email'],
        profilePict: json['profilePict'],
        lastSeen: json['lastSeen'],
        isOnline: json['isOnline'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'id': id,
        'email': email,
        'profilePict': profilePict,
        'lastSeen': lastSeen,
        'isOnline': isOnline,
      };

  UserModel copyWith(
          {String? username,
          Timestamp? lastSeen,
          String? profilePict,
          bool? isOnline}) =>
      UserModel(
        id: id,
        email: email,
        isOnline: isOnline ?? this.isOnline,
        username: username ?? this.username,
        profilePict: profilePict ?? this.profilePict,
        lastSeen: lastSeen ?? this.lastSeen,
      );

  @override
  List<Object?> get props => [
        username,
        id,
        profilePict,
        lastSeen,
        email,
      ];
}
