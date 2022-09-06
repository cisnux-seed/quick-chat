import 'package:flutter/material.dart';
import 'package:quick_chat/data/models/text_message_model.dart';
import 'package:quick_chat/styles/colors.dart';
import 'package:quick_chat/utils/format_date.dart';
import 'package:get/get.dart';

class TextBubbleMessage extends StatelessWidget {
  const TextBubbleMessage({
    required this.message,
    required this.isFromCurrentUser,
    Key? key,
  }) : super(key: key);

  final TextMessageModel message;
  final bool isFromCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.width / 2),
        child: Material(
          elevation: 0.8,
          borderRadius: isFromCurrentUser
              ? const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
          color: isFromCurrentUser ? kCurrentUserColor : Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Wrap(
              verticalDirection: VerticalDirection.down,
              alignment: WrapAlignment.end,
              children: [
                SelectableText(
                  message.text,
                  style: context.textTheme.bodyText1,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Text(
                    formatDate(message.createdAt.toDate()),
                    style: context.textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
