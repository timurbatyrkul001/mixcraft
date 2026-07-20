import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_data.dart';
import '../models/flavor.dart';

/// Kullanıcının manuel eklediği custom aromalar.
/// Catalog (kFlavors) const ve değiştirilemez; bu provider runtime ekler.
class CustomFlavorsNotifier extends Notifier<List<Flavor>> {
  @override
  List<Flavor> build() => const [];

  void add(Flavor f) {
    state = [...state, f];
  }

  void remove(String id) {
    state = state.where((f) => f.id != id).toList();
  }
}

final customFlavorsProvider =
    NotifierProvider<CustomFlavorsNotifier, List<Flavor>>(
        CustomFlavorsNotifier.new);

/// Catalog + custom birleşimi
final allFlavorsProvider = Provider<List<Flavor>>((ref) {
  final custom = ref.watch(customFlavorsProvider);
  return [...kFlavors, ...custom];
});

/// ID ile arama — hem catalog hem custom'dan
Flavor? lookupFlavor(String id, List<Flavor> allFlavors) {
  for (final f in allFlavors) {
    if (f.id == id) return f;
  }
  return null;
}
