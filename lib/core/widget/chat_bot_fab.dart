import 'package:flutter/material.dart';

class ChatBotFab extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChatBotFab({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed ?? () {},
      child: const Icon(Icons.smart_toy_outlined),
    );
  }
}
