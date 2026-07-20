import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/data/sample_data.dart';
import '../../../shared/models/brand.dart';
import '../../../shared/models/flavor.dart';
import '../../../shared/providers/inventory_provider.dart';

class BrandDetailPage extends ConsumerWidget {
  const BrandDetailPage({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavors = flavorsByBrand(brand.id);
    final inventory = ref.watch(inventoryProvider);
    final inStockCount = flavors.where((f) => inventory.contains(f.id)).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Marka rengi halo
          Positioned(
            top: -120,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      brand.color.withValues(alpha: 0.35),
                      brand.color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    brand: brand,
                    inStockCount: inStockCount,
                    totalCount: flavors.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final f = flavors[i];
                        final inStock = inventory.contains(f.id);
                        return _FlavorCard(
                          flavor: f,
                          inStock: inStock,
                          onToggle: () =>
                              ref.read(inventoryProvider.notifier).toggle(f.id),
                        )
                            .animate()
                            .fadeIn(delay: (i * 30).ms, duration: 320.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              delay: (i * 30).ms,
                              duration: 360.ms,
                              curve: Curves.easeOutCubic,
                            );
                      },
                      childCount: flavors.length,
                    ),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.brand,
    required this.inStockCount,
    required this.totalCount,
  });

  final Brand brand;
  final int inStockCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: brand.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: brand.color.withValues(alpha: 0.4), width: 1),
                ),
                child: Text(
                  '$inStockCount / $totalCount stokta',
                  style: AppTextStyles.eyebrow.copyWith(
                    color: brand.color,
                    fontSize: 10,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: brand.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: brand.color.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      brand.name[0],
                      style: TextStyle(
                        color: brand.color,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(brand.name, style: AppTextStyles.display),
                      const SizedBox(height: 4),
                      Text(
                        brand.country,
                        style: AppTextStyles.label
                            .copyWith(color: brand.color, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              brand.tagline,
              style: AppTextStyles.body.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlavorCard extends StatelessWidget {
  const _FlavorCard({
    required this.flavor,
    required this.inStock,
    required this.onToggle,
  });

  final Flavor flavor;
  final bool inStock;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final mood = flavor.mood;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: inStock
                  ? mood.color.withValues(alpha: 0.5)
                  : AppColors.hairline,
              width: inStock ? 1.5 : 1,
            ),
            boxShadow: inStock
                ? [
                    BoxShadow(
                      color: mood.color.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: mood.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: mood.color.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: mood.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutBack,
                    scale: inStock ? 1.0 : 0.85,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: inStock
                            ? mood.color
                            : AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: inStock
                              ? mood.color
                              : AppColors.hairline,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        inStock
                            ? Icons.check_rounded
                            : Icons.add_rounded,
                        size: 16,
                        color: inStock
                            ? AppColors.background
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                flavor.name,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                mood.label,
                style: AppTextStyles.label.copyWith(
                  color: mood.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (flavor.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  flavor.description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 11,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              _StrengthBar(strength: flavor.strength, color: mood.color),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.strength, required this.color});
  final int strength;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sertlik',
          style: AppTextStyles.label.copyWith(fontSize: 9, letterSpacing: 0.4),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Row(
            children: List.generate(10, (i) {
              final filled = i < strength;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  decoration: BoxDecoration(
                    color: filled
                        ? color.withValues(alpha: 0.5 + (i * 0.04))
                        : AppColors.hairline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$strength',
          style: AppTextStyles.label.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
