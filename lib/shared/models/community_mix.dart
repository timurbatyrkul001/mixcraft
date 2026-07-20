import 'mood.dart';

/// Topluluktan derlenmiş mix tarifi (ivankalyanshop.ru gibi).
/// Aroma id'leri yerine ham marka + aroma adı string'i tutar
/// çünkü her aroma bizim catalog'ta olmayabilir.
class CommunityMix {
  const CommunityMix({
    required this.id,
    required this.name,
    required this.category,
    required this.mood,
    required this.components,
    this.source = 'ivankalyanshop.ru',
  });

  final String id;
  final String name; // "Dessert #53"
  final String category; // "Dessert", "Tropical", etc.
  final Mood mood;
  final List<CommunityComponent> components;
  final String source;
}

class CommunityComponent {
  const CommunityComponent({
    required this.brand,
    required this.flavor,
    required this.ratio,
  });

  final String brand; // "Blackburn", "Must Have"
  final String flavor; // "Brownie", "Pinkman"
  final int ratio; // yüzde
}

/// Bir community mix'in kullanıcı stoğuna ne kadar uyduğu.
class MixMatch {
  const MixMatch({
    required this.mix,
    required this.coveragePercent, // 0-100, stoktaki bileşenlerin toplam oranı
    required this.matchedComponents,
    required this.missingComponents,
  });

  final CommunityMix mix;
  final int coveragePercent;
  final List<CommunityComponent> matchedComponents;
  final List<CommunityComponent> missingComponents;

  bool get isComplete => missingComponents.isEmpty;
  bool get isMostlyComplete => coveragePercent >= 70;
}
