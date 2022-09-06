import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TextMessageModel extends Equatable {
  const TextMessageModel({
    required this.text,
    required this.authorId,
    required this.createdAt,
    required this.type,
    required this.roomId,
  });

  final Timestamp createdAt;
  final String text;
  final String type;
  final String authorId;
  final String roomId;

  factory TextMessageModel.fromJson(Map<String, dynamic> json) =>
      TextMessageModel(
        authorId: json['authorId'],
        text: json['text'],
        type: json['type'],
        createdAt: json['createdAt'],
        roomId: json['roomId'],
      );

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'createdAt': createdAt,
        'text': text,
        'type': type,
        'roomId': roomId,
      };

  @override
  List<Object?> get props => [
        authorId,
        text,
        type,
        createdAt,
        roomId,
      ];
}
