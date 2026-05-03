import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/chat_ai/presentation/chat_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/home/presentation/main_layout_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainLayoutScreen(),
    ),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
    GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
  ],
);
