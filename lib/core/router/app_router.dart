import 'package:go_router/go_router.dart';
import 'package:register_offline/features/authentication/presentation/pages/login_page.dart';
import 'package:register_offline/features/authentication/presentation/pages/splash_page.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/presentation/pages/add_member_page.dart';
import 'package:register_offline/features/member/presentation/pages/home_page.dart';
import 'package:register_offline/features/profile/presentation/pages/profile_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String addMember = '/add-member';
  static const String editMember = '/edit-member';
  static const String profile = '/profile';
}

final router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        final token = state.extra as String? ?? '';
        return HomePage(token: token);
      },
    ),
    GoRoute(
      path: AppRoutes.addMember,
      builder: (context, state) {
        final token = state.extra as String? ?? '';
        return AddMemberPage(token: token);
      },
    ),
    GoRoute(
      path: AppRoutes.editMember,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return AddMemberPage(
          token: extra['token'] as String,
          existingMember: extra['member'] as MemberLocal?,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ProfilePage(token: extra['token'] as String);
      },
    ),
  ],
);
