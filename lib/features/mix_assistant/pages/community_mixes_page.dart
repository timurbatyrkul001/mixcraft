import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/mood_backdrop.dart';
import '../../../shared/data/community_mixes.dart';
import '../../../shared/models/community_mix.dart';
import '../../../shared/providers/custom_flavors_provider.dart';
import '../../../shared/providers/inventory_provider.dart';
import '../community_engine.dart';
import 'mix_detail_page.dart';

class CommunityMixesPage extends ConsumerStatefulWidget {
  const CommunityMixesPage({super.key});

  @override
  ConsumerState<CommunityMixesPage> createState() =>
      _CommunityMixesPageState();
}

class _CommunityMixesPageState extends ConsumerState<CommunityMixesPage> {
  String _filter = 'all'; // all | complete | mostly | any

  @override
  Widget build(BuildContext context) {
    final stockIds = ref.watch(inventoryProvider);
    final allFlavors = ref.watch(allFlavorsProvider);

    final allRanked = CommunityEngine.rankByStock(
      mixes: kCommunityMixes,
      allFlavors: allFlavors,
      stockIds: stockIds,
    );

    final results = switch (_filter) {
      'complete' => allRanked.where((m) => m.isComplete).toList(),
      'mostly' => allRanked.where((m) => m.isMostlyComplete).toList(),
      'any' => allRanked.where((m) => m.coveragePercent > 0).toList(),
      _ => allRanked,
    };

    final completeCount = allRanked.where((m) => m.isComplete).length;
    final mostlyCount =
        allRanked.where((m) => m.isMostlyComplete && !m.isComplete).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MoodBackdrop(
        mood: results.isNotEmpty ? results.first.mix.mood : kCommunityMixes.first.mood,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: _StatsBar(
                  total: allRanked.length,
                  complete: completeCount,
                  mostly: mostlyCount,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(
                child: _FilterBar(
                  current: _filter,
                  onChange: (v) => setState(() => _filter = v),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CommunityMixCard(match: results[i])
                          .animate()
                          .fadeIn(delay: (i * 30).ms, duration: 320.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            delay: (i * 30).ms,
                            duration: 360.ms,
                            curve: Curves.easeOutCubic,
                          ),
                    ),
                    childCount: results.length,
                  ),
                ),
              ),
              if (results.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _Empty(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Topluluk Mixleri',
                    style: AppTextStyles.display.copyWith(fontSize: 24)),
                const SizedBox(height: 2),
                Text(
                  'ivankalyanshop.ru kütüphanesinden',
                  style: AppTextStyles.label.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({
    required this.total,
    required this.complete,
    required this.mostly,
  });
  final int total;
  final int complete;
  final int mostly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _StatPill(
            label: 'YAPABİLİRSİN',
            value: '$complete',
            color: const Color(0xFF1B7B3D),
          ),
          const SizedBox(width: 10),
          _StatPill(
            label: 'NEREDEYSE',
            value: '$mostly',
            color: const Color(0xFFE9B040),
          ),
          const SizedBox(width: 10),
          _StatPill(
            label: 'TOPLAM',
            value: '$total',
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: AppTextStyles.display.copyWith(
                  color: color,
                  fontSize: 22,
                )),
            const SizedBox(height: 2),
            Text(label,
                style: AppTextStyles.eyebrow.copyWith(
                  color: color,
                  fontSize: 9,
                  letterSpacing: 1.2,
                )),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.current, required this.onChange});
  final String current;
  final ValueChanged<String> onChange;

  static const _opts = [
    ('complete', 'Yapabildiklerim'),
    ('mostly', 'Neredeyse'),
    ('any', 'Yakın'),
    ('all', 'Tümü'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _opts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (id, label) = _opts[i];
          final active = current == id;
          return GestureDetector(
            onTap: () => onChange(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: active ? AppColors.textPrimary : AppColors.hairline,
                ),
              ),
              child: Text(
                label,
                style: AppTextStyles.chip.copyWith(
                  color: active ? AppColors.background : AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CommunityMixCard extends StatelessWidget {
  const _CommunityMixCard({required this.match});
  final MixMatch match;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MixDetailPage.community(mix: match.mix),
            ),
          );
        },
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final mood = match.mix.mood;
    final coverColor = match.isComplete
        ? const Color(0xFF1B7B3D)
        : match.isMostlyComplete
            ? const Color(0xFFE9B040)
            : AppColors.textTertiary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: match.isComplete
              ? coverColor.withValues(alpha: 0.5)
              : AppColors.hairline,
          width: match.isComplete ? 1.5 : 1,
        ),
        boxShadow: match.isComplete
            ? [
                BoxShadow(
                  color: coverColor.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: mood.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  match.mix.category.toUpperCase(),
                  style: AppTextStyles.eyebrow.copyWith(
                    color: mood.color,
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: coverColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Icon(
                      match.isComplete
                          ? Icons.check_circle_rounded
                          : Icons.percent_rounded,
                      size: 12,
                      color: coverColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${match.coveragePercent}%',
                      style: AppTextStyles.chip.copyWith(
                        color: coverColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(match.mix.name,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
          const SizedBox(height: 10),
          // Stoktaki bileşenler
          ...match.matchedComponents.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_rounded,
                        size: 14, color: const Color(0xFF1B7B3D)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${c.brand} · ${c.flavor}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      '%${c.ratio}',
                      style: AppTextStyles.label.copyWith(
                        color: const Color(0xFF1B7B3D),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )),
          // Eksik bileşenler
          if (match.missingComponents.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EKSİK',
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...match.missingComponents.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Icon(Icons.close_rounded,
                                size: 13,
                                color: AppColors.textTertiary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${c.brand} · ${c.flavor}',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              '%${c.ratio}',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('Bu filtreye uygun mix yok',
                style: AppTextStyles.cardTitle),
            const SizedBox(height: 6),
            Text(
              'Filtreyi gevşet veya tezgaha aroma ekle.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
