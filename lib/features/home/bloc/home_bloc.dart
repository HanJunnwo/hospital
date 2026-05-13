import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/doctor_model.dart';
import '../model/category_model.dart';
import '../model/banner_model.dart';
import '../../../core/utils/app_constants.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeDataLoadRequested>(_onDataLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeDoctorSearched>(_onDoctorSearched);
  }

  Future<void> _onDataLoadRequested(
    HomeDataLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString(AppConstants.keyUserName) ?? 'Raihan Ramadhan';

      emit(HomeLoaded(
        doctors: DoctorData.items,
        categories: CategoryData.items,
        banners: BannerData.items,
        userName: userName,
      ));
    } catch (e) {
      emit(HomeError(message: 'Gagal memuat data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    await _onDataLoadRequested(const HomeDataLoadRequested(), emit);
  }

  void _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) {
    final current = state;
    if (current is HomeLoaded) {
      final newIndex = current.selectedCategoryIndex == event.index ? -1 : event.index;
      List<DoctorModel> filtered;
      
      if (newIndex == -1 || CategoryData.items[newIndex].id == 'all') {
        filtered = DoctorData.items;
      } else {
        // Find the category keyword, typically the first word (e.g. "Gigi" from "Gigi & Mulut")
        final categoryKeyword = CategoryData.items[newIndex].name.split(' ').first.toLowerCase();
        filtered = DoctorData.items.where((doc) {
          return doc.specialty.toLowerCase().contains(categoryKeyword);
        }).toList();
      }
      
      emit(current.copyWith(
        selectedCategoryIndex: newIndex,
        doctors: filtered,
      ));
    }
  }

  void _onDoctorSearched(
    HomeDoctorSearched event,
    Emitter<HomeState> emit,
  ) {
    final current = state;
    if (current is HomeLoaded) {
      if (event.query.isEmpty) {
        emit(current.copyWith(doctors: DoctorData.items));
        return;
      }
      final filtered = DoctorData.items
          .where((doc) =>
              doc.name.toLowerCase().contains(event.query.toLowerCase()) ||
              doc.specialty.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(current.copyWith(doctors: filtered));
    }
  }
}
