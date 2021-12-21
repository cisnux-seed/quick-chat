import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  const RoomModel({
    this.id,
    required this.usernames,
    this.profilePict,
    required this.userIds,
    this.updatedAt,
    this.latestMessage,
  });

  final String? id;
  final List<String?>? profilePict;
  final String? latestMessage;
  final Timestamp? updatedAt;
  final List<String> userIds;
  final List<String> usernames;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        updatedAt: json['updatedAt'],
        profilePict: json['profilePict'] != null
            ? List<String?>.from(json['profilePict'])
            : json['profilePict'],
        latestMessage: json['latestMessage'],
        id: json['id'],
        usernames: List<String>.from(json['usernames']),
        userIds: List<String>.from(json['userIds']),
      );

  Map<String, dynamic> toJson() => {
        'usernames': usernames,
        'userIds': userIds,
        'latestMessage': latestMessage,
        'updatedAt': updatedAt,
        'profilePict': profilePict,
      };

  RoomModel copyWith({
    List<String>? usernames,
    String? latestMessage,
    Timestamp? updatedAt,
    List<String?>? profilePict,
  }) =>
      RoomModel(
        usernames: usernames ?? this.usernames,
        userIds: userIds,
        latestMessage: latestMessage ?? this.latestMessage,
        updatedAt: updatedAt ?? this.updatedAt,
        profilePict: profilePict ?? this.profilePict,
      );

  @override
  List<Object?> get props => [id, usernames, userIds, profilePict];
}
