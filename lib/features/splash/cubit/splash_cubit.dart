import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_state.dart';
import '../../../core/utils/app_constants.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Future<void> initialize() async {
    emit(const SplashLoading());

    // Simulate splash delay for animation
    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashDurationMs),
    );

    await _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone =
          prefs.getBool(AppConstants.keyOnboardingDone) ?? false;

      if (onboardingDone) {
        emit(const SplashNavigateToHome());
      } else {
        emit(const SplashNavigateToOnboarding());
      }
    } catch (_) {
      emit(const SplashNavigateToOnboarding());
    }
  }
}
