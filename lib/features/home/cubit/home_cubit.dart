import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../model/doctor_model.dart';
import '../model/category_model.dart';
import '../model/banner_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());
    try {
      // Simulate network delay (replace with real repository call later)
      await Future.delayed(const Duration(milliseconds: 800));

      emit(HomeLoaded(
        doctors: DoctorData.items,
        categories: CategoryData.items,
        banners: BannerData.items,
        userName: 'Raihan Ramadhan',
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void selectCategory(int index) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(selectedCategoryIndex: index));
    }
  }

  void searchDoctor(String query) {
    final current = state;
    if (current is HomeLoaded) {
      if (query.isEmpty) {
        emit(current.copyWith(doctors: DoctorData.items));
        return;
      }
      final filtered = DoctorData.items
          .where((doc) =>
              doc.name.toLowerCase().contains(query.toLowerCase()) ||
              doc.specialty.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(current.copyWith(doctors: filtered));
    }
  }

  Future<void> refresh() async {
    await loadHomeData();
  }
}
