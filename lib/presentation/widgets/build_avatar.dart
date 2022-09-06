import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildAvatar(String? uri) {
  if (uri != null && uri.isNotEmpty) {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(uri),
    );
  } else {
    return const CircleAvatar(child: Icon(Icons.person_rounded));
  }
}
