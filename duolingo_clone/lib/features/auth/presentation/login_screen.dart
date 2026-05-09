import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluenta/core/theme/app_theme.dart';
import 'package:fluenta/shared/widgets/rive_character.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _animationName;
  String? _stateMachineName = 'Login Machine';
  Map<String, dynamic> _riveInputs = {
    'isHandsUp': false,
    'numLook': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_updateInputAnimation);
    _passwordFocusNode.addListener(_updateInputAnimation);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.removeListener(_updateInputAnimation);
    _passwordFocusNode.removeListener(_updateInputAnimation);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _updateInputAnimation() {
    debugPrint('UPDATE ANIMATION - Email focus: ${_emailFocusNode.hasFocus}, Password focus: ${_passwordFocusNode.hasFocus}, Loading: $_isLoading');
    
    if (_emailFocusNode.hasFocus) {
      setState(() {
        _stateMachineName = null;
        _animationName = 'Look_down_right'; // Use direct animation for looking down
        _riveInputs = {};
      });
      debugPrint('EMAIL FOCUS - Animation: $_animationName');
    } else if (_passwordFocusNode.hasFocus) {
      setState(() {
        _stateMachineName = 'Login Machine';
        _animationName = null;
        _riveInputs = {
          'isHandsUp': true, // Cover eyes for password
          'numLook': 0.0,
          'isChecking': false,
        };
      });
      debugPrint('PASSWORD FOCUS - State machine: $_stateMachineName, Inputs: $_riveInputs');
    } else if (!_isLoading) {
      setState(() {
        _stateMachineName = 'Login Machine';
        _animationName = null;
        _riveInputs = {
          'isHandsUp': false,
          'numLook': 0.0,
          'isChecking': false,
        };
      });
      debugPrint('IDLE - State machine: $_stateMachineName, Inputs: $_riveInputs');
    }
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email dan kata sandi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _stateMachineName = 'Login Machine';
      _animationName = null;
      _riveInputs = {
        'isHandsUp': false,
        'numLook': 0.0,
        'isChecking': true, // Checking animation during login
      };
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _stateMachineName = 'Login Machine';
        _animationName = null;
        _riveInputs = {
          'isHandsUp': false,
          'numLook': 0.0,
          'isChecking': false,
          'trigSuccess': true, // Trigger success animation
        };
      });
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (mounted) {
        setState(() {
          _stateMachineName = 'Login Machine';
          _animationName = null;
          _riveInputs = {
            'isHandsUp': false,
            'numLook': 0.0,
            'isChecking': false,
            'trigFail': true, // Trigger fail animation
          };
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${e.toString()}')),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() {
            _stateMachineName = 'Login Machine';
            _animationName = null;
            _riveInputs = {
              'isHandsUp': false,
              'numLook': 0.0,
              'isChecking': false,
            };
          });
        });
      }
    } finally {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'F',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Fluenta',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryBlue,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Kuasai bahasa dengan AI',
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 24),
                RiveCharacter(
                  riveAssetPath: 'assets/animations/fluenta_character/4771-9633-login-teddy.riv',
                  width: 220,
                  height: 220,
                  stateMachineName: _stateMachineName,
                  stateMachineInputs: _riveInputs,
                  animationName: _animationName,
                ),
                const SizedBox(height: 32),

                // Form Section
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Alamat Email',
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,                        focusNode: _emailFocusNode,                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('halo@contoh.com', Icons.email_outlined),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kata Sandi',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Text(
                            'Lupa?',
                            style: GoogleFonts.lexend(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: !_isPasswordVisible,
                        decoration: _inputDecoration('••••••••', Icons.lock_outline_rounded).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: AppTheme.textLight,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Masuk',
                                  style: GoogleFonts.lexend(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: GoogleFonts.lexend(
                        color: AppTheme.textLight,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: Text(
                        'Daftar Sekarang',
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.textLight, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFF),
      hintStyle: GoogleFonts.lexend(color: AppTheme.textLight.withValues(alpha: 0.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
      ),
    );
  }
}
