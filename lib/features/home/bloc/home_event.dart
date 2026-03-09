part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeDataLoadRequested extends HomeEvent {
  const HomeDataLoadRequested();
}

class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

class HomeCategorySelected extends HomeEvent {
  final int index;
  const HomeCategorySelected(this.index);

  @override
  List<Object?> get props => [index];
}

class HomeDoctorSearched extends HomeEvent {
  final String query;
  const HomeDoctorSearched(this.query);

  @override
  List<Object?> get props => [query];
}
