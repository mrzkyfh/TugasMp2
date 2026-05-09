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
      return _fallbackTranslation(text, reason: 'API key Cerebras tidak ditemukan.');
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
                  'Kamu adalah Fluenta, teman belajar bahasa Inggris yang asik dan supportif! '
                  'Tugasmu menerjemahkan teks bahasa Indonesia ke bahasa Inggris dengan cara yang menyenangkan. '
                  'Balas HANYA dengan dua baris ini:\n'
                  'Terjemahan: [terjemahan bahasa Inggris yang natural]\n'
                  'Tips: [tips singkat yang asik dan mudah dipahami tentang kata atau frasa tersebut, pakai bahasa santai]\n\n'
                  'Aturan:\n'
                  '- Selalu terjemahkan apapun yang dikirim, jangan nolak atau balik nanya.\n'
                  '- Kalau teksnya sudah bahasa Inggris, perbaiki biar lebih natural.\n'
                  '- Tipsnya dibuat santai, kayak ngobrol sama teman, bukan kayak buku pelajaran.\n'
                  '- Jangan pakai markdown atau format lain di luar dua baris itu.',
            },
            {
              'role': 'user',
              'content': 'saya mau pergi ke pasar',
            },
            {
              'role': 'assistant',
              'content':
                  'Terjemahan: I want to go to the market.\nTips: "Mau" itu bisa jadi "want to" — simpel banget kan? Coba hafalin yang ini dulu! 😄',
            },
            {
              'role': 'user',
              'content': 'apa kabar kamu hari ini?',
            },
            {
              'role': 'assistant',
              'content':
                  'Terjemahan: How are you doing today?\nTips: "Apa kabar" itu artinya harfiah "what news" tapi orang Inggris pakainya "How are you?" — beda ya! 😊',
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
              reason: 'Cerebras mengembalikan respons kosong.',
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
        return 'API key Cerebras tidak valid atau tidak memiliki akses.';
      }

      if (statusCode == 404 || message.toLowerCase().contains('model')) {
        return 'Model Cerebras tidak tersedia untuk API key ini.';
      }

      if (statusCode == 429 || message.toLowerCase().contains('quota')) {
        return 'Batas kuota atau rate limit Cerebras tercapai. Coba lagi sebentar.';
      }

      if (statusCode != null && statusCode >= 500) {
        return 'Cerebras sedang tidak tersedia. Coba lagi dalam beberapa saat.';
      }

      if (error.type == DioExceptionType.connectionError) {
        return 'Koneksi jaringan ke Cerebras gagal.';
      }
    }

    return 'Permintaan ke Cerebras gagal. Periksa konsol untuk detail.';
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
    return 'Terjemahan: $translatedWords$status\nTips: Ini terjemahan offline ya — koneksi ke AI lagi putus. Coba lagi sebentar! 🔌';
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
        'Terjemahan: Have you eaten yet?\nTips: "Sudah" itu bisa jadi "already" atau "yet" — tergantung kalimatnya positif atau negatif. Keren kan? 😄',
    'kamu apa kabar':
        'Terjemahan: How are you?\nTips: Versi yang lebih natural di Indonesia adalah "Apa kabar?" — lebih singkat dan enak diucapkan! 😊',
    'apa kabar':
        'Terjemahan: How are you?\nTips: Meski artinya harfiah "what news", orang pakai ini buat nyapa — sama kayak "How are you?" di Inggris! 👋',
    'kok campuran bahasanya':
        'Terjemahan: Why is the language mixed?\nTips: "Kok" itu kata ajaib buat nanya dengan nada heran — kayak "how come" atau "why" tapi lebih santai! 😄',
    'ko campuran bahasanya':
        'Terjemahan: Why is the language mixed?\nTips: "Ko" itu versi singkat dari "kok" — sering dipakai di chat biar lebih cepat nulisnya! ⚡',
    'kok campuran':
        'Terjemahan: Why is it mixed?\nTips: "Campuran" = "mixed" — gampang banget diinget karena bunyinya mirip! 🎯',
    'ko campuran':
        'Terjemahan: Why is it mixed?\nTips: "Campuran" = "mixed" — kata yang sering muncul di percakapan sehari-hari! 💬',
    'saya mau belajar bahasa inggris':
        'Terjemahan: I want to learn English.\nTips: "Mau" itu serba guna banget — bisa jadi "want to" atau "going to". Dua-duanya bener! 🙌',
    'selamat pagi':
        'Terjemahan: Good morning.\nTips: Pakai ini sebelum jam 12 siang ya — kalau siang bilang "Good afternoon", kalau malam "Good evening"! ☀️',
    'terima kasih':
        'Terjemahan: Thank you.\nTips: Balasannya "You\'re welcome" atau "sama-sama" kalau lagi ngobrol sama orang Indonesia! 😊',
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
