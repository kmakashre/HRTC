// models/temple_model.dart
class Temple {
  final String id;
  final String name;
  final String location;
  final String description;
  final String history;
  final String builtYear;
  final List<String> features;
  final List<String> festivals;
  final String timings;
  final String entryFee;
  final List<String> tips;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> galleryImages;
  final String significance;

  Temple({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.history,
    required this.builtYear,
    required this.features,
    required this.festivals,
    required this.timings,
    required this.entryFee,
    required this.tips,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.galleryImages,
    required this.significance,
  });
}

// models/tour_guide_model.dart
class TourGuide {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> languages;
  final List<String> specializations;
  final String experience;
  final double pricePerHour;
  final double pricePerDay;
  final bool isAvailable;
  final String description;
  final String contactNumber;
  final List<String> certifications;

  TourGuide({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.languages,
    required this.specializations,
    required this.experience,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.isAvailable,
    required this.description,
    required this.contactNumber,
    required this.certifications,
  });
}
