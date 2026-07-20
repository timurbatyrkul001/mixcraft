import 'mood.dart';

class Flavor {
  const Flavor({
    required this.id,
    required this.brandId,
    required this.name,
    required this.mood,
    this.description = '',
    this.strength = 5, // 1-10, sertlik/ağırlık
    this.tags = const [],
  });

  final String id;
  final String brandId;
  final String name;
  final Mood mood;
  final String description;
  final int strength;
  /// Aroma karakteri tag'leri — mix asistanı için (örn: 'pastane', 'taze', 'orman-meyveleri')
  final List<String> tags;
}
