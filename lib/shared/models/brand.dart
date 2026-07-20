import 'package:flutter/material.dart';

class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.country,
    required this.tagline,
    required this.color,
  });

  final String id;
  final String name;
  final String country;
  final String tagline;
  final Color color; // marka rengi (kart vurgusu için)
}
