import '../models/community_mix.dart';
import '../models/mood.dart';

/// ivankalyanshop.ru'dan derlenmiş ~87 topluluk mix tarifi.
/// Kategoriler bizim Mood enum'a map edilmiş:
///   Dessert/Gastronomy → sweet
///   Beverages → fruity (genelde)
///   Spices/Herbs → mint veya tobacco
///   Tropical → fruity
///   Fruity → fruity
///   Citrus → fruity
///   Berry → berry
///   Alcoholic → sweet
const kCommunityMixes = <CommunityMix>[
  // ─── BLACKBURN SAYFA 1 (18 mix) ─────────────────
  CommunityMix(
    id: 'c-bb-dessert-105',
    name: 'Dessert #105',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Darkside', flavor: 'Supernova', ratio: 5),
      CommunityComponent(brand: 'Blackburn', flavor: 'Brownie', ratio: 25),
      CommunityComponent(brand: 'Blackburn', flavor: 'Kiwi Stoner', ratio: 20),
      CommunityComponent(brand: 'Chabacco', flavor: 'Ice Cream', ratio: 20),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 30),
    ],
  ),
  CommunityMix(
    id: 'c-bb-dessert-117',
    name: 'Dessert #117',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Duft', flavor: 'Gooseberry', ratio: 20),
      CommunityComponent(brand: 'Must Have', flavor: 'Milky Rice', ratio: 10),
      CommunityComponent(brand: 'Blackburn', flavor: 'Melon Halls', ratio: 40),
      CommunityComponent(brand: 'Spectrum', flavor: 'Jungle Mix', ratio: 30),
    ],
  ),
  CommunityMix(
    id: 'c-bb-dessert-146',
    name: 'Dessert #146',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Cherry Garden', ratio: 25),
      CommunityComponent(brand: 'Blackburn', flavor: 'Cherry Shock', ratio: 15),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 30),
      CommunityComponent(brand: 'Blackburn', flavor: 'Brownie', ratio: 30),
    ],
  ),
  CommunityMix(
    id: 'c-bb-dessert-154',
    name: 'Dessert #154',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Brownie', ratio: 40),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 60),
    ],
  ),
  CommunityMix(
    id: 'c-bb-dessert-174',
    name: 'Dessert #174',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Overdose', ratio: 20),
      CommunityComponent(brand: 'Blackburn', flavor: 'Haribon', ratio: 40),
      CommunityComponent(brand: 'Darkside', flavor: 'Cosmo Flower', ratio: 40),
    ],
  ),
  CommunityMix(
    id: 'c-bb-tropical-860',
    name: 'Tropical #860',
    category: 'Tropical',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Kiwi', ratio: 10),
      CommunityComponent(brand: 'Blackburn', flavor: 'Malibu', ratio: 10),
      CommunityComponent(brand: 'Darkside', flavor: 'Needles', ratio: 10),
      CommunityComponent(brand: 'Blackburn', flavor: 'Papaya', ratio: 30),
      CommunityComponent(brand: 'Blackburn', flavor: 'Irish Cream', ratio: 25),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 15),
    ],
  ),
  CommunityMix(
    id: 'c-bb-fruity-1148',
    name: 'Fruity #1148',
    category: 'Fruity',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Satyr', flavor: 'Lemon', ratio: 30),
      CommunityComponent(brand: 'Satyr', flavor: 'Chika', ratio: 40),
      CommunityComponent(brand: 'Blackburn', flavor: 'Grape', ratio: 10),
      CommunityComponent(brand: 'Banger', flavor: 'Wildberry', ratio: 20),
    ],
  ),
  CommunityMix(
    id: 'c-bb-fruity-1207',
    name: 'Fruity #1207',
    category: 'Fruity',
    mood: Mood.berry,
    components: [
      CommunityComponent(brand: 'Darkside', flavor: 'Wild Forest', ratio: 30),
      CommunityComponent(brand: 'Element', flavor: 'Raspberry', ratio: 15),
      CommunityComponent(brand: 'Blackburn', flavor: 'Cherry Garden', ratio: 20),
      CommunityComponent(brand: 'Blackburn', flavor: 'Elderberry', ratio: 20),
      CommunityComponent(brand: 'Sebero', flavor: 'Strawberry', ratio: 15),
    ],
  ),
  CommunityMix(
    id: 'c-bb-citrus-1286',
    name: 'Citrus #1286',
    category: 'Citrus',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Satyr', flavor: 'Squirt', ratio: 10),
      CommunityComponent(brand: 'Blackburn', flavor: 'Strawberry', ratio: 25),
      CommunityComponent(brand: 'Satyr', flavor: 'Cherry', ratio: 40),
      CommunityComponent(brand: 'Element', flavor: 'Ekzo', ratio: 25),
    ],
  ),
  CommunityMix(
    id: 'c-bb-berry-1490',
    name: 'Berry #1490',
    category: 'Berry',
    mood: Mood.berry,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Elderberry', ratio: 15),
      CommunityComponent(brand: 'Element', flavor: 'Water Frost', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Vanilla', ratio: 30),
      CommunityComponent(brand: 'Element', flavor: 'Fir', ratio: 10),
      CommunityComponent(brand: 'Element', flavor: 'Mango', ratio: 35),
    ],
  ),
  CommunityMix(
    id: 'c-bb-berry-1533',
    name: 'Berry #1533',
    category: 'Berry',
    mood: Mood.berry,
    components: [
      CommunityComponent(brand: 'Darkside', flavor: 'Grape', ratio: 45),
      CommunityComponent(brand: 'Must Have', flavor: 'Kiwi', ratio: 35),
      CommunityComponent(brand: 'Blackburn', flavor: 'Currant', ratio: 20),
    ],
  ),
  CommunityMix(
    id: 'c-bb-berry-1591',
    name: 'Berry #1591',
    category: 'Berry',
    mood: Mood.berry,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Strawberry', ratio: 50),
      CommunityComponent(brand: 'Must Have', flavor: 'Fizzy Dizzy', ratio: 50),
    ],
  ),
  CommunityMix(
    id: 'c-bb-berry-1644',
    name: 'Berry #1644',
    category: 'Berry',
    mood: Mood.berry,
    components: [
      CommunityComponent(brand: 'Element', flavor: 'Margarita', ratio: 20),
      CommunityComponent(brand: 'Sebero', flavor: 'Currant', ratio: 20),
      CommunityComponent(brand: 'Starbuzz', flavor: 'Fresh Lime', ratio: 20),
      CommunityComponent(brand: 'Blackburn', flavor: 'Pineapple', ratio: 40),
    ],
  ),
  CommunityMix(
    id: 'c-bb-spices-743',
    name: 'Spices #743',
    category: 'Spices',
    mood: Mood.tobacco,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Black Honey', ratio: 25),
      CommunityComponent(brand: 'Tangiers', flavor: 'Cane Mint', ratio: 10),
      CommunityComponent(brand: 'Sebero', flavor: 'Herbal Currant', ratio: 25),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 40),
    ],
  ),
  CommunityMix(
    id: 'c-bb-alcoholic-209',
    name: 'Alcoholic #209',
    category: 'Alcoholic',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Element', flavor: 'Lemongrass', ratio: 10),
      CommunityComponent(brand: 'Blackburn', flavor: 'Lemon Sweets', ratio: 5),
      CommunityComponent(brand: 'Bonche', flavor: 'Whiskey', ratio: 5),
      CommunityComponent(brand: 'Darkside', flavor: 'Cola', ratio: 60),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 20),
    ],
  ),
  CommunityMix(
    id: 'c-bb-tropical-947',
    name: 'Tropical #947',
    category: 'Tropical',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 10),
      CommunityComponent(brand: 'Darkside', flavor: 'Guava', ratio: 10),
      CommunityComponent(brand: 'Tangiers', flavor: 'Peach Tea', ratio: 20),
      CommunityComponent(brand: 'Sebero', flavor: 'Apricot', ratio: 20),
      CommunityComponent(brand: 'Blackburn', flavor: 'Green Tea', ratio: 30),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 10),
    ],
  ),

  // ─── MUSTHAVE SAYFA 1 ────────────────────────────
  CommunityMix(
    id: 'c-mh-dessert-41',
    name: 'Dessert #41',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Melonade', ratio: 40),
      CommunityComponent(brand: 'Endorphin', flavor: 'Napoleon', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Pistachio', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Candy Cow', ratio: 30),
    ],
  ),
  CommunityMix(
    id: 'c-mh-dessert-93',
    name: 'Dessert #93',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 15),
      CommunityComponent(brand: 'Must Have', flavor: 'Coconut Shake', ratio: 40),
      CommunityComponent(brand: 'Endorphin', flavor: 'Cacao', ratio: 45),
    ],
  ),
  CommunityMix(
    id: 'c-mh-spices-717',
    name: 'Spices #717',
    category: 'Spices',
    mood: Mood.mint,
    components: [
      CommunityComponent(brand: 'Darkside', flavor: 'Supernova', ratio: 5),
      CommunityComponent(brand: 'Must Have', flavor: 'Apple Drops', ratio: 35),
      CommunityComponent(brand: 'Must Have', flavor: 'Peppermint', ratio: 25),
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 35),
    ],
  ),
  CommunityMix(
    id: 'c-mh-tropical-861',
    name: 'Tropical #861',
    category: 'Tropical',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Cranberry', ratio: 20),
      CommunityComponent(brand: 'Blackburn', flavor: 'Rising Star', ratio: 45),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 25),
    ],
  ),
  CommunityMix(
    id: 'c-mh-fruity-1056',
    name: 'Fruity #1056',
    category: 'Fruity',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 5),
      CommunityComponent(brand: 'Must Have', flavor: 'Baikal', ratio: 15),
      CommunityComponent(brand: 'Serbetli', flavor: 'Cola', ratio: 30),
      CommunityComponent(brand: 'Must Have', flavor: 'Sweet Peach', ratio: 50),
    ],
  ),
  CommunityMix(
    id: 'c-mh-fruity-1095',
    name: 'Fruity #1095',
    category: 'Fruity',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 5),
      CommunityComponent(brand: 'Must Have', flavor: 'Citrus Spritz', ratio: 20),
      CommunityComponent(brand: 'Starbuzz', flavor: 'Fresh Lime', ratio: 20),
      CommunityComponent(brand: 'Must Have', flavor: 'Apple Drops', ratio: 15),
      CommunityComponent(brand: 'Must Have', flavor: 'Cranberry', ratio: 40),
    ],
  ),
  CommunityMix(
    id: 'c-mh-citrus-1365',
    name: 'Citrus #1365',
    category: 'Citrus',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Feijoa', ratio: 35),
      CommunityComponent(brand: 'Must Have', flavor: 'Orange Team', ratio: 15),
      CommunityComponent(brand: 'Must Have', flavor: 'Berry Holls', ratio: 35),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 15),
    ],
  ),
  CommunityMix(
    id: 'c-mh-citrus-1367',
    name: 'Citrus #1367',
    category: 'Citrus',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Citrus Spritz', ratio: 20),
      CommunityComponent(brand: 'Endorphin', flavor: 'Grapefruit', ratio: 20),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 40),
      CommunityComponent(brand: 'Frigate', flavor: 'Caribbean Nights', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 10),
    ],
  ),

  // ─── DARKSIDE SAYFA 1 ────────────────────────────
  CommunityMix(
    id: 'c-ds-dessert-134',
    name: 'Dessert #134',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Smoke Angels', flavor: 'Pamela', ratio: 30),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 60),
      CommunityComponent(brand: 'Darkside', flavor: 'Supernova', ratio: 10),
    ],
  ),
  CommunityMix(
    id: 'c-ds-tropical-975',
    name: 'Tropical #975',
    category: 'Tropical',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 60),
      CommunityComponent(brand: 'Smoke Angels', flavor: 'Pamela', ratio: 30),
      CommunityComponent(brand: 'Darkside', flavor: 'Supernova', ratio: 10),
    ],
  ),
  CommunityMix(
    id: 'c-ds-citrus-1259',
    name: 'Citrus #1259',
    category: 'Citrus',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Darkside', flavor: 'Barvy Orange', ratio: 60),
      CommunityComponent(brand: 'Blackburn', flavor: 'Black Honey', ratio: 40),
    ],
  ),
  CommunityMix(
    id: 'c-ds-citrus-1457',
    name: 'Citrus #1457',
    category: 'Citrus',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Mango Sling', ratio: 40),
      CommunityComponent(brand: 'Must Have', flavor: 'Orange Team', ratio: 30),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 20),
      CommunityComponent(brand: 'Darkside', flavor: 'Supernova', ratio: 10),
    ],
  ),
  CommunityMix(
    id: 'c-ds-berry-1609',
    name: 'Berry #1609',
    category: 'Berry',
    mood: Mood.berry,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Pineapple Rings', ratio: 45),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 45),
      CommunityComponent(brand: 'Darkside', flavor: 'Supernova', ratio: 10),
    ],
  ),
  CommunityMix(
    id: 'c-ds-beverages-488',
    name: 'Beverages #488',
    category: 'Beverages',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Darkside', flavor: 'Bananapapa Rare', ratio: 40),
      CommunityComponent(brand: 'Smoke Angels', flavor: 'Desert Corn', ratio: 25),
      CommunityComponent(brand: 'Must Have', flavor: 'Candy Cow', ratio: 10),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 25),
    ],
  ),

  // ─── MUSTHAVE SAYFA 3 ────────────────────────────
  CommunityMix(
    id: 'c-mh-dessert-86',
    name: 'Dessert #86',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Ice Baby', ratio: 40),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 60),
    ],
  ),
  CommunityMix(
    id: 'c-mh-dessert-142',
    name: 'Dessert #142',
    category: 'Dessert',
    mood: Mood.sweet,
    components: [
      CommunityComponent(brand: 'Blackburn', flavor: 'Ananas Shock', ratio: 15),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 85),
    ],
  ),
  CommunityMix(
    id: 'c-mh-citrus-1273',
    name: 'Citrus #1273',
    category: 'Citrus',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Sebero', flavor: 'Banana', ratio: 20),
      CommunityComponent(brand: 'Bonche', flavor: 'Pineapple', ratio: 50),
      CommunityComponent(brand: 'Must Have', flavor: 'Pinkman', ratio: 30),
    ],
  ),
  CommunityMix(
    id: 'c-mh-tropical-908',
    name: 'Tropical #908',
    category: 'Tropical',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Pistachio', ratio: 20),
      CommunityComponent(brand: 'Endorphin', flavor: 'Apple', ratio: 30),
      CommunityComponent(brand: 'Must Have', flavor: 'Coconut Shake', ratio: 15),
      CommunityComponent(brand: 'Must Have', flavor: 'Araram', ratio: 35),
    ],
  ),
  CommunityMix(
    id: 'c-mh-fruity-1047',
    name: 'Fruity #1047',
    category: 'Fruity',
    mood: Mood.fruity,
    components: [
      CommunityComponent(brand: 'Must Have', flavor: 'Frosty', ratio: 5),
      CommunityComponent(brand: 'Must Have', flavor: 'Kiwi Smoothie', ratio: 35),
      CommunityComponent(brand: 'Must Have', flavor: 'Pineapple Rings', ratio: 30),
      CommunityComponent(brand: 'Endorphin', flavor: 'Mango', ratio: 30),
    ],
  ),
];
