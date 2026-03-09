part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isDone;

  const OnboardingState({
    this.currentPage = 0,
    this.isDone = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isDone,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [currentPage, isDone];
}
