import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/app_constants.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextRequested>(_onNextRequested);
    on<OnboardingPreviousRequested>(_onPreviousRequested);
    on<OnboardingSkipRequested>(_onSkipRequested);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.page));
  }

  void _onNextRequested(
    OnboardingNextRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.currentPage < event.totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    } else {
      add(const OnboardingSkipRequested());
    }
  }

  void _onPreviousRequested(
    OnboardingPreviousRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  Future<void> _onSkipRequested(
    OnboardingSkipRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyOnboardingDone, true);
    } catch (_) {
      // Fail silently — user still proceeds
    } finally {
      emit(state.copyWith(isDone: true));
    }
  }
}
