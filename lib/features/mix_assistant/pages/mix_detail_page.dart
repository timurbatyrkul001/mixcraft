import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/mood_backdrop.dart';
import '../../../shared/data/sample_data.dart';
import '../../../shared/models/community_mix.dart';
import '../../../shared/models/mix.dart';
import '../../../shared/models/mood.dart';
import '../../../shared/providers/inventory_provider.dart';
import '../../../shared/providers/mix_journal_provider.dart';

/// Hem featured (Mix) hem community (CommunityMix) için ortak detay sayfa.
class MixDetailPage extends ConsumerStatefulWidget {
  const MixDetailPage.featured({super.key, required Mix mix})
      : _featured = mix,
        _community = null;

  const MixDetailPage.community({super.key, required CommunityMix mix})
      : _featured = null,
        _community = mix;

  final Mix? _featured;
  final CommunityMix? _community;

  String get _id => _featured?.id ?? _community!.id;
  String get _name => _featured?.name ?? _community!.name;
  String? get _tagline => _featured?.tagline;
  String? get _category => _community?.category;
  Mood get _mood => _featured?.mood ?? _community!.mood;
  String? get _prepNote => _featured?.prepNote;
  int? get _intensity => _featured?.intensity;

  /// Bileşenleri ortak forma çevir: (brand, flavor, ratio, stoktaMı)
  List<_DisplayComponent> _displayComponents({
    required List<dynamic> stockedFlavors,
    required Set<String> stockIds,
  }) {
    if (_featured != null) {
      return _featured.components.map((c) {
        final f = flavorById(c.flavorId);
        final b = f == null ? null : brandById(f.brandId);
        return _DisplayComponent(
          brand: b?.name ?? '?',
          flavor: f?.name ?? c.flavorId,
          ratio: c.ratio,
          inStock: f != null && stockIds.contains(f.id),
        );
      }).toList();
    }
    if (_community != null) {
      return _community.components.map((c) {
        // Stoğa uyum kontrolü
        final brandLower =
            c.brand.toLowerCase().replaceAll(' ', '');
        final flavorLower = c.flavor.toLowerCase();
        var matched = false;
        for (final f in stockedFlavors) {
          final b = brandById(f.brandId);
          if (b == null) continue;
          final fb = b.name.toLowerCase().replaceAll(' ', '');
          final fn = f.name.toLowerCase();
          if ((fb == brandLower ||
                  fb.contains(brandLower) ||
                  brandLower.contains(fb)) &&
              (fn == flavorLower ||
                  fn.contains(flavorLower) ||
                  flavorLower.contains(fn))) {
            matched = true;
            break;
          }
        }
        return _DisplayComponent(
          brand: c.brand,
          flavor: c.flavor,
          ratio: c.ratio,
          inStock: matched,
        );
      }).toList();
    }
    return const [];
  }

  @override
  ConsumerState<MixDetailPage> createState() => _MixDetailPageState();
}

class _DisplayComponent {
  const _DisplayComponent({
    required this.brand,
    required this.flavor,
    required this.ratio,
    required this.inStock,
  });
  final String brand;
  final String flavor;
  final int ratio;
  final bool inStock;
}

class _MixDetailPageState extends ConsumerState<MixDetailPage> {
  final _noteController = TextEditingController();
  bool _noteInitialized = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mood = widget._mood;
    final stockIds = ref.watch(inventoryProvider);
    final allFlavors = kFlavors;

    final components = widget._displayComponents(
      stockedFlavors: allFlavors,
      stockIds: stockIds,
    );

    final journal = ref.watch(mixJournalProvider);
    final entry = journalFor(widget._id, journal);

    // Note field'ı son try'dan başlat (tek seferlik)
    if (!_noteInitialized) {
      final lastTry =
          entry.tries.isEmpty ? null : entry.tries.last;
      if (lastTry?.note != null) {
        _noteController.text = lastTry!.note!;
      }
      _noteInitialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MoodBackdrop(
        mood: mood,
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: MoodGlow(mood: mood, size: 280, opacity: 0.35),
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _Header(
                      isFavorite: entry.isFavorite,
                      onFavorite: () => ref
                          .read(mixJournalProvider.notifier)
                          .toggleFavorite(widget._id),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _HeroSection(
                        name: widget._name,
                        category: widget._category,
                        tagline: widget._tagline,
                        mood: mood,
                        intensity: widget._intensity,
                        tryCount: entry.tryCount,
                        lastTried: entry.lastTried,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _ComponentsSection(
                        components: components,
                        mood: mood,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  if (widget._prepNote != null &&
                      widget._prepNote!.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: _PrepNoteSection(
                            text: widget._prepNote!, mood: mood),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _RatingSection(
                        rating: entry.latestRating ?? 0,
                        mood: mood,
                        onRate: (n) => ref
                            .read(mixJournalProvider.notifier)
                            .rateLastTry(widget._id, n),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _NoteSection(
                        controller: _noteController,
                        mood: mood,
                        onSave: () => ref
                            .read(mixJournalProvider.notifier)
                            .setLastNote(
                                widget._id, _noteController.text),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _TryButton(
                        mood: mood,
                        onTry: () {
                          ref
                              .read(mixJournalProvider.notifier)
                              .addTry(widget._id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: mood.color,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              content: Text(
                                'Denemen kaydedildi',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.background,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isFavorite, required this.onFavorite});
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: AppColors.textPrimary),
          ),
          const Spacer(),
          IconButton(
            onPressed: onFavorite,
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              size: 24,
              color: isFavorite
                  ? const Color(0xFFE85A8C)
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.name,
    required this.category,
    required this.tagline,
    required this.mood,
    required this.intensity,
    required this.tryCount,
    required this.lastTried,
  });

  final String name;
  final String? category;
  final String? tagline;
  final Mood mood;
  final int? intensity;
  final int tryCount;
  final DateTime? lastTried;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: mood.color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: mood.color.withValues(alpha: 0.4), width: 1),
              ),
              child: Text(
                (category ?? mood.label).toUpperCase(),
                style: AppTextStyles.eyebrow.copyWith(
                  color: mood.color,
                  fontSize: 10,
                  letterSpacing: 1.6,
                ),
              ),
            ),
            const Spacer(),
            if (tryCount > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 12, color: Color(0xFF1B7B3D)),
                    const SizedBox(width: 4),
                    Text(
                      tryCount == 1
                          ? '1 kez denedin'
                          : '$tryCount kez denedin',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Text(name, style: AppTextStyles.display.copyWith(fontSize: 32)),
        if (tagline != null && tagline!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(tagline!,
              style: AppTextStyles.body.copyWith(fontSize: 14)),
        ],
        if (intensity != null) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Icon(
                    i < intensity!
                        ? Icons.local_fire_department_rounded
                        : Icons.local_fire_department_outlined,
                    size: 16,
                    color: i < intensity!
                        ? mood.color
                        : AppColors.textTertiary
                            .withValues(alpha: 0.4),
                  ),
                ),
              const SizedBox(width: 8),
              Text('Sertlik', style: AppTextStyles.label),
            ],
          ),
        ],
      ],
    );
  }
}

class _ComponentsSection extends StatelessWidget {
  const _ComponentsSection({
    required this.components,
    required this.mood,
  });
  final List<_DisplayComponent> components;
  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BİLEŞENLER',
            style: AppTextStyles.eyebrow.copyWith(
                color: mood.color, fontSize: 10, letterSpacing: 1.6)),
        const SizedBox(height: 12),
        // Ratio bar
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                for (var i = 0; i < components.length; i++)
                  Expanded(
                    flex: components[i].ratio,
                    child: Container(
                      color: components[i].inStock
                          ? mood.color.withValues(alpha: 1 - (i * 0.15))
                          : AppColors.hairline,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...components.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: c.inStock
                        ? mood.color.withValues(alpha: 0.2)
                        : AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c.inStock
                          ? mood.color
                          : AppColors.hairline,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    c.inStock
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    size: 14,
                    color: c.inStock
                        ? mood.color
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.flavor,
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 14,
                          color: c.inStock
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      Text(c.brand,
                          style: AppTextStyles.label.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
                Text(
                  '%${c.ratio}',
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 15,
                    color:
                        c.inStock ? mood.color : AppColors.textTertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrepNoteSection extends StatelessWidget {
  const _PrepNoteSection({required this.text, required this.mood});
  final String text;
  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_fire_department_outlined,
              size: 18, color: mood.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HAZIRLIK',
                  style: AppTextStyles.eyebrow.copyWith(
                      color: mood.color,
                      fontSize: 9,
                      letterSpacing: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingSection extends StatelessWidget {
  const _RatingSection({
    required this.rating,
    required this.mood,
    required this.onRate,
  });
  final int rating;
  final Mood mood;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PUANIN',
            style: AppTextStyles.eyebrow.copyWith(
                color: mood.color, fontSize: 10, letterSpacing: 1.6)),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              GestureDetector(
                onTap: () => onRate(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.only(right: 6),
                  child: Icon(
                    i <= rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 32,
                    color: i <= rating
                        ? mood.color
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            const Spacer(),
            if (rating > 0)
              Text('$rating / 5',
                  style: AppTextStyles.cardTitle.copyWith(color: mood.color)),
          ],
        ),
      ],
    );
  }
}

class _NoteSection extends StatelessWidget {
  const _NoteSection({
    required this.controller,
    required this.mood,
    required this.onSave,
  });

  final TextEditingController controller;
  final Mood mood;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NOTLARIN',
            style: AppTextStyles.eyebrow.copyWith(
                color: mood.color, fontSize: 10, letterSpacing: 1.6)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.hairline),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: TextField(
            controller: controller,
            maxLines: 3,
            onChanged: (_) => onSave(),
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.5,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  'örn. Çift köz, soğuk su daha iyi. Şubat 18 dene...',
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.textTertiary,
                fontSize: 13,
              ),
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class _TryButton extends StatelessWidget {
  const _TryButton({required this.mood, required this.onTry});
  final Mood mood;
  final VoidCallback onTry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mood.color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: mood.color.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTry,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 22, color: AppColors.background),
                const SizedBox(width: 10),
                Text(
                  'Şimdi Denedim',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.background,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 320.ms).slideY(
            begin: 0.3,
            end: 0,
            duration: 380.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}
