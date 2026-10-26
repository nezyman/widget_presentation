import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage(),
    );
  }
}


class Message {
  final String text;
  final bool isMe;

  Message(this.text, this.isMe);
}


class ChatService {
  final List<Message> _messages = [];
  final _messagesController = StreamController<List<Message>>.broadcast();
  final _typingController = StreamController<bool>.broadcast();

  final List<String> _replies = [
    'Hey! How is your Flutter class going?',
    'Nice, streams are powerful!',
    'Wow, that is cool.',
    'Tell me more about it.',
    'I like that idea.',
  ];
  int _replyIndex = 0;

  Stream<List<Message>> get messagesStream => _messagesController.stream;
  Stream<bool> get typingStream => _typingController.stream;

  void sendMessage(String text) {
    _messages.add(Message(text, true));
    _messagesController.add(List.from(_messages));

    _typingController.add(true);
    Future.delayed(const Duration(seconds: 2), () {
      if (_messagesController.isClosed) return;

      _typingController.add(false);
      _messages.add(Message(_replies[_replyIndex % _replies.length], false));
      _replyIndex++;
      _messagesController.add(List.from(_messages));
    });
  }

  void dispose() {
    _messagesController.close();
    _typingController.close();
  }
}


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService chatService = ChatService();
  final TextEditingController textController = TextEditingController();

  void send() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    chatService.sendMessage(text);
    textController.clear();
  }

  @override
  void dispose() {
    chatService.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alex', style: TextStyle(fontSize: 18)),
            // StreamBuilder #1: typing indicator
            StreamBuilder<bool>(
              stream: chatService.typingStream,
              initialData: false,
              builder: (context, snapshot) {
                final isTyping = snapshot.data ?? false;
                return Text(
                  isTyping ? 'typing...' : 'online',
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatService.messagesStream,
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('Say hi to start the chat 👋'),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return Align(
                      alignment: message.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: message.isMe
                              ? Colors.blue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: message.isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onSubmitted: (_) => send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}