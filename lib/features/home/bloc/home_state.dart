part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<DoctorModel> doctors;
  final List<CategoryModel> categories;
  final List<BannerModel> banners;
  final String userName;
  final int selectedCategoryIndex;

  const HomeLoaded({
    required this.doctors,
    required this.categories,
    required this.banners,
    required this.userName,
    this.selectedCategoryIndex = 0,
  });

  HomeLoaded copyWith({
    List<DoctorModel>? doctors,
    List<CategoryModel>? categories,
    List<BannerModel>? banners,
    String? userName,
    int? selectedCategoryIndex,
  }) {
    return HomeLoaded(
      doctors: doctors ?? this.doctors,
      categories: categories ?? this.categories,
      banners: banners ?? this.banners,
      userName: userName ?? this.userName,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }

  @override
  List<Object?> get props =>
      [doctors, categories, banners, userName, selectedCategoryIndex];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
