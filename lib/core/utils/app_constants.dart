class AppConstants {
  AppConstants._();

  static const String appName = 'OmniHealth';
  static const String appTagline = 'Kesehatan Ada di Genggaman';

  // SharedPreferences Keys
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyLoggedIn = 'logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';

  // Animation Durations
  static const int splashDurationMs = 2800;
  static const int animationFastMs = 200;
  static const int animationNormalMs = 300;
  static const int animationSlowMs = 500;

  // Padding / Radius
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 100.0;

  // Bottom Nav
  static const int navIndexHome = 0;
  static const int navIndexSchedule = 1;
  static const int navIndexHistory = 2;
  static const int navIndexProfile = 3;
}

class AppStrings {
  AppStrings._();

  // Navigation labels
  static const String navHome = 'Beranda';
  static const String navSchedule = 'Jadwal';
  static const String navHistory = 'Riwayat';
  static const String navProfile = 'Profil';

  // Onboarding
  static const String onboardingSkip = 'Lewati';
  static const String onboardingNext = 'Selanjutnya';
  static const String onboardingStart = 'Mulai Sekarang';

  static const String onboarding1Title = 'Layanan Kesehatan Terbaik';
  static const String onboarding1Desc =
      'Dapatkan akses layanan kesehatan berkualitas tinggi dengan mudah dan cepat di mana saja.';

  static const String onboarding2Title = 'Pilih Dokter Spesialis';
  static const String onboarding2Desc =
      'Temukan dokter spesialis terpercaya sesuai kebutuhanmu dan buat janji temu kapan saja.';

  static const String onboarding3Title = 'Pantau Kesehatan Anda';
  static const String onboarding3Desc =
      'Lihat riwayat pemeriksaan, hasil lab, dan kelola jadwal konsultasi dalam satu aplikasi.';

  // Home
  static const String homeGreetingMorning = 'Selamat Pagi';
  static const String homeGreetingAfternoon = 'Selamat Siang';
  static const String homeGreetingEvening = 'Selamat Malam';
  static const String homeSearchHint = 'Cari dokter, spesialis...';
  static const String homeSpecialities = 'Kategori Spesialis';
  static const String homeAvailableDoctor = 'Dokter Tersedia';
  static const String homeSeeAll = 'Lihat Semua';
  static const String homePromo = 'Promo & Info Kesehatan';
}
