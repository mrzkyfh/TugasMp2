import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluenta/core/theme/app_theme.dart';
import 'package:fluenta/shared/widgets/message_bubble.dart';
import 'package:fluenta/shared/widgets/rive_character.dart';
import '../data/cerebras_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CerebrasService _aiService = CerebrasService();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Halo! Aku Fluenta 👋\nKetik kalimat bahasa Indonesia kamu, nanti aku terjemahin ke bahasa Inggris plus kasih tips belajarnya. Yuk mulai! 🚀',
      isUser: false,
    ),
  ];

  bool _isLoading = false;
  String _currentAnimation = 'idle';

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
      _currentAnimation = 'hands_up'; // Animasi saat user kirim pesan
    });
    _textController.clear();
    _scrollToBottom();

    // Tunggu sebentar untuk animasi hands_up, lalu ganti ke loading animation
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _currentAnimation = 'Look_down_right'; // Animasi saat AI loading
      });
    }

    final response = await _aiService.sendMessage(text);

    setState(() {
      _messages.add(ChatMessage(text: response, isUser: false));
      _isLoading = false;
      _currentAnimation = 'success'; // Animasi saat AI selesai
    });
    _scrollToBottom();

    // Kembali ke idle setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentAnimation = 'idle';
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppTheme.textLight,
          ),
          onPressed: () {
            try {
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
            } catch (e) {
              // Ignore pop errors
            }
          },
        ),
        title: const Text(
          'AI Penerjemah',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Rive Character
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: RiveCharacter(
                riveAssetPath: 'assets/animations/fluenta_character/4771-9633-login-teddy.riv',
                width: 180,
                height: 180,
                animationName: _currentAnimation,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return MessageBubble(text: msg.text, isUser: msg.isUser);
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: AppTheme.primaryGreen),
              ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.borderGray, width: 2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ketik kalimat untuk diterjemahkan...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppTheme.borderGray,
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isLoading
                    ? AppTheme.borderGray
                    : AppTheme.secondaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
