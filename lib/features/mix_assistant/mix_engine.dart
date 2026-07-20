import '../../shared/models/flavor.dart';
import '../../shared/models/mix.dart';
import '../../shared/models/mood.dart';

class MixSuggestion {
  const MixSuggestion({
    required this.title,
    required this.components,
    required this.dominantMood,
    required this.averageStrength,
    required this.rationale,
  });

  final String title;
  final List<MixComponent> components;
  final Mood dominantMood;
  final int averageStrength;
  final String rationale;
}

/// Stoktaki aromalardan kriter bazlı mix önerisi üreten rule-based motor.
/// Faz 2'de bunun yerine Claude API çağrısı gelecek.
class MixEngine {
  static List<MixSuggestion> suggest({
    required List<Flavor> available,
    Mood? targetMood,
    int? targetStrength,
    Set<String> requiredTags = const {},
    int count = 3,
  }) {
    if (available.length < 3) return [];

    // 1. Tag filtresi
    var taggedPool = requiredTags.isEmpty
        ? List<Flavor>.from(available)
        : available
            .where((f) => requiredTags.any((t) => f.tags.contains(t)))
            .toList();

    // Tag filtresi çok dar kaldıysa, etiketten 1 eşleşme yeterli yap
    if (taggedPool.length < 3) {
      taggedPool = List<Flavor>.from(available);
    }

    // 2. Sertlik tercihine göre ağırlıklı skor
    taggedPool.sort((a, b) {
      final aDist = targetStrength != null
          ? (a.strength - targetStrength).abs()
          : 0;
      final bDist = targetStrength != null
          ? (b.strength - targetStrength).abs()
          : 0;
      return aDist.compareTo(bDist);
    });

    // 3. Mood tercihine göre boost: hedef mood'daki aromaları öne al
    if (targetMood != null) {
      taggedPool.sort((a, b) {
        final aMatch = a.mood == targetMood ? 0 : 1;
        final bMatch = b.mood == targetMood ? 0 : 1;
        return aMatch.compareTo(bMatch);
      });
    }

    // 4. Farklı kombinasyon üret
    final suggestions = <MixSuggestion>[];
    final usedIds = <String>{};

    for (var i = 0; i < count; i++) {
      final pool = taggedPool.where((f) => !usedIds.contains(f.id)).toList();
      if (pool.length < 3) break;

      // Dominant: tag eşleşen ve sertlik yakın olan ilk aroma
      final dominant = pool.first;
      usedIds.add(dominant.id);

      // Secondary: tercihen farklı mood
      final secondary = pool.firstWhere(
        (f) =>
            f.id != dominant.id &&
            f.mood != dominant.mood &&
            !usedIds.contains(f.id),
        orElse: () => pool.firstWhere(
          (f) => f.id != dominant.id && !usedIds.contains(f.id),
          orElse: () => pool[1],
        ),
      );
      usedIds.add(secondary.id);

      // Accent: tercihen 3. farklı mood
      final accent = pool.firstWhere(
        (f) =>
            f.id != dominant.id &&
            f.id != secondary.id &&
            f.mood != dominant.mood &&
            f.mood != secondary.mood &&
            !usedIds.contains(f.id),
        orElse: () => pool.firstWhere(
          (f) =>
              f.id != dominant.id &&
              f.id != secondary.id &&
              !usedIds.contains(f.id),
          orElse: () => pool[2],
        ),
      );
      usedIds.add(accent.id);

      // Sertlik dengesi için oran düzenle:
      // - Eğer en güçlü dominantsa %40, dengeli kalır
      // - Eğer dominant zayıfsa, secondary'yi öne al
      final sortedByStrength = [dominant, secondary, accent]
        ..sort((a, b) => b.strength.compareTo(a.strength));

      final mainComponent = MixComponent(
        flavorId: dominant.id,
        ratio: 40,
      );
      final secondaryComponent =
          MixComponent(flavorId: secondary.id, ratio: 30);
      final accentComponent =
          MixComponent(flavorId: accent.id, ratio: 30);

      final avgStrength = ((dominant.strength * 40 +
                  secondary.strength * 30 +
                  accent.strength * 30) /
              100)
          .round();

      final title = _suggestTitle(i, dominant, secondary, accent);
      final rationale = _rationale(dominant, secondary, accent, sortedByStrength.first);

      suggestions.add(MixSuggestion(
        title: title,
        components: [mainComponent, secondaryComponent, accentComponent],
        dominantMood: dominant.mood,
        averageStrength: avgStrength,
        rationale: rationale,
      ));
    }

    return suggestions;
  }

  static String _suggestTitle(int i, Flavor d, Flavor s, Flavor a) {
    final pool = [
      '${d.name} & ${s.name}',
      '${d.mood.label} ${a.name}',
      '${d.name} Esintisi',
      'Yeni Karışım ${i + 1}',
    ];
    return pool[i % pool.length];
  }

  static String _rationale(
      Flavor d, Flavor s, Flavor a, Flavor strongest) {
    return '${d.name} dominantında ${s.mood.label.toLowerCase()} ve '
        '${a.mood.label.toLowerCase()} dokunuş. '
        'En sert: ${strongest.name} (${strongest.strength}/10).';
  }
}
