import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {
        required this.key,
        required this.message,
        required this.isMe,
        required this.imageUrl,
        required this.username}) : super(key: key);

  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)
      ),
            ),
            width: 140,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                 Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          color: isMe ? Colors.black : Theme.of(context).accentTextTheme.headline1!.color
                      ),
                 ),
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.black : Theme.of(context).accentTextTheme.headline1!.color
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        top: 0,
        left: isMe ? null : 120,
        right: isMe ? 120 : null,
      )
    ],
      clipBehavior: Clip.none,
    );
  }
}
