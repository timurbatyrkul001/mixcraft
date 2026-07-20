import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/data/sample_data.dart';
import '../../../shared/models/brand.dart';
import '../../../shared/models/flavor.dart';
import '../../../shared/providers/custom_flavors_provider.dart';
import '../../../shared/providers/inventory_provider.dart';
import '../widgets/add_flavor_sheet.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryIds = ref.watch(inventoryProvider);
    final allFlavors = ref.watch(allFlavorsProvider);

    // Stoktakiler
    final inStock =
        allFlavors.where((f) => inventoryIds.contains(f.id)).toList();

    // Markaya göre grupla
    final byBrand = <String, List<Flavor>>{};
    for (final f in inStock) {
      byBrand.putIfAbsent(f.brandId, () => []).add(f);
    }
    final brandOrder = kBrands
        .where((b) => byBrand.containsKey(b.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(total: inStock.length)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            for (final brand in brandOrder) ...[
              SliverToBoxAdapter(
                child: _BrandSection(
                  brand: brand,
                  flavors: byBrand[brand.id]!,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
            if (inStock.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _Empty(),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _AddButton(
        onTap: () => _openAddSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AddFlavorSheet(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.total});
  final int total;

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
                Text('Tezgahım',
                    style: AppTextStyles.display.copyWith(fontSize: 26)),
                const SizedBox(height: 2),
                Text(
                  '$total aroma stokta',
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

class _BrandSection extends StatelessWidget {
  const _BrandSection({required this.brand, required this.flavors});
  final Brand brand;
  final List<Flavor> flavors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 18,
                decoration: BoxDecoration(
                  color: brand.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(brand.name,
                  style:
                      AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: brand.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${flavors.length}',
                  style: AppTextStyles.label.copyWith(
                    color: brand.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < flavors.length; i++)
                _FlavorChip(flavor: flavors[i])
                    .animate()
                    .fadeIn(delay: (i * 30).ms, duration: 320.ms),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlavorChip extends ConsumerWidget {
  const _FlavorChip({required this.flavor});
  final Flavor flavor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = flavor.mood;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onLongPress: () {
          ref.read(inventoryProvider.notifier).remove(flavor.id);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: mood.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              Text(
                flavor.name,
                style: AppTextStyles.chip.copyWith(fontSize: 13),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: mood.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${flavor.strength}',
                  style: AppTextStyles.label.copyWith(
                    color: mood.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded,
                    size: 20, color: AppColors.background),
                const SizedBox(width: 8),
                Text(
                  'Aroma Ekle',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.background,
                    fontSize: 15,
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

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined,
                size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('Tezgahın boş', style: AppTextStyles.cardTitle),
            const SizedBox(height: 6),
            Text(
              'Aşağıdaki + Aroma Ekle butonundan stoğa aroma ekle.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
