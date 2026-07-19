
# Medal Table

A customizable ranking ("medal") table for Flutter. Give it a list of items and
it ranks them — gold, silver and bronze medals for the top three, numbered
badges for the rest — with optional sorting, highlighting, trends and more.

## Samples
<img width="324.33" height="250.66" alt="ucl" src="https://github.com/user-attachments/assets/6765bae7-3e1d-4a24-8579-3316fdcf26c1" />
<img width="324.33" height="230" alt="olympics" src="https://github.com/user-attachments/assets/c0e2ed7d-351f-4aae-80c5-cf6d25295d42" />
<img width="324.33" height="220" alt="imdb" src="https://github.com/user-attachments/assets/60b73c89-312a-4ac7-8d4b-ed916ed6fd5c" />


## Usage

```dart
import 'package:medal_table/medal_table.dart';

MedalTable(
  leadingTitle: 'Rank',
  labelTitle: 'Team',
  valueTitle: 'UCL Titles',
  sortByValue: true, // rank rows by value automatically
  headerDecoration: BoxDecoration(
    color: const Color(0xff091442),
    borderRadius: BorderRadius.circular(6),
  ),
  headerTextStyle: const TextStyle(fontSize: 18, color: Color(0xff6594C0)),
  itemTextStyle: const TextStyle(fontSize: 16, color: Color(0xff091442)),
  items: const [
    TableItemModel(title: 'Real Madrid', value: 15),
    TableItemModel(title: 'Milan', value: 7),
    TableItemModel(title: 'Liverpool', value: 6),
    TableItemModel(title: 'Bayern', value: 6), // 4th place → numbered badge
  ],
);
```

## Features

| Feature | How |
| --- | --- |
| Any number of rows | `items: List<TableItemModel>` |
| Auto sorting | `sortByValue: true`, `descending: true` |
| Multiple value columns | `valueTitles: [...]` + `TableItemModel.values` |
| Highlight a row | `TableItemModel(highlightColor: ...)` |
| Alternating row colors | `oddRowColor` / `evenRowColor` |
| Trend arrows | `showTrend: true` + `TableItemModel.trend` |
| Custom medal colors | `medalColors: [...]` |
| Column widths | `leadingFlex` / `labelFlex` / `valueFlex` |
| Scroll with fixed header | `maxHeight: ...` |
| Row tap | `TableItemModel(onItemPressed: ...)` |

### Multiple value columns (e.g. an Olympic medal table)

```dart
MedalTable(
  leadingTitle: 'Rank',
  labelTitle: 'Country',
  valueTitle: 'Total', // ignored when valueTitles is set
  valueTitles: const ['Gold', 'Silver', 'Bronze'],
  sortByValue: true,
  items: const [
    TableItemModel(title: 'USA', value: 40, values: [40, 44, 42]),
    TableItemModel(title: 'China', value: 38, values: [38, 32, 19]),
  ],
);
```

## Installation
[Installing](https://pub.dev/packages/medal_table/install)

## Migrating from 2.x

`firstItem` / `secondItem` / `thirdItem` are replaced by a single `items` list,
and the API is now exported from one file:

```dart
// Before (2.x)
import 'package:medal_table/view/medal_table.dart';
MedalTable(
  firstItem: TableItemModel(title: 'Real Madrid', value: 15),
  secondItem: TableItemModel(title: 'Milan', value: 7),
  thirdItem: TableItemModel(title: 'Liverpool', value: 6),
  // ...
);

// After (3.0)
import 'package:medal_table/medal_table.dart';
MedalTable(
  items: const [
    TableItemModel(title: 'Real Madrid', value: 15),
    TableItemModel(title: 'Milan', value: 7),
    TableItemModel(title: 'Liverpool', value: 6),
  ],
  // ...
);
```
