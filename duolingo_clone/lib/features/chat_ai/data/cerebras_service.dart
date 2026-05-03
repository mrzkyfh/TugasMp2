import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:fluenta/core/constants/api_constants.dart';

class CerebrasService {
  late final Dio _dio;

  CerebrasService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.cerebrasBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          if (ApiConstants.hasCerebrasApiKey)
            'Authorization': 'Bearer ${ApiConstants.cerebrasApiKey}',
        },
      ),
    );
  }

  Future<String> sendMessage(String text) async {
    if (!ApiConstants.hasCerebrasApiKey) {
      return _fallbackTranslation(text, reason: 'Cerebras API key is missing.');
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/chat/completions',
        data: {
          'model': ApiConstants.cerebrasModel,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are Fluenta, an Indonesian-to-English translator. Translate every user message into natural English. Reply with exactly two short lines: "Translation: ..." and "Tip: ...". Do not use markdown.',
            },
            {'role': 'user', 'content': text},
          ],
          'temperature': 0.2,
          'max_completion_tokens': 140,
        },
      );

      final content = _readAssistantContent(response.data);
      return content.isNotEmpty
          ? content
          : _fallbackTranslation(
              text,
              reason: 'Cerebras returned an empty response.',
            );
    } catch (e) {
      developer.log(
        'Cerebras request failed',
        name: 'CerebrasService',
        error: e,
      );
      return _fallbackTranslation(text, reason: _failureReason(e));
    }
  }

  String _readAssistantContent(Map<String, dynamic>? data) {
    final choices = data?['choices'];
    if (choices is! List || choices.isEmpty) return '';

    final firstChoice = choices.first;
    if (firstChoice is! Map) return '';

    final message = firstChoice['message'];
    if (message is! Map) return '';

    final content = message['content'];
    return content is String ? content.trim() : '';
  }

  String _failureReason(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data.toString() ?? error.message ?? '';

      if (statusCode == 401 || statusCode == 403) {
        return 'Cerebras API key is invalid or does not have access.';
      }

      if (statusCode == 404 || message.toLowerCase().contains('model')) {
        return 'Cerebras model is unavailable for this API key.';
      }

      if (statusCode == 429 || message.toLowerCase().contains('quota')) {
        return 'Cerebras quota or rate limit was reached. Please try again shortly.';
      }

      if (statusCode != null && statusCode >= 500) {
        return 'Cerebras is temporarily unavailable. Please try again in a moment.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'Network connection to Cerebras failed.';
      }
    }

    return 'Cerebras request failed. Check the console for details.';
  }

  String _fallbackTranslation(String text, {String? reason}) {
    final normalized = text.trim().toLowerCase().replaceAll(
      RegExp(r'[^\w\s]'),
      '',
    );
    final phraseTranslation = _phraseTranslations[normalized];

    if (phraseTranslation != null) {
      return phraseTranslation;
    }

    final translatedWords = normalized
        .split(RegExp(r'\s+'))
        .map(_translateWord)
        .join(' ');

    final status = reason == null ? '' : '\nStatus: $reason';
    return 'Translation: $translatedWords$status\nTip: This is an offline English translation.';
  }

  String _translateWord(String word) {
    if (_wordTranslations.containsKey(word)) {
      return _wordTranslations[word]!;
    }

    if (word.endsWith('nya')) {
      final baseWord = word.substring(0, word.length - 3);
      final baseTranslation = _wordTranslations[baseWord];
      if (baseTranslation != null) {
        return 'the $baseTranslation';
      }
    }

    return word;
  }

  static const Map<String, String> _phraseTranslations = {
    'apakah kamu sudah makan':
        'Translation: Have you eaten yet?\nTip: "Sudah" means "already/yet" depending on the sentence.',
    'kamu apa kabar':
        'Translation: How are you?\nTip: A more natural Indonesian phrase is "Apa kabar?"',
    'apa kabar':
        'Translation: How are you?\nTip: This is a common greeting, not a literal question about news.',
    'kok campuran bahasanya':
        'Translation: Why is the language mixed?\nTip: "Kok" is casual Indonesian for "why/how come".',
    'ko campuran bahasanya':
        'Translation: Why is the language mixed?\nTip: "Ko" is often used casually for "kok".',
    'kok campuran':
        'Translation: Why is it mixed?\nTip: "Campuran" means "mixed".',
    'ko campuran':
        'Translation: Why is it mixed?\nTip: "Campuran" means "mixed".',
    'saya mau belajar bahasa inggris':
        'Translation: I want to learn English.\nTip: "Mau" is commonly used for "want to".',
    'selamat pagi':
        'Translation: Good morning.\nTip: Use this greeting before noon.',
    'terima kasih':
        'Translation: Thank you.\nTip: A common reply is "sama-sama".',
  };

  static const Map<String, String> _wordTranslations = {
    'aku': 'i',
    'saya': 'i',
    'kamu': 'you',
    'anda': 'you',
    'dia': 'he/she',
    'mereka': 'they',
    'kami': 'we',
    'kita': 'we',
    'apakah': 'do/does',
    'apa': 'what',
    'kabar': 'news',
    'kok': 'why',
    'ko': 'why',
    'kenapa': 'why',
    'sudah': 'already',
    'belum': 'not yet',
    'makan': 'eat',
    'minum': 'drink',
    'belajar': 'learn',
    'bahasa': 'language',
    'inggris': 'english',
    'indonesia': 'indonesian',
    'mau': 'want',
    'ingin': 'want',
    'campuran': 'mixed',
    'bahasanya': 'the language',
    'pergi': 'go',
    'ke': 'to',
    'rumah': 'home',
    'sekolah': 'school',
    'pagi': 'morning',
    'siang': 'afternoon',
    'malam': 'night',
    'terima': 'accept',
    'kasih': 'love',
  };
}
