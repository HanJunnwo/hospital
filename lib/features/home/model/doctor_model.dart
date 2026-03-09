class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviewCount;
  final String experience;
  final bool isAvailable;
  final String? avatarInitials;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    this.isAvailable = true,
    this.avatarInitials,
  });
}

class DoctorData {
  static const List<DoctorModel> items = [
    DoctorModel(
      id: 'd1',
      name: 'Dr. Andi Prakoso, Sp.JP',
      specialty: 'Spesialis Jantung',
      hospital: 'RS Cipto Mangunkusumo',
      rating: 4.9,
      reviewCount: 1243,
      experience: '15 Tahun',
      isAvailable: true,
      avatarInitials: 'AP',
    ),
    DoctorModel(
      id: 'd2',
      name: 'Dr. Sari Dewi, Sp.A',
      specialty: 'Spesialis Anak',
      hospital: 'RS Fatmawati',
      rating: 4.8,
      reviewCount: 987,
      experience: '10 Tahun',
      isAvailable: true,
      avatarInitials: 'SD',
    ),
    DoctorModel(
      id: 'd3',
      name: 'Dr. Rudi Setiawan, Sp.M',
      specialty: 'Spesialis Mata',
      hospital: 'RS Persahabatan',
      rating: 4.7,
      reviewCount: 762,
      experience: '12 Tahun',
      isAvailable: false,
      avatarInitials: 'BS',
    ),
    DoctorModel(
      id: 'd4',
      name: 'Dr. Rina Kusuma, Sp.KK',
      specialty: 'Spesialis Kulit',
      hospital: 'RS Hasan Sadikin',
      rating: 4.9,
      reviewCount: 1105,
      experience: '8 Tahun',
      isAvailable: true,
      avatarInitials: 'RK',
    ),
    DoctorModel(
      id: 'd5',
      name: 'Dr. Hendra Wijaya, Sp.OT',
      specialty: 'Spesialis Ortopedi',
      hospital: 'RS Siloam',
      rating: 4.6,
      reviewCount: 543,
      experience: '18 Tahun',
      isAvailable: true,
      avatarInitials: 'HW',
    ),
    DoctorModel(
      id: 'd6',
      name: 'Dr. Maya Sari, drg.',
      specialty: 'Dokter Gigi',
      hospital: 'Klinik Gigi Sehat',
      rating: 4.8,
      reviewCount: 432,
      experience: '6 Tahun',
      isAvailable: true,
      avatarInitials: 'MS',
    ),
  ];
}
