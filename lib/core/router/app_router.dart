import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/bloc/splash_bloc.dart';
import '../../features/splash/view/splash_page.dart';
import '../../features/onboarding/bloc/onboarding_bloc.dart';
import '../../features/onboarding/view/onboarding_page.dart';
import '../../features/auth/view/login_page.dart';
import '../../features/auth/view/register_page.dart';
import '../../features/main_scaffold/view/main_scaffold.dart';
import '../../features/notification/view/notification_page.dart';
import '../../features/doctor/view/all_doctors_page.dart';
import '../../features/doctor/view/doctor_detail_page.dart';
import '../../features/appointment/view/book_appointment_page.dart';
import '../../features/appointment/view/appointment_detail_page.dart';
import '../../features/profile/view/edit_profile_page.dart';
import '../../features/favorites/view/favorites_page.dart';
import '../../features/settings/view/notification_settings_page.dart';
import '../../features/settings/view/security_settings_page.dart';
import '../../features/help/view/help_center_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String history = '/history';
  static const String profile = '/profile';
  // New routes
  static const String notifications = '/notifications';
  static const String allDoctors = '/all-doctors';
  static const String doctorDetail = '/doctor/:id';
  static const String bookAppointment = '/book/:doctorId';
  static const String appointmentDetail = '/appointment-detail';
  static const String editProfile = '/edit-profile';
  static const String favorites = '/favorites';
  static const String notificationSettings = '/notification-settings';
  static const String securitySettings = '/security-settings';
  static const String helpCenter = '/help-center';
}

class AppRouter {
  AppRouter._();

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => BlocProvider(
            create: (_) => SplashBloc()..add(const SplashInitializeRequested()),
            child: const SplashPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) => BlocProvider(
            create: (_) => OnboardingBloc(),
            child: const OnboardingPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        // New standalone routes (no bottom nav)
        GoRoute(
          path: AppRoutes.notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationPage(),
        ),
        GoRoute(
          path: AppRoutes.allDoctors,
          name: 'allDoctors',
          builder: (context, state) => const AllDoctorsPage(),
        ),
        GoRoute(
          path: '/doctor/:id',
          name: 'doctorDetail',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return DoctorDetailPage(doctorId: id);
          },
        ),
        GoRoute(
          path: '/book/:doctorId',
          name: 'bookAppointment',
          builder: (context, state) {
            final doctorId = state.pathParameters['doctorId'] ?? '';
            return BookAppointmentPage(doctorId: doctorId);
          },
        ),
        GoRoute(
          path: AppRoutes.appointmentDetail,
          name: 'appointmentDetail',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return AppointmentDetailPage(data: extra);
          },
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          name: 'editProfile',
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.favorites,
          name: 'favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: AppRoutes.notificationSettings,
          name: 'notificationSettings',
          builder: (context, state) => const NotificationSettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.securitySettings,
          name: 'securitySettings',
          builder: (context, state) => const SecuritySettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.helpCenter,
          name: 'helpCenter',
          builder: (context, state) => const HelpCenterPage(),
        ),
        // Shell route with bottom nav
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const SizedBox.shrink(),
            ),
            GoRoute(
              path: AppRoutes.schedule,
              name: 'schedule',
              builder: (context, state) => const SizedBox.shrink(),
            ),
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              builder: (context, state) => const SizedBox.shrink(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}
