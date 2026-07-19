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
