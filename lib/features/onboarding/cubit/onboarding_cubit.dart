import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_state.dart';
import '../../../core/utils/app_constants.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void onPageChanged(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void nextPage(int totalPages) {
    if (state.currentPage < totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyOnboardingDone, true);
    } catch (_) {
      // Fail silently — user still proceeds
    } finally {
      emit(state.copyWith(isDone: true));
    }
  }

  Future<void> skipOnboarding() async {
    await completeOnboarding();
  }
}
