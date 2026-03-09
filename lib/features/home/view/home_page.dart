import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_constants.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/promo_banner_widget.dart';
import 'widgets/category_section.dart';
import 'widgets/doctor_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeDataLoadRequested()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const _HomeShimmer();
          }

          if (state is HomeError) {
            return _HomeError(message: state.message);
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async =>
                  context.read<HomeBloc>().add(const HomeRefreshRequested()),
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: HomeHeader(userName: state.userName),
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingM,
                      ),
                      child: SearchBarWidget(
                        onChanged: (q) => context
                            .read<HomeBloc>()
                            .add(HomeDoctorSearched(q)),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Promo Banner
                  SliverToBoxAdapter(
                    child: PromoBannerWidget(banners: state.banners),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Category Section
                  SliverToBoxAdapter(
                    child: CategorySection(
                      categories: state.categories,
                      selectedIndex: state.selectedCategoryIndex,
                      onSelected: (i) => context
                          .read<HomeBloc>()
                          .add(HomeCategorySelected(i)),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Section Title
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.homeAvailableDoctor,
                            style: AppTextStyles.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AppStrings.homeSeeAll,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Doctors list
                  state.doctors.isEmpty
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(AppConstants.paddingL),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 56,
                                    color: AppColors.textHint,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Dokter tidak ditemukan',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingM,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: DoctorCard(
                                      doctor: state.doctors[index]),
                                );
                              },
                              childCount: state.doctors.length,
                            ),
                          ),
                        ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HomeShimmer extends StatefulWidget {
  const _HomeShimmer();

  @override
  State<_HomeShimmer> createState() => _HomeShimmerState();
}

class _HomeShimmerState extends State<_HomeShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _shimmerBox(220, double.infinity, 0),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                child: _shimmerBox(52, double.infinity, 12),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
                child: _shimmerBox(140, double.infinity, 16),
              ),
              const SizedBox(height: 16),
              ...List.generate(3, (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM, vertical: 6),
                  child: _shimmerBox(88, double.infinity, 16),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(double height, double width, double radius) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (_, __) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _shimmerAnimation.value, 0),
              end: Alignment(1 + _shimmerAnimation.value, 0),
              colors: const [
                Color(0xFFE8EDF5),
                Color(0xFFF4F7FE),
                Color(0xFFE8EDF5),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeError extends StatelessWidget {
  final String message;
  const _HomeError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 56, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context
                .read<HomeBloc>()
                .add(const HomeRefreshRequested()),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
