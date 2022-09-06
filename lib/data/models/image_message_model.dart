import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ImageMessageModel extends Equatable {
  const ImageMessageModel({
    this.uri,
    required this.authorId,
    required this.createdAt,
    required this.type,
    required this.roomId,
  });

  final Timestamp createdAt;
  final String? uri;
  final String type;
  final String authorId;
  final String roomId;

  factory ImageMessageModel.fromJson(Map<String, dynamic> json) =>
      ImageMessageModel(
        authorId: json['authorId'],
        uri: json['uri'],
        type: json['type'],
        createdAt: json['createdAt'],
        roomId: json['roomId'],
      );

  ImageMessageModel copyWith({
    String? uri,
    String? type,
    String? roomId,
  }) =>
      ImageMessageModel(
        uri: uri ?? this.uri,
        authorId: authorId,
        createdAt: createdAt,
        type: type ?? this.type,
        roomId: roomId ?? this.roomId,
      );

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'createdAt': createdAt,
        'uri': uri,
        'type': type,
        'roomId': roomId,
      };

  @override
  List<Object?> get props => [
        authorId,
        uri,
        type,
        createdAt,
        roomId,
      ];
}
