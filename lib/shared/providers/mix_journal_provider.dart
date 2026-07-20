import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bir mix denemesi (try) kaydı
class TryRecord {
  const TryRecord({
    required this.timestamp,
    this.rating,
    this.note,
  });

  final DateTime timestamp;
  final int? rating; // 1-5
  final String? note;
}

/// Bir mix'in tüm günlük kayıtları
class MixJournal {
  const MixJournal({
    this.isFavorite = false,
    this.tries = const [],
  });

  final bool isFavorite;
  final List<TryRecord> tries;

  int get tryCount => tries.length;
  DateTime? get lastTried =>
      tries.isEmpty ? null : tries.last.timestamp;
  int? get latestRating {
    for (final t in tries.reversed) {
      if (t.rating != null) return t.rating;
    }
    return null;
  }

  MixJournal copyWith({bool? isFavorite, List<TryRecord>? tries}) =>
      MixJournal(
        isFavorite: isFavorite ?? this.isFavorite,
        tries: tries ?? this.tries,
      );
}

/// mixId → MixJournal
class MixJournalNotifier extends Notifier<Map<String, MixJournal>> {
  @override
  Map<String, MixJournal> build() => {};

  void toggleFavorite(String mixId) {
    final current = state[mixId] ?? const MixJournal();
    state = {
      ...state,
      mixId: current.copyWith(isFavorite: !current.isFavorite),
    };
  }

  void addTry(String mixId, {int? rating, String? note}) {
    final current = state[mixId] ?? const MixJournal();
    final record = TryRecord(
      timestamp: DateTime.now(),
      rating: rating,
      note: note,
    );
    state = {
      ...state,
      mixId: current.copyWith(tries: [...current.tries, record]),
    };
  }

  void rateLastTry(String mixId, int rating) {
    final current = state[mixId];
    if (current == null || current.tries.isEmpty) {
      addTry(mixId, rating: rating);
      return;
    }
    final updated = [...current.tries];
    final last = updated.last;
    updated[updated.length - 1] = TryRecord(
      timestamp: last.timestamp,
      rating: rating,
      note: last.note,
    );
    state = {...state, mixId: current.copyWith(tries: updated)};
  }

  void setLastNote(String mixId, String note) {
    final current = state[mixId];
    if (current == null || current.tries.isEmpty) {
      addTry(mixId, note: note);
      return;
    }
    final updated = [...current.tries];
    final last = updated.last;
    updated[updated.length - 1] = TryRecord(
      timestamp: last.timestamp,
      rating: last.rating,
      note: note,
    );
    state = {...state, mixId: current.copyWith(tries: updated)};
  }
}

final mixJournalProvider =
    NotifierProvider<MixJournalNotifier, Map<String, MixJournal>>(
        MixJournalNotifier.new);

/// Tek bir mix için journal al (yoksa default boş)
MixJournal journalFor(String mixId, Map<String, MixJournal> journal) =>
    journal[mixId] ?? const MixJournal();

/// Favori mix ID'leri
final favoriteMixIdsProvider = Provider<Set<String>>((ref) {
  final journal = ref.watch(mixJournalProvider);
  return journal.entries
      .where((e) => e.value.isFavorite)
      .map((e) => e.key)
      .toSet();
});

/// Denenmiş mix ID'leri
final triedMixIdsProvider = Provider<Set<String>>((ref) {
  final journal = ref.watch(mixJournalProvider);
  return journal.entries
      .where((e) => e.value.tryCount > 0)
      .map((e) => e.key)
      .toSet();
});
