import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  String selectedCategory = 'Semua';

  final List<Map<String, dynamic>> words = [
    {
      'word': 'Eloquent',
      'pronunciation': '/ˈɛləkwənt/',
      'definition': 'Fasih atau persuasif dalam berbicara maupun menulis.',
      'level': 'Frasa Fasih',
      'levelColor': Color(0xFF10B981),
      'category': 'Bisnis',
    },
    {
      'word': 'Serendipity',
      'pronunciation': '/ˌsɛrənˈdɪpɪti/',
      'definition':
          'Kejadian dan perkembangan peristiwa secara kebetulan dengan cara yang menyenangkan atau menguntungkan.',
      'level': 'Kata Hari Ini',
      'levelColor': AppTheme.primaryBlue,
      'category': 'Semua',
      'isWordOfDay': true,
    },
    {
      'word': 'Resilience',
      'pronunciation': '/rɪˈzɪliəns/',
      'definition': 'Kemampuan untuk pulih dengan cepat dari kesulitan.',
      'level': 'Menengah',
      'levelColor': Color(0xFFF59E0B),
      'category': 'Perjalanan',
    },
    {
      'word': 'Ubiquitous',
      'pronunciation': '/juːˈbɪkwɪtəs/',
      'definition': 'Hadir, muncul, atau ditemukan di mana-mana.',
      'level': 'Mahir',
      'levelColor': Color(0xFFFACC15),
      'category': 'Semua',
    },
    {
      'word': 'Melancholy',
      'pronunciation': '/ˈmɛlənkɒli/',
      'definition':
          'Perasaan sedih yang mendalam, biasanya tanpa sebab yang jelas.',
      'level': 'Menengah',
      'levelColor': Color(0xFFF59E0B),
      'category': 'Semua',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredWords = selectedCategory == 'Semua'
        ? words
        : words.where((w) => w['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryBlue),
          onPressed: () {
            try {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              // Ignore pop errors
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE2E8F0),
                    width: 2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu, size: 24),
                        color: AppTheme.primaryBlue,
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Text(
                      'Fluenta',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryBlue,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Icon(
                          Icons.person,
                          color: AppTheme.textLight,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Kata-kataku',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari 1.245 kata...',
                            hintStyle: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.textLight,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip('Semua', true),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Bisnis', false),
                            const SizedBox(width: 8),
                            _buildCategoryChip('Perjalanan', false),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.tune,
                                color: AppTheme.primaryBlue,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Word Cards
                      ...filteredWords.map((wordData) {
                        if (wordData['isWordOfDay'] == true) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildWordOfDayCard(wordData),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildWordCard(wordData),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Progress Section
                      _buildProgressSection(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : const Color(0xFFE2E8F0),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMain,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(Map<String, dynamic> wordData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: wordData['levelColor'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  wordData['level'],
                  style: TextStyle(
                    color: wordData['levelColor'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            wordData['word'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            wordData['pronunciation'],
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Text(
              wordData['definition'],
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textMain,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordOfDayCard(Map<String, dynamic> wordData) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF1E40AF),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppTheme.secondaryYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'KATA HARI INI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            wordData['word'],
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            wordData['pronunciation'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            wordData['definition'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Tambah ke Kata-kataku',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Pelajari',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 0.73,
                  strokeWidth: 12,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlue,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '73%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                  Text(
                    'dikuasai',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Kamu terus berkembang!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Kamu sudah menguasai 91 kata baru bulan ini. Terus semangat! Target 125 kata sudah hampir tercapai.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLight,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Progress Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '91 / 125 kata',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMain,
                    ),
                  ),
                  Text(
                    '73%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: 0.73,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Mulai Kuis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
