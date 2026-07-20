import '../../shared/data/sample_data.dart';
import '../../shared/models/community_mix.dart';
import '../../shared/models/flavor.dart';

/// Topluluk mixlerini kullanıcı stoğuna göre eşleştirip puanlar.
class CommunityEngine {
  /// Bir CommunityComponent (marka + aroma adı) stoktaki aromalarla eşleşiyor mu?
  static Flavor? findStockedFlavor({
    required CommunityComponent component,
    required List<Flavor> allFlavors,
    required Set<String> stockIds,
  }) {
    final brandLower = component.brand.toLowerCase().replaceAll(' ', '');
    final flavorLower = component.flavor.toLowerCase();

    for (final f in allFlavors) {
      if (!stockIds.contains(f.id)) continue;
      final b = brandById(f.brandId);
      if (b == null) continue;

      final fBrandLower = b.name.toLowerCase().replaceAll(' ', '');
      final fNameLower = f.name.toLowerCase();

      // Marka eşleşmesi (fuzzy)
      final brandMatches = fBrandLower == brandLower ||
          fBrandLower.contains(brandLower) ||
          brandLower.contains(fBrandLower);
      if (!brandMatches) continue;

      // Aroma adı eşleşmesi (fuzzy substring)
      final nameMatches = fNameLower == flavorLower ||
          fNameLower.contains(flavorLower) ||
          flavorLower.contains(fNameLower);
      if (nameMatches) return f;
    }
    return null;
  }

  /// Mix'in stoğa uyumunu hesapla — yüzdeleri toplayarak.
  static MixMatch match({
    required CommunityMix mix,
    required List<Flavor> allFlavors,
    required Set<String> stockIds,
  }) {
    final matched = <CommunityComponent>[];
    final missing = <CommunityComponent>[];
    var coverage = 0;

    for (final c in mix.components) {
      final found = findStockedFlavor(
        component: c,
        allFlavors: allFlavors,
        stockIds: stockIds,
      );
      if (found != null) {
        matched.add(c);
        coverage += c.ratio;
      } else {
        missing.add(c);
      }
    }

    return MixMatch(
      mix: mix,
      coveragePercent: coverage.clamp(0, 100),
      matchedComponents: matched,
      missingComponents: missing,
    );
  }

  /// Tüm topluluk mixlerini stoğa göre sırala — en yüksek uyumdan başla.
  static List<MixMatch> rankByStock({
    required List<CommunityMix> mixes,
    required List<Flavor> allFlavors,
    required Set<String> stockIds,
  }) {
    final matches = mixes
        .map((m) => match(
              mix: m,
              allFlavors: allFlavors,
              stockIds: stockIds,
            ))
        .toList()
      ..sort((a, b) => b.coveragePercent.compareTo(a.coveragePercent));
    return matches;
  }
}
