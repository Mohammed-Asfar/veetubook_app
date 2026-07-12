<p align="center">
  <img src="assets/logo/veetubook_icon.png" alt="veetubook logo" width="120" height="120">
</p>

<h1 align="center">veetubook · வீட்டு புக்</h1>

A bilingual (Tamil / English) **grocery-list and household-expense** app for
Flutter. Build a shopping list from a reusable product catalog, mark items as
bought while you shop, and watch your monthly spend — all **fully offline**, no
account required.

The name *veetubook* (வீட்டு புக், "house book") nods to the household
account book Tamil families keep.

## Features

- **Bilingual everywhere** — UI toggles between Tamil and English, and every
  product carries both a Tamil and an English name (with graceful fallback when
  only one is set). Search works in either language.
- **Reusable product catalog** — ~230 seeded Indian household items (grains,
  pulses, spices, veg, fruit, dairy, non-veg, ready-to-cook, household) with
  saved prices, plus your own products. Each product is a price template:
  ₹50/kg → pick 3 kg → line total auto-calculates to ₹150 (override anytime).
- **Grocery lists** — create, rename, re-date, and delete lists; add items from
  the catalog or as one-off entries. Auto-named lists (toggleable), unique
  titles, searchable.
- **Unit-aware quantities** — discrete units (piece/pack/dozen) step in whole
  numbers; continuous units (kg/litre) allow fractions.
- **Automatic expenses** — bought items roll up into a monthly expense for the
  list's date; no separate "finish trip" step. Past expense records are
  read-only and price-snapshotted, so editing the catalog never rewrites
  history.
- **Spend insights** — monthly and weekly spend charts with a
  month-over-month trend.
- **Onboarding** — a branded splash screen, then a first-launch
  List → Shop → Track intro you can replay anytime from Settings → How it works.
- **In-app updates** — on launch the app checks GitHub Releases and, if a newer
  version is published, shows an "Update available" dialog (with release notes)
  that opens the release page. Users can skip a version, and check manually from
  Settings → Check for updates. Fails silently offline.
- **Settings** — language, currency symbol, auto-naming, CSV export, and
  clear-all-data.

## Tech stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Dart SDK `^3.11.0`) |
| State management | `flutter_bloc` (Cubit) |
| Local database | `drift` over SQLite (`sqlite3_flutter_libs`) |
| Dependency injection | `get_it` |
| Money | integer paise + `decimal` (never `double`) |
| Localization | `intl` + `flutter_localizations` (`.arb`) |
| Charts | `fl_chart` |
| Persistence / export | `shared_preferences`, `csv`, `share_plus` |

## Architecture

Feature-based, with a layered structure inside each feature:

```
lib/
  core/
    theme/         single source of truth for colors, spacing, text styles
    widgets/       shared UI (BilingualText, PriceText, QuantityStepper, …)
    db/            drift database + tables
    di/            get_it service locator
    localization/  language handling
    utils/         money, units, month helpers
  features/
    catalog/       data / domain / presentation
    lists/
    shopping/
    expenses/
    settings/
  l10n/            app_en.arb, app_ta.arb
  main.dart
```

Repository interfaces live in each feature's `domain/`, so the SQLite data
source can later be swapped for cloud sync without touching the UI.

**Design conventions:** no hardcoded colors, paddings, or inline text styles in
feature code — everything routes through `core/theme/`. A widget or style used
in 2+ places belongs in `core/widgets/` or `core/theme/`, not copy-pasted.

## Getting started

```bash
flutter pub get

# Generate localization + drift code (needed after a fresh clone or when
# tables/.arb files change):
flutter gen-l10n
dart run build_runner build

flutter run
```

## Testing

```bash
flutter analyze
flutter test
```

The suite covers the catalog seeder, money auto-calc, unit semantics,
month-over-month comparison, expense sync, settings persistence, and a live
language-toggle widget test.

## Releases

Releases are automated with GitHub Actions
([.github/workflows/release.yml](.github/workflows/release.yml)). Pushing a
`v*` tag runs analyze + tests, builds a release APK, and publishes it to a new
GitHub Release. To cut a release:

1. **Bump the version** in [pubspec.yaml](pubspec.yaml) — e.g. `1.0.0+1` → `1.1.0+2`.
   The new version must be higher than what users have installed, or the in-app
   updater won't prompt them.
2. **Commit** the bump: `git commit -am "Release v1.1.0"`.
3. **Tag and push** — the tag name (minus the `v`) becomes the build version:
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```
4. The workflow builds `veetubook-1.1.0.apk` (version taken from the tag, so the
   installed app's version always matches the release), then publishes a GitHub
   Release with auto-generated notes and the APK attached.
5. Existing users' apps check `releases/latest` on next launch and show the
   **Update available** prompt.

> The APK is signed with the debug key (the project default) — fine for direct
> sideload distribution via GitHub Releases, but not for the Play Store or for
> upgrading over a differently-signed build.

Every push to `main` and every pull request also runs analyze + tests via
[.github/workflows/ci.yml](.github/workflows/ci.yml).

## Notes

- **Offline-first:** all data lives on-device in SQLite. There are no accounts
  and no network calls. Uninstalling the app deletes all data — use
  Settings → Export (CSV) to back up first.
- The starter catalog is seeded **once, on first launch** (in a single
  transaction). To pick up new seed items on an existing install, use
  Settings → Clear all data or reinstall.
