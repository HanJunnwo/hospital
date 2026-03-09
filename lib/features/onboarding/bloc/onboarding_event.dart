part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingPageChanged extends OnboardingEvent {
  final int page;
  const OnboardingPageChanged(this.page);

  @override
  List<Object?> get props => [page];
}

class OnboardingNextRequested extends OnboardingEvent {
  final int totalPages;
  const OnboardingNextRequested(this.totalPages);

  @override
  List<Object?> get props => [totalPages];
}

class OnboardingPreviousRequested extends OnboardingEvent {
  const OnboardingPreviousRequested();
}

class OnboardingSkipRequested extends OnboardingEvent {
  const OnboardingSkipRequested();
}
