import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quick_chat/data/models/image_message_model.dart';
import 'package:quick_chat/styles/colors.dart';
import 'package:quick_chat/utils/format_date.dart';
import 'package:get/get.dart';

class ImageBubbleMessage extends StatelessWidget {
  const ImageBubbleMessage({
    required this.message,
    required this.isFromCurrentUser,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final ImageMessageModel message;
  final bool isFromCurrentUser;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Align(
          alignment:
              isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: SizedBox(
            height: 300,
            width: 150,
            child: Material(
              elevation: 0.8,
              color: isFromCurrentUser ? kCurrentUserColor : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black,
                      child: CachedNetworkImage(
                        height: double.infinity,
                        width: double.infinity,
                        imageUrl: message.uri!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4, right: 4),
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.black45,
                        ),
                        child: Text(
                          formatDate(
                            message.createdAt.toDate(),
                          ),
                          style: context.textTheme.caption!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
