# Mixcraft 🍸

A **cocktail & drink builder** — tell it what you have in your bar and it helps you craft mixes you
can actually make.

Built with **Flutter** + **Riverpod**.

## Features

- **Mix builder** — assemble drinks step by step.
- **Mix assistant** — ingredient-aware suggestions based on your inventory.
- **Inventory** — track the bottles and ingredients you own.
- **Smart filters** — filter mixes (e.g. alcoholic / non-alcoholic, by ingredient); clear empty-state
  when nothing matches.
- **Favorites & detail** — save mixes and view full recipes.
- **Brand** — themed, branded UI.

## Tech stack

| Area | Choices |
| --- | --- |
| Framework | Flutter · Dart |
| State | Riverpod |
| Networking | Dio / HTTP |

Feature-first structure under `lib/features/*` (home, mix_builder, mix_assistant, mix_detail,
inventory, favorites, brand).

## Running it

```bash
flutter pub get
flutter run
```

---

Built by [Timur Batyrkul](https://github.com/timurbatyrkul001).
