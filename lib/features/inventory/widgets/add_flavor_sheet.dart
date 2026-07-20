import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/data/sample_data.dart';
import '../../../shared/models/brand.dart';
import '../../../shared/models/flavor.dart';
import '../../../shared/models/mood.dart';
import '../../../shared/providers/custom_flavors_provider.dart';
import '../../../shared/providers/inventory_provider.dart';

class AddFlavorSheet extends ConsumerStatefulWidget {
  const AddFlavorSheet({super.key});

  @override
  ConsumerState<AddFlavorSheet> createState() => _AddFlavorSheetState();
}

class _AddFlavorSheetState extends ConsumerState<AddFlavorSheet> {
  Brand? _selectedBrand;
  final _nameController = TextEditingController();
  Mood _selectedMood = Mood.fruity;
  double _strength = 5;
  final Set<String> _selectedTags = {};

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
    'meyve',
    'menthol',
    'ferah',
  ];

  bool get _isValid =>
      _selectedBrand != null && _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;
    final brand = _selectedBrand!;
    final name = _nameController.text.trim();
    final id = 'custom-${brand.id}-${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}-${DateTime.now().millisecondsSinceEpoch}';

    final flavor = Flavor(
      id: id,
      brandId: brand.id,
      name: name,
      mood: _selectedMood,
      strength: _strength.round(),
      tags: _selectedTags.toList(),
      description: '',
    );

    ref.read(customFlavorsProvider.notifier).add(flavor);
    ref.read(inventoryProvider.notifier).add(id);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        content: Text(
          '${brand.name} · $name stoğa eklendi',
          style: AppTextStyles.body
              .copyWith(color: AppColors.background, fontSize: 13),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Yeni Aroma',
                style: AppTextStyles.display.copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              'Markayı seç, aroma adını yaz.',
              style: AppTextStyles.body.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 22),

            // MARKA
            Text('MARKA', style: AppTextStyles.eyebrow.copyWith(fontSize: 10)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final b in kBrands)
                  _BrandChip(
                    brand: b,
                    selected: _selectedBrand?.id == b.id,
                    onTap: () => setState(() => _selectedBrand = b),
                  ),
              ],
            ),
            const SizedBox(height: 22),

            // AROMA ADI
            Text('AROMA ADI',
                style: AppTextStyles.eyebrow.copyWith(fontSize: 10)),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'örn. Peach Yogurt',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: AppColors.hairline, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: _selectedMood.color, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // KARAKTER (Mood)
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
                    onTap: () => setState(() => _selectedMood = m),
                  ),
              ],
            ),
            const SizedBox(height: 22),

            // SERTLİK
            Row(
              children: [
                Text('SERTLİK',
                    style:
                        AppTextStyles.eyebrow.copyWith(fontSize: 10)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _selectedMood.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${_strength.round()}/10',
                    style: AppTextStyles.chip.copyWith(
                      color: _selectedMood.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _selectedMood.color,
                inactiveTrackColor: AppColors.hairline,
                thumbColor: _selectedMood.color,
                trackHeight: 4,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 9),
              ),
              child: Slider(
                value: _strength,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) => setState(() => _strength = v),
              ),
            ),
            const SizedBox(height: 16),

            // TAG'ler
            Text('TAT KATEGORİLERİ',
                style: AppTextStyles.eyebrow.copyWith(fontSize: 10)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in _tagOptions)
                  _TagChip(
                    label: t,
                    selected: _selectedTags.contains(t),
                    onTap: () => setState(() {
                      if (_selectedTags.contains(t)) {
                        _selectedTags.remove(t);
                      } else {
                        _selectedTags.add(t);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 26),

            // Submit
            _SubmitButton(
              enabled: _isValid,
              color: _selectedMood.color,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  const _BrandChip({
    required this.brand,
    required this.selected,
    required this.onTap,
  });

  final Brand brand;
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
          color: selected ? brand.color : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected
                ? brand.color
                : AppColors.hairline,
            width: 1,
          ),
        ),
        child: Text(
          brand.name,
          style: AppTextStyles.chip.copyWith(
            color: selected ? AppColors.background : AppColors.textPrimary,
            fontSize: 13,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? mood.color : AppColors.surfaceElevated,
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
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: selected ? AppColors.background : mood.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              mood.label,
              style: AppTextStyles.chip.copyWith(
                color: selected ? AppColors.background : AppColors.textPrimary,
                fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.textPrimary : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color:
                selected ? AppColors.textPrimary : AppColors.hairline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.chip.copyWith(
            color:
                selected ? AppColors.background : AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: enabled ? color : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(100),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: enabled
                        ? AppColors.background
                        : AppColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Stoğa Ekle',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: enabled
                          ? AppColors.background
                          : AppColors.textTertiary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
