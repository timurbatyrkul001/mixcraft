import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/mood_backdrop.dart';
import '../../../shared/data/sample_data.dart';
import '../../../shared/models/mood.dart';
import '../../../shared/providers/inventory_provider.dart';
import '../mix_engine.dart';

class MixAssistantPage extends ConsumerStatefulWidget {
  const MixAssistantPage({super.key});

  @override
  ConsumerState<MixAssistantPage> createState() => _MixAssistantPageState();
}

class _MixAssistantPageState extends ConsumerState<MixAssistantPage> {
  Mood? _selectedMood;
  double _strength = 5;
  final Set<String> _selectedTags = {};
  List<MixSuggestion> _results = [];
  bool _hasGenerated = false;

  static const _tagOptions = [
    'pastane',
    'orman-meyveli',
    'turunçgil',
    'tropik',
    'krema',
    'baharat',
    'şekerleme',
    'çikolata',
    'taze',
    'kahve',
  ];

  void _generate() {
    final inventoryIds = ref.read(inventoryProvider);
    final available = kFlavors
        .where((f) => inventoryIds.contains(f.id))
        .toList();

    final results = MixEngine.suggest(
      available: available,
      targetMood: _selectedMood,
      targetStrength: _strength.round(),
      requiredTags: _selectedTags,
      count: 3,
    );

    setState(() {
      _results = results;
      _hasGenerated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMood = _results.isNotEmpty
        ? _results.first.dominantMood
        : _selectedMood ?? Mood.fruity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MoodBackdrop(
        mood: currentMood,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _buildFilters(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
              if (_hasGenerated) ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      '${_results.length} alternatif',
                      style: AppTextStyles.eyebrow.copyWith(
                        color: currentMood.color,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _SuggestionCard(suggestion: _results[i])
                            .animate()
                            .fadeIn(
                              delay: (i * 80).ms,
                              duration: 380.ms,
                            )
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              delay: (i * 80).ms,
                              duration: 420.ms,
                              curve: Curves.easeOutCubic,
                            ),
                      ),
                      childCount: _results.length,
                    ),
                  ),
                ),
                if (_results.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(40),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.science_outlined,
                                size: 48,
                                color: AppColors.textTertiary),
                            const SizedBox(height: 12),
                            Text('Filtrelere uyan kombinasyon yok',
                                style: AppTextStyles.cardTitle),
                            const SizedBox(height: 6),
                            Text(
                              'Tag\'leri gevşet ya da sertliği değiştir.',
                              style: AppTextStyles.body,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ] else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.auto_awesome_rounded,
                              size: 56, color: currentMood.color),
                          const SizedBox(height: 16),
                          Text('Kriterlerini seç,\nstoğundan mix öneriyorum',
                              style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 6),
                          Text(
                            'Sertlik, mood ve karakter etiketlerine göre 3 farklı kombinasyon.',
                            style: AppTextStyles.body.copyWith(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: _generateButton(currentMood),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                Text('Mix Asistanı', style: AppTextStyles.display.copyWith(fontSize: 26)),
                const SizedBox(height: 2),
                Text(
                  'Stoğundan akıllı kombinasyon',
                  style: AppTextStyles.label.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mood seçimi
        Text('KARAKTER',
            style: AppTextStyles.eyebrow.copyWith(fontSize: 10)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final m in Mood.values)
              _MoodChip(
                mood: m,
                selected: _selectedMood == m,
                onTap: () => setState(() {
                  _selectedMood = _selectedMood == m ? null : m;
                }),
              ),
          ],
        ),
        const SizedBox(height: 24),

        // Sertlik slider
        Row(
          children: [
            Text('SERTLİK',
                style: AppTextStyles.eyebrow.copyWith(fontSize: 10)),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Text(
                _strength.round().toString(),
                style: AppTextStyles.chip
                    .copyWith(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.textPrimary,
            inactiveTrackColor: AppColors.hairline,
            thumbColor: AppColors.textPrimary,
            overlayColor: AppColors.textPrimary.withValues(alpha: 0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          ),
          child: Slider(
            value: _strength,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) => setState(() => _strength = v),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hafif (1)',
                style: AppTextStyles.label.copyWith(fontSize: 10)),
            Text('Sert (10)',
                style: AppTextStyles.label.copyWith(fontSize: 10)),
          ],
        ),
        const SizedBox(height: 24),

        // Tag chips
        Text('TAT KATEGORİSİ',
            style: AppTextStyles.eyebrow.copyWith(fontSize: 10)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in _tagOptions)
              _TagChip(
                label: tag,
                selected: _selectedTags.contains(tag),
                onTap: () => setState(() {
                  if (_selectedTags.contains(tag)) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                }),
              ),
          ],
        ),
      ],
    );
  }

  Widget _generateButton(Mood currentMood) {
    return Container(
      decoration: BoxDecoration(
        color: currentMood.color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: currentMood.color.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _generate,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _hasGenerated
                      ? Icons.refresh_rounded
                      : Icons.auto_awesome_rounded,
                  color: AppColors.background,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  _hasGenerated ? 'Yeniden Öner' : 'Mix Öner',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.background,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final Mood mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? mood.color : AppColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? mood.color : AppColors.hairline,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected ? AppColors.background : mood.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              mood.label,
              style: AppTextStyles.chip.copyWith(
                color: selected ? AppColors.background : AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? AppColors.textPrimary : AppColors.hairline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.chip.copyWith(
            color: selected ? AppColors.background : AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.suggestion});

  final MixSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final mood = suggestion.dominantMood;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mood.color.withValues(alpha: 0.18),
            AppColors.surface,
          ],
        ),
        border: Border.all(
          color: mood.color.withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: mood.color.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
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
                      color: mood.color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  mood.label.toUpperCase(),
                  style: AppTextStyles.eyebrow.copyWith(
                    color: mood.color,
                    fontSize: 10,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.local_fire_department_rounded,
                      size: 14, color: mood.color),
                  const SizedBox(width: 4),
                  Text(
                    '${suggestion.averageStrength}/10',
                    style: AppTextStyles.chip.copyWith(
                      color: mood.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(suggestion.title,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 6),
          Text(suggestion.rationale,
              style: AppTextStyles.body.copyWith(fontSize: 12, height: 1.4)),
          const SizedBox(height: 14),
          for (final c in suggestion.components)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: mood.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _flavorLabel(c.flavorId),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '%${c.ratio}',
                    style: AppTextStyles.label.copyWith(
                      color: mood.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _flavorLabel(String id) {
    final f = flavorById(id);
    final b = f == null ? null : brandById(f.brandId);
    if (f == null || b == null) return id;
    return '${b.name} · ${f.name}';
  }
}
