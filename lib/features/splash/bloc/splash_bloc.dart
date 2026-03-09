import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/app_constants.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<SplashInitializeRequested>(_onInitializeRequested);
  }

  Future<void> _onInitializeRequested(
    SplashInitializeRequested event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());

    // Minimum splash display time
    await Future.delayed(const Duration(milliseconds: AppConstants.splashDurationMs));

    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool(AppConstants.keyOnboardingDone) ?? false;
      final isLoggedIn = prefs.getBool(AppConstants.keyLoggedIn) ?? false;

      if (!onboardingDone) {
        emit(const SplashNavigateToOnboarding());
      } else if (isLoggedIn) {
        emit(const SplashNavigateToHome());
      } else {
        emit(const SplashNavigateToLogin());
      }
    } catch (_) {
      emit(const SplashNavigateToOnboarding());
    }
  }
}
