import 'package:flutter/material.dart';

import '../models/brand.dart';
import '../models/flavor.dart';
import '../models/mix.dart';
import '../models/mood.dart';

const kBrands = <Brand>[
  Brand(
    id: 'musthave',
    name: 'MustHave',
    country: 'Russia',
    tagline: 'Parlak meyveler, dengeli karakter. Orta sertlik (4-5).',
    color: Color(0xFFE9B040),
  ),
  Brand(
    id: 'darkside',
    name: 'Darkside',
    country: 'Russia',
    tagline: 'Yoğun karakter, kalın duman. Sert (7-8).',
    color: Color(0xFF6E5640),
  ),
  Brand(
    id: 'black-burn',
    name: 'Black Burn',
    country: 'Russia',
    tagline: 'Uzun ömürlü, yoğun aromalar. Orta-sert (6-7).',
    color: Color(0xFF8E2D4D),
  ),
  Brand(
    id: 'bonche',
    name: 'Bonche',
    country: 'Russia',
    tagline: 'Premium sigara yaprağı. Orta-sert (6-7).',
    color: Color(0xFFC79256),
  ),
  Brand(
    id: 'trofimoff',
    name: 'Trofimoff\'s',
    country: 'Russia',
    tagline: 'El yapımı fermente, küçük partiler. Orta-sert (6-7).',
    color: Color(0xFF5A6B7A),
  ),
  Brand(
    id: 'starline',
    name: 'Starline',
    country: 'Russia',
    tagline: 'Hafif Virginia Gold, klasik. Hafif (3-4).',
    color: Color(0xFF6B7AB8),
  ),
];

const kFlavors = <Flavor>[
  // ─── MUSTHAVE — bu hafta gelen 12 aroma ──────────
  Flavor(
      id: 'mh-black-currant',
      brandId: 'musthave',
      name: 'Black Currant',
      mood: Mood.berry,
      strength: 5,
      tags: ['orman-meyveli', 'frenk-uzumu', 'ekşi'],
      description: 'Frenk üzümü, ekşi-tatlı orman karakteri.'),
  Flavor(
      id: 'mh-cranberry',
      brandId: 'musthave',
      name: 'Cranberry',
      mood: Mood.berry,
      strength: 4,
      tags: ['orman-meyveli', 'ekşi', 'taze'],
      description: 'Yaban mersini, ekşi ve uyarıcı.'),
  Flavor(
      id: 'mh-grapefruit',
      brandId: 'musthave',
      name: 'Grapefruit',
      mood: Mood.fruity,
      strength: 4,
      tags: ['turunçgil', 'ekşi', 'taze'],
      description: 'Pembe greyfurt, hafif acılı turunçgil.'),
  Flavor(
      id: 'mh-lemon-lime',
      brandId: 'musthave',
      name: 'Lemon Lime',
      mood: Mood.fruity,
      strength: 3,
      tags: ['turunçgil', 'ferah', 'asit'],
      description: 'Limon + misket limonu, ferahlatıcı asitlik.'),
  Flavor(
      id: 'mh-mad-pear',
      brandId: 'musthave',
      name: 'Mad Pear',
      mood: Mood.fruity,
      strength: 3,
      tags: ['meyve', 'armut', 'taze'],
      description: 'Olgun armut, hafif tatlı taze.'),
  Flavor(
      id: 'mh-mango-sling',
      brandId: 'musthave',
      name: 'Mango Sling',
      mood: Mood.fruity,
      strength: 4,
      tags: ['tropik', 'mango', 'kokteyl'],
      description: 'Mango kokteyli, tropik yumuşaklık.'),
  Flavor(
      id: 'mh-orange-team',
      brandId: 'musthave',
      name: 'Orange Team',
      mood: Mood.fruity,
      strength: 4,
      tags: ['turunçgil', 'portakal', 'tatlı'],
      description: 'Portakal karışımı, tatlı turunçgil.'),
  Flavor(
      id: 'mh-pineapple-rings',
      brandId: 'musthave',
      name: 'Pineapple Rings',
      mood: Mood.fruity,
      strength: 4,
      tags: ['tropik', 'ananas', 'karamelize'],
      description: 'Karamelize ananas halkaları, tatlı tropik.'),
  Flavor(
      id: 'mh-raspberry',
      brandId: 'musthave',
      name: 'Raspberry',
      mood: Mood.berry,
      strength: 4,
      tags: ['orman-meyveli', 'ahududu', 'tatlı'],
      description: 'Olgun ahududu, tatlı kırmızı berry.'),
  Flavor(
      id: 'mh-rocketman',
      brandId: 'musthave',
      name: 'Rocketman',
      mood: Mood.fruity,
      strength: 5,
      tags: ['tropik', 'karışık', 'yoğun'],
      description: 'Roket tropik kombinasyonu, yoğun meyve.'),
  Flavor(
      id: 'mh-sweet-peach',
      brandId: 'musthave',
      name: 'Sweet Peach',
      mood: Mood.fruity,
      strength: 4,
      tags: ['meyve', 'şeftali', 'tatlı'],
      description: 'Olgun tatlı şeftali, sulu.'),
  Flavor(
      id: 'mh-unicorn-threads',
      brandId: 'musthave',
      name: 'Unicorn Threads',
      mood: Mood.sweet,
      strength: 3,
      tags: ['şekerleme', 'pamuk-şeker', 'pastane'],
      description: 'Pamuk şekeri, pastane vibesi.'),

  // ─── DARKSIDE — bu hafta gelen 2 aroma ───────────
  Flavor(
      id: 'ds-lemon-blast',
      brandId: 'darkside',
      name: 'Lemon Blast',
      mood: Mood.fruity,
      strength: 6,
      tags: ['turunçgil', 'limon', 'yoğun'],
      description: 'Patlatan limon, sert turunçgil karakteri.'),
  Flavor(
      id: 'ds-red-alert',
      brandId: 'darkside',
      name: 'Red Alert',
      mood: Mood.berry,
      strength: 8,
      tags: ['orman-meyveli', 'baharat', 'yoğun'],
      description: 'Kırmızı uyarı — yoğun berry + baharat, sert.'),

  // ─── BLACK BURN — bu hafta gelen 10 aroma ────────
  Flavor(
      id: 'bb-blue-berry',
      brandId: 'black-burn',
      name: 'Blue Berry',
      mood: Mood.berry,
      strength: 6,
      tags: ['orman-meyveli', 'yaban-mersini', 'tatlı'],
      description: 'Yaban mersini, tatlı koyu berry.'),
  Flavor(
      id: 'bb-blackberry-lemonade',
      brandId: 'black-burn',
      name: 'Blackberry Lemonade',
      mood: Mood.berry,
      strength: 6,
      tags: ['orman-meyveli', 'limonata', 'ferah'],
      description: 'Böğürtlenli limonata, ferah ve tatlı.'),
  Flavor(
      id: 'bb-brownie',
      brandId: 'black-burn',
      name: 'Brownie',
      mood: Mood.sweet,
      strength: 7,
      tags: ['pastane', 'çikolata', 'kakao'],
      description: 'Çikolatalı brownie, koyu pastane.'),
  Flavor(
      id: 'bb-ekzo-mango',
      brandId: 'black-burn',
      name: 'Ekzo Mango',
      mood: Mood.fruity,
      strength: 6,
      tags: ['tropik', 'mango', 'egzotik'],
      description: 'Egzotik mango, yoğun tropik karakter.'),
  Flavor(
      id: 'bb-haribon',
      brandId: 'black-burn',
      name: 'Haribon',
      mood: Mood.berry,
      strength: 5,
      tags: ['şekerleme', 'sakız-ayıcık', 'tatlı'],
      description: 'Sakız ayıcık karışımı, tatlı berry.'),
  Flavor(
      id: 'bb-irish-cream',
      brandId: 'black-burn',
      name: 'Irish Cream',
      mood: Mood.sweet,
      strength: 7,
      tags: ['pastane', 'krema', 'likör'],
      description: 'Baileys benzeri kremsi likör.'),
  Flavor(
      id: 'bb-mirinda',
      brandId: 'black-burn',
      name: 'Mirinda',
      mood: Mood.fruity,
      strength: 5,
      tags: ['turunçgil', 'gazoz', 'portakal'],
      description: 'Portakal gazozu, karbonatlı tat.'),
  Flavor(
      id: 'bb-red-orange',
      brandId: 'black-burn',
      name: 'Red Orange',
      mood: Mood.fruity,
      strength: 6,
      tags: ['turunçgil', 'kan-portakalı', 'tatlı'],
      description: 'Kan portakalı, yoğun tatlı turunçgil.'),
  Flavor(
      id: 'bb-something-tropical',
      brandId: 'black-burn',
      name: 'Somethig Tropical',
      mood: Mood.fruity,
      strength: 6,
      tags: ['tropik', 'karışık', 'yoğun'],
      description: 'Karışık tropik patlama.'),
  Flavor(
      id: 'bb-sunday-sun',
      brandId: 'black-burn',
      name: 'Sunday Sun',
      mood: Mood.sweet,
      strength: 6,
      tags: ['pastane', 'pazar-kahvaltısı', 'tatlı'],
      description: 'Pazar sabahı kahvaltı vibesi.'),

  // ─── STARLINE — bu hafta gelen 6 aroma ───────────
  Flavor(
      id: 'sl-belgian-waffle',
      brandId: 'starline',
      name: 'Belgian Waffle',
      mood: Mood.sweet,
      strength: 3,
      tags: ['pastane', 'waffle', 'tatlı'],
      description: 'Belçika waffle, kremsi pastane.'),
  Flavor(
      id: 'sl-berry-sorbet',
      brandId: 'starline',
      name: 'Berry Sorbet',
      mood: Mood.berry,
      strength: 3,
      tags: ['orman-meyveli', 'sorbe', 'soğuk'],
      description: 'Berry sorbe, soğuk meyve.'),
  Flavor(
      id: 'sl-blackcurrant-sorbet',
      brandId: 'starline',
      name: 'Blackcurrant Sorbet',
      mood: Mood.berry,
      strength: 3,
      tags: ['orman-meyveli', 'frenk-uzumu', 'sorbe'],
      description: 'Frenk üzümlü sorbe, ferah ekşi.'),
  Flavor(
      id: 'sl-butter-cream',
      brandId: 'starline',
      name: 'Butter Cream',
      mood: Mood.sweet,
      strength: 3,
      tags: ['pastane', 'krema', 'tereyağı'],
      description: 'Tereyağlı krem, yumuşak pastane.'),
  Flavor(
      id: 'sl-orangina',
      brandId: 'starline',
      name: 'Orangina',
      mood: Mood.fruity,
      strength: 3,
      tags: ['turunçgil', 'gazoz', 'portakal'],
      description: 'Klasik portakallı gazoz.'),
  Flavor(
      id: 'sl-pineapple',
      brandId: 'starline',
      name: 'Pineapple',
      mood: Mood.fruity,
      strength: 3,
      tags: ['tropik', 'ananas', 'taze'],
      description: 'Olgun ananas, taze tropik.'),

  // ─── BONCHE — önceki katalog (stokta değil, gelen sonraki seferde) ─
  Flavor(
      id: 'bn-dark-chocolate',
      brandId: 'bonche',
      name: 'Dark Chocolate',
      mood: Mood.sweet,
      strength: 7,
      tags: ['pastane', 'çikolata', 'kakao'],
      description: 'Bitter çikolata, yoğun kakao.'),
  Flavor(
      id: 'bn-coffee',
      brandId: 'bonche',
      name: 'Coffee',
      mood: Mood.tobacco,
      strength: 7,
      tags: ['kahve', 'pastane', 'acımsı'],
      description: 'Espresso aroması.'),
  Flavor(
      id: 'bn-honey',
      brandId: 'bonche',
      name: 'Honey',
      mood: Mood.sweet,
      strength: 6,
      tags: ['bal', 'doğal', 'tatlı'],
      description: 'Saf bal, yumuşak doğal tatlılık.'),
  Flavor(
      id: 'bn-ginger',
      brandId: 'bonche',
      name: 'Ginger',
      mood: Mood.tobacco,
      strength: 7,
      tags: ['baharat', 'zencefil', 'yakıcı'],
      description: 'Taze zencefil, hafif yakıcı.'),
  Flavor(
      id: 'bn-bergamot',
      brandId: 'bonche',
      name: 'Bergamot',
      mood: Mood.tobacco,
      strength: 6,
      tags: ['çay', 'bergamot', 'klasik'],
      description: 'Sert bergamot, çay notası.'),
  Flavor(
      id: 'bn-green-tea',
      brandId: 'bonche',
      name: 'Green Tea',
      mood: Mood.mint,
      strength: 6,
      tags: ['çay', 'yeşil-çay', 'ot'],
      description: 'Yeşil çay, hafif ot.'),

  // ─── TROFIMOFF ───────────────────────────────────
  Flavor(
      id: 'tr-mangifera',
      brandId: 'trofimoff',
      name: 'Mangifera',
      mood: Mood.sweet,
      strength: 6,
      tags: ['tropik', 'mango', 'kremsi'],
      description: 'Kremsi mango, tropik dolgun.'),
  Flavor(
      id: 'tr-finlandia-vanila',
      brandId: 'trofimoff',
      name: 'Finlandia Vanila',
      mood: Mood.sweet,
      strength: 6,
      tags: ['pastane', 'vanilya', 'yumuşak'],
      description: 'Saf vanilya, yumuşak pastane.'),
  Flavor(
      id: 'tr-crio',
      brandId: 'trofimoff',
      name: 'Crio',
      mood: Mood.cool,
      strength: 9,
      tags: ['ferah', 'menthol', 'buz'],
      description: 'Buz gibi soğuk, en güçlü mentol.'),
  Flavor(
      id: 'tr-futura',
      brandId: 'trofimoff',
      name: 'Futura',
      mood: Mood.tobacco,
      strength: 8,
      tags: ['puro', 'karamel', 'ahşap'],
      description: 'Karamela + ahşap, sıcak puro.'),
  Flavor(
      id: 'tr-verry-berry',
      brandId: 'trofimoff',
      name: 'Verry Berry',
      mood: Mood.berry,
      strength: 6,
      tags: ['orman-meyveli', 'karışık', 'yoğun'],
      description: 'Yoğun karışık berry.'),
];

/// Featured mixler — gelen stoğa göre öneriler.
const kFeaturedMixes = <Mix>[
  Mix(
    id: 'mix-pastane-tatli',
    name: 'Pazar Kahvaltısı',
    tagline: 'Brownie + waffle + irish cream — pastane patlaması.',
    components: [
      MixComponent(flavorId: 'bb-brownie', ratio: 40),
      MixComponent(flavorId: 'sl-belgian-waffle', ratio: 30),
      MixComponent(flavorId: 'bb-irish-cream', ratio: 30),
    ],
    mood: Mood.sweet,
    prepNote: 'Sıkı dolum, çift köz. Tatlı sevenler için pastane şöleni.',
    intensity: 4,
  ),
  Mix(
    id: 'mix-orman-frengi',
    name: 'Orman Frengi',
    tagline: 'Frenk üzümü + yaban mersini + berry sorbe.',
    components: [
      MixComponent(flavorId: 'mh-black-currant', ratio: 40),
      MixComponent(flavorId: 'bb-blue-berry', ratio: 30),
      MixComponent(flavorId: 'sl-berry-sorbet', ratio: 30),
    ],
    mood: Mood.berry,
    prepNote: 'Bardak yarı buzlu. Orta sıkılıkta dolum.',
    intensity: 4,
  ),
  Mix(
    id: 'mix-akdeniz-gunesi',
    name: 'Akdeniz Güneşi',
    tagline: 'Kan portakalı + greyfurt + orangina.',
    components: [
      MixComponent(flavorId: 'bb-red-orange', ratio: 40),
      MixComponent(flavorId: 'mh-grapefruit', ratio: 30),
      MixComponent(flavorId: 'sl-orangina', ratio: 30),
    ],
    mood: Mood.fruity,
    prepNote: 'Soğuk su. Orta dolum, çift köz.',
    intensity: 5,
  ),
  Mix(
    id: 'mix-tropik-patlama',
    name: 'Tropik Patlama',
    tagline: 'Mango + ananas + tropik karışım.',
    components: [
      MixComponent(flavorId: 'bb-ekzo-mango', ratio: 40),
      MixComponent(flavorId: 'mh-pineapple-rings', ratio: 30),
      MixComponent(flavorId: 'bb-something-tropical', ratio: 30),
    ],
    mood: Mood.fruity,
    prepNote: 'Bardak buzlu, sıkı dolum.',
    intensity: 6,
  ),
  Mix(
    id: 'mix-kirmizi-uyari',
    name: 'Kırmızı Uyarı',
    tagline: 'Yoğun karakter — Red Alert + ahududu + frenk üzümü.',
    components: [
      MixComponent(flavorId: 'ds-red-alert', ratio: 50),
      MixComponent(flavorId: 'mh-raspberry', ratio: 30),
      MixComponent(flavorId: 'mh-black-currant', ratio: 20),
    ],
    mood: Mood.berry,
    prepNote: 'Çift köz, yüksek ısı. Sert karakter sever.',
    intensity: 8,
  ),
  Mix(
    id: 'mix-citrus-twist',
    name: 'Citrus Twist',
    tagline: 'Lemon Blast + Lemon Lime + greyfurt.',
    components: [
      MixComponent(flavorId: 'ds-lemon-blast', ratio: 40),
      MixComponent(flavorId: 'mh-lemon-lime', ratio: 30),
      MixComponent(flavorId: 'mh-grapefruit', ratio: 30),
    ],
    mood: Mood.fruity,
    prepNote: 'Buz parçası. Orta dolum.',
    intensity: 5,
  ),
  Mix(
    id: 'mix-peach-blackberry',
    name: 'Peach Blackberry',
    tagline: 'Sweet Peach + Blackberry Lemonade + Mad Pear.',
    components: [
      MixComponent(flavorId: 'mh-sweet-peach', ratio: 40),
      MixComponent(flavorId: 'bb-blackberry-lemonade', ratio: 30),
      MixComponent(flavorId: 'mh-mad-pear', ratio: 30),
    ],
    mood: Mood.fruity,
    prepNote: 'Soğuk su. Yumuşak dolum.',
    intensity: 4,
  ),
  Mix(
    id: 'mix-pastane-vanilya',
    name: 'Pastane Vanilya',
    tagline: 'Unicorn pamuk şekeri + Butter Cream + Belgian Waffle.',
    components: [
      MixComponent(flavorId: 'mh-unicorn-threads', ratio: 40),
      MixComponent(flavorId: 'sl-butter-cream', ratio: 30),
      MixComponent(flavorId: 'sl-belgian-waffle', ratio: 30),
    ],
    mood: Mood.sweet,
    prepNote: 'Sıkı dolum, normal ısı. Hafif tatlı pastane.',
    intensity: 3,
  ),
];

Brand? brandById(String id) {
  for (final b in kBrands) {
    if (b.id == id) return b;
  }
  return null;
}

Flavor? flavorById(String id) {
  for (final f in kFlavors) {
    if (f.id == id) return f;
  }
  return null;
}

List<Flavor> flavorsByBrand(String brandId) =>
    kFlavors.where((f) => f.brandId == brandId).toList();

/// Bu haftaki gelen stok — InventoryNotifier başlangıç değeri olarak kullanılır.
const kCurrentStockIds = <String>[
  // Darkside
  'ds-lemon-blast', 'ds-red-alert',
  // Starline
  'sl-belgian-waffle', 'sl-berry-sorbet', 'sl-blackcurrant-sorbet',
  'sl-butter-cream', 'sl-orangina', 'sl-pineapple',
  // MustHave
  'mh-black-currant', 'mh-cranberry', 'mh-grapefruit', 'mh-lemon-lime',
  'mh-mad-pear', 'mh-mango-sling', 'mh-orange-team', 'mh-pineapple-rings',
  'mh-raspberry', 'mh-rocketman', 'mh-sweet-peach', 'mh-unicorn-threads',
  // Black Burn
  'bb-blue-berry', 'bb-blackberry-lemonade', 'bb-brownie', 'bb-ekzo-mango',
  'bb-haribon', 'bb-irish-cream', 'bb-mirinda', 'bb-red-orange',
  'bb-something-tropical', 'bb-sunday-sun',
];
