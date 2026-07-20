import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/mood_backdrop.dart';
import '../../../shared/data/sample_data.dart';
import '../../../shared/models/brand.dart';
import '../../../shared/models/mix.dart';
import '../../../shared/models/mood.dart';
import '../../brand/pages/brand_detail_page.dart';
import '../../inventory/pages/inventory_page.dart';
import '../../mix_assistant/pages/community_mixes_page.dart';
import '../../mix_assistant/pages/mix_assistant_page.dart';
import '../../mix_assistant/pages/mix_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _featuredController = PageController(viewportFraction: 0.85);
  int _featuredIndex = 0;

  Mood get _currentMood => kFeaturedMixes[_featuredIndex].mood;

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MoodBackdrop(
        mood: _currentMood,
        child: Stack(
          children: [
            // Glow halo (mood vurgu)
            Positioned(
              top: -60,
              right: -40,
              child: MoodGlow(mood: _currentMood, size: 320, opacity: 0.35),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: MoodGlow(mood: _currentMood, size: 280, opacity: 0.25),
            ),
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
                children: [
                  const _Header(),
                  const SizedBox(height: 28),
                  _SectionLabel(text: 'BUGÜNÜN KARIŞIMI', accent: _currentMood.color),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 320,
                    child: PageView.builder(
                      controller: _featuredController,
                      itemCount: kFeaturedMixes.length,
                      onPageChanged: (i) =>
                          setState(() => _featuredIndex = i),
                      itemBuilder: (context, i) {
                        final mix = kFeaturedMixes[i];
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 320),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: i == _featuredIndex ? 0 : 12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MixDetailPage.featured(mix: mix),
                                ),
                              );
                            },
                            child: _FeaturedMixCard(mix: mix),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _DotsIndicator(
                      count: kFeaturedMixes.length,
                      index: _featuredIndex,
                      accent: _currentMood.color,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _AssistantCTA(accent: _currentMood.color),
                            ),
                            const SizedBox(width: 10),
                            _InventoryCTA(accent: _currentMood.color),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _CommunityCTA(accent: _currentMood.color),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SectionLabel(
                      text: 'MARKALAR',
                      accent: _currentMood.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: kBrands.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        return _BrandTile(brand: kBrands[i])
                            .animate()
                            .fadeIn(delay: (i * 60).ms, duration: 380.ms)
                            .slideX(
                              begin: 0.2,
                              end: 0,
                              delay: (i * 60).ms,
                              duration: 440.ms,
                              curve: Curves.easeOutCubic,
                            );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SectionLabel(
                      text: 'TÜM KARIŞIMLAR',
                      accent: _currentMood.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: kFeaturedMixes
                          .map((m) => _MixChip(mix: m))
                          .toList(),
                    ),
                  ),
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
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MixCraft',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
                Text(
                  'Senin nargile atölyen',
                  style: AppTextStyles.label.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          _CircleIcon(icon: Icons.search_rounded, onTap: () {}),
          const SizedBox(width: 8),
          _CircleIcon(icon: Icons.favorite_outline_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.08), width: 1),
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.accent});
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(width: 16, height: 1.5, color: accent),
          const SizedBox(width: 10),
          Text(text, style: AppTextStyles.eyebrow.copyWith(color: accent)),
        ],
      ),
    );
  }
}

class _FeaturedMixCard extends StatelessWidget {
  const _FeaturedMixCard({required this.mix});
  final Mix mix;

  @override
  Widget build(BuildContext context) {
    final mood = mix.mood;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mood.color.withValues(alpha: 0.35),
            AppColors.surface,
            mood.gradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: mood.color.withValues(alpha: 0.18),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(
          color: mood.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
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
                      color: mood.color.withValues(alpha: 0.4), width: 1),
                ),
                child: Text(
                  mood.label.toUpperCase(),
                  style: AppTextStyles.eyebrow.copyWith(
                    color: mood.color,
                    fontSize: 10,
                    letterSpacing: 1.6,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < mix.intensity;
                  return Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(
                      filled
                          ? Icons.local_fire_department_rounded
                          : Icons.local_fire_department_outlined,
                      size: 12,
                      color: filled
                          ? mood.color
                          : AppColors.textTertiary
                              .withValues(alpha: 0.4),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            mix.name,
            style: AppTextStyles.display.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 6),
          Text(mix.tagline, style: AppTextStyles.body),
          const Spacer(),
          // İçindekiler (oran çubuğu)
          _RatioBar(components: mix.components, accent: mood.color),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final c in mix.components) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: mood.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                        style: AppTextStyles.label
                            .copyWith(color: mood.color, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ],
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

class _RatioBar extends StatelessWidget {
  const _RatioBar({required this.components, required this.accent});
  final List<MixComponent> components;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            for (var i = 0; i < components.length; i++)
              Expanded(
                flex: components[i].ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 1 - (i * 0.2)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CommunityCTA extends StatelessWidget {
  const _CommunityCTA({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CommunityMixesPage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: accent.withValues(alpha: 0.4), width: 1),
                ),
                child: Icon(Icons.groups_rounded,
                    size: 22, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Topluluk Mixleri',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(
                      'ivankalyanshop.ru\'dan stoğuna uyan tarifler.',
                      style:
                          AppTextStyles.body.copyWith(fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryCTA extends StatelessWidget {
  const _InventoryCTA({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const InventoryPage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.hairline,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    size: 22, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Text('Tezgah',
                  style:
                      AppTextStyles.cardTitle.copyWith(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantCTA extends StatelessWidget {
  const _AssistantCTA({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MixAssistantPage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.18),
                accent.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accent.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: accent.withValues(alpha: 0.5), width: 1),
                ),
                child: Icon(Icons.auto_awesome_rounded,
                    size: 24, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bana Özel Mix',
                        style:
                            AppTextStyles.cardTitle.copyWith(fontSize: 17)),
                    const SizedBox(height: 2),
                    Text(
                      'Sertlik + karakter + tat kategorisi seç → stoğundan öneri.',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded,
                  color: accent, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.count,
    required this.index,
    required this.accent,
  });
  final int count;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active
                ? accent
                : AppColors.textTertiary.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({required this.brand});
  final Brand brand;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BrandDetailPage(brand: brand),
            ),
          );
        },
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: brand.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: brand.color.withValues(alpha: 0.4), width: 1),
                ),
                child: Center(
                  child: Text(
                    brand.name[0],
                    style: TextStyle(
                      color: brand.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${flavorsByBrand(brand.id).length}',
                style: AppTextStyles.label,
              ),
            ],
          ),
          const Spacer(),
          Text(brand.name,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(
            brand.country,
            style: AppTextStyles.label.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MixChip extends StatelessWidget {
  const _MixChip({required this.mix});
  final Mix mix;

  @override
  Widget build(BuildContext context) {
    final mood = mix.mood;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: mood.color.withValues(alpha: 0.3), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: mood.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(mix.name,
              style: AppTextStyles.chip.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
              )),
        ],
      ),
    );
  }
}
