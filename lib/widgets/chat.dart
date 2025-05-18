import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatWidget extends ConsumerStatefulWidget {
  const ChatWidget({super.key});

  @override
  ConsumerState<ChatWidget> createState() {
    return _ChatWidgetState();
  }
}

class _ChatWidgetState extends ConsumerState<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Coming Soon..'),
        ],
      ),
    );
  }
}
