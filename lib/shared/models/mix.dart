import 'mood.dart';

class MixComponent {
  const MixComponent({required this.flavorId, required this.ratio});
  final String flavorId;
  final int ratio; // 0–100
}

class Mix {
  const Mix({
    required this.id,
    required this.name,
    required this.tagline,
    required this.components,
    required this.mood,
    this.prepNote = '',
    this.intensity = 3, // 1-5
    this.isCustom = false,
  });

  final String id;
  final String name;
  final String tagline;
  final List<MixComponent> components;
  final Mood mood;
  final String prepNote;
  final int intensity;
  final bool isCustom;
}
