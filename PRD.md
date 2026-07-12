# veetubook — Product Requirements Document (PRD)

> **veetubook** (வீட்டு புக் — "house book") is a bilingual **Tamil / English** grocery-list and household-expense tracker for Flutter. Offline-first, built with BLoC and a local SQLite (drift) database.

- **Version:** 1.0 (draft)
- **Date:** 2026-07-11
- **Platform:** Flutter (Android first; iOS-ready)
- **State management:** BLoC (`flutter_bloc`)
- **Storage:** SQLite via **drift** (offline-first, no accounts)
- **Languages:** Tamil & English (full UI toggle + bilingual item data)

---

## 1. Overview

veetubook helps a household track the groceries and products they buy for their own home — what to buy, what it costs, and how spending changes month to month. It works fully offline, in Tamil or English, and remembers product prices so building a list and tallying a shopping trip is fast.

The core idea: a **reusable product catalog** where each product remembers its price per unit, so adding it to a list **auto-calculates** the cost for any quantity. Completed shopping trips become **expense records**, and the app shows **month-over-month spend** so a family can see whether grocery costs are rising.

---

## 2. Problem & Goals

**Problem.** Tamil-speaking households want a simple, offline way — in their own language — to plan grocery shopping and understand household spend. Existing apps are English-only, cloud/account-heavy, or optimized for shopkeepers rather than home users.

**Goals**
- Let a household plan a grocery list and check items off while shopping (often offline in a shop).
- Remember product prices and **auto-calculate** the cost for any quantity.
- Record each trip as an expense and show **month-over-month** household spend.
- Work fully offline, in Tamil or English, with item names in both.

**Non-goals (v1)**
- User accounts, cloud sync, multi-device sharing.
- Barcode scanning, shopkeeper/retail billing, inventory.
- Multi-store price comparison (planned; see Roadmap).

---

## 3. Target Users & Personas

**Primary — the household customer.** An individual who tracks the groceries/products they buy for their own home (personal & family use, **not** a shopkeeper/retailer). Bilingual (Tamil/English). Typical flow: builds a list at home, checks items off and records prices while shopping (often offline in a shop), then reviews monthly household spend.

**Secondary — a family member** who shares the same household list on the same device.

---

## 4. Scope

**In scope (MVP)**
- Reusable **product catalog** with price-per-unit templates.
- **Auto price calculation** by quantity when adding products.
- **Grocery lists** (create/rename/delete; add from catalog or ad-hoc).
- **Shopping mode** (check off, adjust qty/price, running total).
- **Expense tracking** — each completed trip = an expense record.
- **Monthly summary + month-over-month comparison** (total, % change, chart).
- **Bilingual** UI toggle (Tamil ⇄ English) and item names in both languages.
- **Settings** (language, currency default ₹, clear data, export).

**Out of scope (v1)**
- Accounts, cloud sync, sharing, barcode, store comparison, budgets/alerts.

---

## 5. Features

Each feature lists a user story and acceptance criteria (AC).

### F1 — Product catalog
Reusable product records: **Tamil name, English name, category, unit, base quantity, base price** (e.g. ₹50 per 1 kg). Each product is a reusable **price template**.
- *Story:* As a user, I save products with their usual price so I don't re-enter them.
- **AC:** Add/edit/delete products; product detail page shows saved price & unit; at least one name (Tamil or English) is required; base price stored as integer paise.

### F1a — Auto price calculation
When a catalog product is added to a list (or on the detail page), the user picks a quantity and the app auto-calculates:
`line_price = unit_price × quantity`, where `unit_price = base_price ÷ base_qty`.
- *Example:* rice saved at ₹50/kg → choose 3 kg → auto-fills ₹150.
- **AC:** Recomputes live as qty changes; supports fractional qty with unit conversion (250 g of a ₹/kg item = ₹12.50); user can **override** the calculated price; integer-only units reject fractions.

### F2 — Grocery lists
- *Story:* As a user, I create a shopping list and add items from my catalog or as one-offs.
- **AC:** Create/rename/delete lists; add items from catalog (carrying price/unit) or ad-hoc; reorder/remove items; empty-state guidance when no lists exist.

### F3 — Shopping mode
- *Story:* While shopping I check items off and adjust actual price/quantity.
- **AC:** Check/uncheck items; adjusting qty re-runs auto-calc (unless price overridden); override actual price paid; live **running total**; resume with state intact if the app closes mid-trip.

### F4 — Expense tracking
- *Story:* When I finish a trip, it's saved as an expense I can review later.
- **AC:** Completing a list creates an `expense` (date + total of **bought** items); prices are **snapshotted** per item so later catalog edits don't rewrite past expenses; past trips are viewable/editable (edits recompute totals).

### F5 — Monthly summary & month-over-month comparison
- *Story:* I want to see if my grocery spending is going up.
- **AC:** Total spend per month; **month-over-month % change** with a bar/line chart (`fl_chart`); first month shows "no prior data" instead of a divide-by-zero; current (partial) month labelled "so far"; skipped months render as ₹0.

### F6 — Localization (Tamil / English)
- *Story:* I use the app in Tamil (or English) and see item names in my language.
- **AC:** UI language toggle via `intl`/`.arb` (`app_en.arb`, `app_ta.arb`); live re-render on switch; `BilingualText` shows the name for the active language with **fallback** to the other if one is missing; search matches both languages; Tamil font (Noto Sans Tamil) bundled; Indian date/number formatting.

### F7 — Settings
- *Story:* I control language, currency, and my data.
- **AC:** Language selector; default currency ₹ (INR), configurable; **export** (CSV/JSON) backup; **clear all data** with confirmation (offer export first).

---

## 6. Tech Stack

| Concern | Choice |
|---|---|
| Framework | Flutter |
| State management | `flutter_bloc` (BLoC/Cubit), `equatable` |
| Local DB | **`drift`** + `sqlite3_flutter_libs` (reactive, type-safe, compile-time SQL) |
| DI | `get_it` (+ optional `injectable`) |
| Localization | `flutter_localizations`, `intl`, `.arb` files |
| Money | `decimal` package; store as **integer paise** |
| Charts | `fl_chart` |
| Paths/export | `path_provider`, `csv` / `share_plus` |

**Why drift over sqflite:** reactive streams pair naturally with BLoC (UI auto-updates on DB change), and compile-time-checked SQL suits the analytics queries.

---

## 7. Architecture & Design System

### Layered, feature-based
Inside each feature, three layers:
- **presentation** — BLoC/Cubit + widgets
- **domain** — entities, **repository interfaces**, use cases
- **data** — drift DAOs, models, repository implementations

**Repository interfaces in `domain` are the seam** that lets a future Firebase/cloud sync slot in without rewriting features.

### Single source of truth for theme *(hard requirement)*
- **All** colors, typography, spacing, radii, elevations live in `core/theme/` (`app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`, `app_theme.dart`).
- **No hardcoded `Color(0xFF…)`, magic paddings, or inline `TextStyle` in feature code.** Always consume via `Theme.of(context)` + a `ThemeExtension` for custom tokens, so light/dark and re-skinning change in exactly one place.

### Reusable UI component library *(hard requirement)*
- `core/widgets/` holds shared design-system components used across all features: `AppButton`, `AppTextField`, `AppCard`, `QuantityStepper`, `PriceText` (paise→₹ formatting), `CurrencyInput`, `BilingualText`, `EmptyState`, `LoadingIndicator`, `ConfirmDialog`, `AppScaffold`.
- **Rule:** if a widget or style is used in 2+ places, it belongs in `core/`, not copy-pasted into a feature.

---

## 8. Folder Structure (feature-based)

```
lib/
  core/
    theme/          # app_colors, app_text_styles, app_spacing, app_theme — SINGLE source of truth
    widgets/        # shared reusable components: AppButton, BilingualText, PriceText, QuantityStepper, EmptyState, ConfirmDialog…
    localization/   # l10n setup, language cubit
    di/             # get_it/injectable service locator
    db/             # drift database, DAOs base, migrations
    utils/          # money/decimal helpers, date/month helpers, formatters
  features/
    catalog/        # products & prices
      data/  domain/  presentation/
    lists/          # grocery lists
      data/  domain/  presentation/
    shopping/       # shopping mode / check-off
      data/  domain/  presentation/
    expenses/       # trips, monthly summary & comparison
      data/  domain/  presentation/
    settings/       # language, currency, export, clear data
      data/  domain/  presentation/
  l10n/             # app_en.arb, app_ta.arb
  main.dart
```

---

## 9. Data Model (drift tables)

> Money stored as **integer paise**. Timestamps stored in **UTC**.

- **categories** (`id`, `name_ta`, `name_en`)
- **products** (`id`, `name_ta`, `name_en`, `category_id`, `unit`, `base_qty` [default 1], `base_price` [paise, for base_qty], `is_deleted` [soft-delete], `updated_at`)
  - the reusable price template
- **grocery_lists** (`id`, `title`, `created_at`, `status`, `updated_at`)
- **list_items** (`id`, `list_id`, `product_id?`, `name_ta`, `name_en`, `unit`, `qty`, `unit_price` [snapshot of base_price÷base_qty], `line_price` [auto = unit_price × qty, overridable], `is_price_overridden`, `is_bought`)
  - price/name **snapshotted** so later catalog edits don't rewrite past lists/expenses
- **expenses** (`id`, `list_id`, `date`, `total_amount`, `updated_at`, `is_synced`)
  - `is_synced`/`updated_at` reserved for future cloud sync

**Referential integrity:** `list_items.product_id` uses `ON DELETE SET NULL` (or product soft-delete) so deleting a catalog product never corrupts past expenses.

**Store-pricing note (forward-compatible).** V1 uses **one default price per product** (acts as "last-paid") plus the per-item `line_price` snapshot of what was actually paid. Because catalog price and per-item price are **decoupled via snapshotting**, adding store-awareness later is purely additive: introduce `stores(id, name_ta, name_en)`, add optional `store_id` to `grocery_lists`/`list_items`, and add `product_prices(product_id, store_id, price, updated_at)` — no changes to existing tables/features, and past snapshots become per-store history retroactively.

---

## 10. Non-Functional Requirements

- **Offline-first** — no network dependency anywhere in v1.
- **Performance** — fast startup; stream/paginate large lists; index by `date` and `list_id`; single long-lived drift instance via DI.
- **Money accuracy** — integer paise + `decimal`; single rounding rule (round half-up, 2 dp).
- **Localization** — full Tamil/English; Noto Sans Tamil bundled; Indian (`en_IN`/`ta_IN`) number & date formatting.
- **Accessibility** — respect system font scaling; don't rely on color alone; contrast in light & dark mode.
- **Data safety** — atomic writes via drift transactions; export before destructive actions.
- **Small APK**; Android first, iOS-ready.

---

## 11. Edge Cases

### Money & math
- **Float errors** — never raw `double`; integer paise + `decimal`; single rounding rule.
- **Fractional qty & unit mismatch** — 0.5 kg / 250 g of a ₹/kg item converts correctly; qty 0 skips the line; integer-only units reject fractions.
- **Unit conversion within a product** — kg↔g, L↔ml via a canonical unit.
- **Override vs. auto-calc** — after a manual `line_price`, changing qty asks before clobbering (`is_price_overridden`).

### Dates & analytics
- **Month/timezone boundaries** — UTC storage, local-month bucketing; midnight/end-of-month/leap-year safe.
- **First / empty month** — no divide-by-zero on % change → "no prior data".
- **Partial current month** — labelled "so far"; skipped months render as ₹0.
- **Editing a past trip** — recompute that month's total and comparison.
- **Uncategorized items / deleting a category** — real "Uncategorized" bucket; reassign on delete.

### Bilingual data
- **Missing translation** — fallback to the available name; never blank; ≥1 name required.
- **Language switch mid-session** — live re-render; search matches both languages.
- **Tamil rendering & text expansion** — Noto Sans Tamil; flexible layouts (no fixed-width English-length buttons).
- **Numerals & dates** — Indian lakh grouping; Western digits for prices (configurable); DD/MM dates; `intl` plurals.

### Trip / list lifecycle
- **Partial shopping** — trip total counts only bought items; prompt to carry over unbought items *(decision: carry over / stay / drop)*.
- **Off-list purchases** — quick-add during shopping.
- **Abandon/resume** — mid-trip state persists.
- **Deleting a list with an expense** — confirm; decide retain vs remove (affects past analytics) *(decision)*.
- **Recurring/template lists** — duplicate/save-as-template for monthly shopping.

### Data integrity & storage
- **Deleting/editing a catalog product** — never rewrites past snapshots (soft-delete + `SET NULL`).
- **Duplicates** — offer merge/increment-qty instead of silent duplicates.
- **Atomicity** — multi-row writes wrapped in drift transactions.
- **Migrations** — drift migration strategy from v1; recovery path on failure/corruption.
- **Storage full / clock change / duplicate import** — clear errors; rely on stored UTC; version-checked, idempotent import.

### Accessibility, UX & concurrency
- **Font scaling / color-blind / screen readers** — scalable theme text; icon+label states; localized semantic labels.
- **BLoC concurrency** — debounce double-tap add, serialize rapid check/uncheck, debounce search, await in-flight saves.
- **Empty states** — friendly first-run guidance (seed catalog helps).
- **Backup/data loss** — CSV/JSON export; warn uninstall = data loss.

---

## 12. Roadmap / Future

- **Store-aware pricing & shop comparison** (additive: `stores` + `product_prices` + `store_id`).
- **Price history per product** charts.
- **Category spend breakdown** charts.
- **Firebase sync + accounts**; list sharing.
- **Budgets & alerts**; barcode scan; outlier detection (median vs mean).

---

## 13. Open Questions

- Partial-shopping behaviour: carry over / keep / drop unbought items? *(recommend: prompt to carry over)*
- Deleting a list with an expense: retain or remove the expense record?
- "Trip" = exactly one list, or can a list span multiple trips?
- Seed catalog: which ~30–50 common Tamil household items to ship?
- Number display: Western digits always, or Tamil numerals as an option?

---

## 14. Suggested Build Milestones

1. **M0 — Scaffold:** Flutter project, feature folders, `core/theme` + `core/widgets`, drift DB, DI, l10n (en/ta), BilingualText + PriceText.
2. **M1 — Catalog:** products/categories CRUD, base price/unit, auto-calc, seed data.
3. **M2 — Lists & shopping:** create lists, add from catalog/ad-hoc, shopping mode, running total.
4. **M3 — Expenses:** finish-trip → expense (snapshot + transaction), trip history.
5. **M4 — Analytics:** monthly summary + month-over-month chart.
6. **M5 — Settings & polish:** language toggle, currency, export, clear-data, accessibility, empty states.
