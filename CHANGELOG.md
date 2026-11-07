## 3.1.0

### Added
* `sharedRanks` — tied rows share a rank (1, 2, 3, 3, 5), and with it a medal.
* `trendUpColor` / `trendDownColor` / `trendSameColor` to color the trend arrows.
* `semanticsLabelBuilder` to customize or localize each row's screen-reader label.
* `clear…` flags on `TableItemModel.copyWith` (e.g. `clearHighlightColor: true`)
  to remove optional fields.
* `topics` in the pubspec for pub.dev discoverability.

### Changed
* `valueTitle` is now optional; it isn't needed when `valueTitles` is set.
* `sortByValue` breaks ties on `value` by comparing `values` column by column,
  so a multi-column table (gold → silver → bronze) sorts without a `value`.
* Rows without a value are always ranked last, in both sort directions.
* `medalColors` may contain fewer than three colors; only that many ranks get a medal.
* Alternating row colors follow the row position instead of the rank.
* With `maxHeight`, rows are built lazily, so long tables stay fast.
* Numbered badges and the "same" trend marker use the theme's `ColorScheme`
  and adapt to dark mode.
* The default screen-reader label mentions the trend when `showTrend` is on.
* Minimum SDK is now Dart 3.8 / Flutter 3.32 (was Dart 3.9 with a mismatched
  `flutter: >=1.17.0` constraint).
* Upgraded `flutter_lints` to 6.0.0.
* Example uses `ColorScheme.fromSeed` instead of the Material 2 `primarySwatch`.

### Fixed
* The tap ripple is no longer hidden behind highlighted or colored rows.
* Screen readers no longer read each row twice; tappable rows expose a tap action.
* Rows with equal values keep their original order when sorted (tables longer
  than 32 rows could previously shuffle them).
* Mismatched `values` / `valueTitles` lengths now raise a clear debug error
  instead of silently misaligning the columns.

## 3.0.0
> **Breaking change.** The table now takes an `items` list instead of the three
> fixed `firstItem` / `secondItem` / `thirdItem` parameters, and the public API
> is now exported from a single `package:medal_table/medal_table.dart` barrel.

### Added
* **Dynamic rows** — pass any number of items via `items: List<TableItemModel>`.
  The top three ranks get gold/silver/bronze medals; the rest get a numbered badge.
* **Auto sorting** — `sortByValue` (with `descending`) ranks rows for you.
* **Multiple value columns** — `valueTitles` + `TableItemModel.values`.
* **Row highlighting** via `TableItemModel.highlightColor`.
* **Alternating row colors** via `oddRowColor` / `evenRowColor`.
* **Trend indicators** — `showTrend` + `TableItemModel.trend` (up/down/same).
* **Customizable medal colors** via `medalColors`.
* **Configurable column widths** — `leadingFlex` / `labelFlex` / `valueFlex`.
* **Scrollable body** with a fixed header via `maxHeight`.
* `rowSpacing`, `rowDecoration` and `itemPadding` styling options.
* Ripple feedback on tappable rows (`InkWell`) and `Semantics` for accessibility.
* Widget and unit tests.

### Changed
* `TableItemModel` is now immutable with a `const` constructor and gained
  `copyWith`, value equality (`==` / `hashCode`) and `toString`.
* Restructured sources under `lib/src/`; import the barrel instead of internal paths.

### Removed
* The mutable global `defaultMedalLeading` list (replaced by `medalColors`).

## 2.0.1
* Updated readme and example

## 2.0.0
* Updated model

## 1.0.4
* UI improvements

## 1.0.3
* Header improvements

## 1.0.2
* Header bug fixed

## 1.0.1
* Package usage example added

## 1.0.0
* Stable version released and bugs fixed

## 0.0.1
* First initial release.
