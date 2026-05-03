import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.primaryBlue),
              onPressed: () {},
            ),
            Text(
              'Fluenta',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: AppTheme.primaryBlue,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDelY3GaSGMCqZ3XE1XnU1ugLUj0eIVUi_A6k1X70Yp35G98F9myiggaX0DgDkHgj_37YXxQ9FB1txRuIKttHKwPrsKo1wkyrUuvAxFoXU63d9Q99f2XBwYrWuw7RxoEySWZ3EfRrB2FhlldLqsDMo5pQGbHD3hGc6V8sEYF42hEm09y6qrWv24m5c7weh_nVI4xRL9F-bhBlSnRO6fxcP7TAbf1T9qfAwTvl8VpeSVaYIXpIouUE4lwMBKSns1cn7ODegf7Xum6Po',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Header
            Stack(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCwLaOc4aMnzByo8uBNJ-qyBq09d-iHqUzBPeKjVGjnNL7c8r-q9QLf8y1Tc04VVvzLimn2yxg_8KbO6iMPdVlyF9P2giPrOI877FYNr8u-P6pdycGml9cDBKPAQYRl5ze5RZeVKj9xNZlPhxm06_A7SduunQW_S_N7XHxSgfG-OInufS4dzfVJOIFOnoj2fv1PxPUPu7nIup8hacpcnl6lCqpT5JtAc8pdsVOig18e-T4Jr07oM66smxg9FQ38zx8lPZz8xo1o0Lg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Color(0xFF6F5900),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Alex Rivers',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Language Enthusiast • Level 24',
              style: GoogleFonts.lexend(
                fontSize: 16,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLanguageTag('English (Fluent)', AppTheme.primaryBlue, const Color(0xFFE0E7FF)),
                const SizedBox(width: 8),
                _buildLanguageTag('Spanish (Learning)', AppTheme.tertiaryOrange, const Color(0xFFFFEDD5)),
              ],
            ),
            const SizedBox(height: 40),

            // Statistics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  icon: Icons.menu_book,
                  value: '1,248',
                  label: 'WORDS LEARNED',
                  color: AppTheme.primaryBlue,
                  bgColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                ),
                _buildStatCard(
                  icon: Icons.quiz,
                  value: '86',
                  label: 'QUIZZES TAKEN',
                  color: AppTheme.secondaryYellow,
                  bgColor: AppTheme.secondaryYellow.withValues(alpha: 0.2),
                ),
                _buildStatCard(
                  icon: Icons.local_fire_department,
                  value: '14',
                  label: 'DAY STREAK',
                  color: AppTheme.tertiaryOrange,
                  bgColor: AppTheme.tertiaryOrange.withValues(alpha: 0.1),
                ),
                _buildStatCard(
                  icon: Icons.timer,
                  value: '42h',
                  label: 'STUDY TIME',
                  color: AppTheme.textMain,
                  bgColor: const Color(0xFFDCE9FF),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Badges Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Earned Badges',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMain,
                        ),
                      ),
                      Text(
                        'View All',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadgeItem('EARLY BIRD', Icons.workspace_premium, [Colors.yellow.shade100, Colors.yellow.shade300], Colors.yellow.shade700),
                      _buildBadgeItem('VOCAB KING', Icons.auto_awesome, [Colors.blue.shade100, Colors.blue.shade300], Colors.blue.shade700),
                      _buildBadgeItem('SOCIALIZER', Icons.military_tech, [Colors.orange.shade100, Colors.orange.shade300], Colors.orange.shade700),
                      _buildBadgeItem('POLYGLOT', Icons.lock, [Colors.grey.shade200, Colors.grey.shade200], Colors.grey.shade500, isLocked: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // App Settings Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Settings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.notifications,
                    title: 'Reminders & Notifications',
                    subtitle: 'Daily goals and study alerts',
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
                  ),
                  const Divider(height: 1, color: Color(0xFFF8FAFC)),
                  _buildSettingItem(
                    icon: Icons.dark_mode,
                    title: 'Display & Theme',
                    subtitle: 'Light, Dark, or System mode',
                    trailing: Switch(
                      value: true,
                      onChanged: (v) {},
                      activeColor: Colors.white,
                      activeTrackColor: AppTheme.primaryBlue,
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF8FAFC)),
                  _buildSettingItem(
                    icon: Icons.translate,
                    title: 'Target Language',
                    subtitle: 'Change your learning focus',
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
                  ),
                  const Divider(height: 1, color: Color(0xFFF8FAFC)),
                  _buildSettingItem(
                    icon: Icons.verified_user,
                    title: 'Account Privacy',
                    subtitle: 'Profile visibility and data',
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Sign Out Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppTheme.dangerRed),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.dangerRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTag(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.textLight,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String label, IconData icon, List<Color> gradient, Color iconColor, {bool isLocked = false}) {
    return Opacity(
      opacity: isLocked ? 0.4 : 1.0,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withValues(alpha: 0.2),
                  width: 4,
                ),
              ),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 60,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: AppTheme.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

