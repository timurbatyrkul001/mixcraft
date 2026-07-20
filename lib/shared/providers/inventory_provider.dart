import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_data.dart';

/// Kullanıcının elinde olan aroma ID'lerinin kümesi.
/// "Bu 2 haftalık stoğum" gibi düşün.
/// Şimdilik in-memory. Sonra Hive ile kalıcı yapılır.
class InventoryNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return Set<String>.from(kCurrentStockIds);
  }

  void toggle(String flavorId) {
    final next = Set<String>.from(state);
    if (next.contains(flavorId)) {
      next.remove(flavorId);
    } else {
      next.add(flavorId);
    }
    state = next;
  }

  void add(String flavorId) {
    if (!state.contains(flavorId)) {
      state = {...state, flavorId};
    }
  }

  void remove(String flavorId) {
    if (state.contains(flavorId)) {
      state = Set<String>.from(state)..remove(flavorId);
    }
  }

  void clear() => state = <String>{};

  bool contains(String flavorId) => state.contains(flavorId);
}

final inventoryProvider =
    NotifierProvider<InventoryNotifier, Set<String>>(InventoryNotifier.new);

/// Bir mix'in tüm aromaları stokta mı?
bool mixIsInStock(Iterable<String> flavorIds, Set<String> inventory) {
  for (final id in flavorIds) {
    if (!inventory.contains(id)) return false;
  }
  return true;
}
