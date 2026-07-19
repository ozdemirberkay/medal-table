import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medal_table/medal_table.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('MedalTable', () {
    testWidgets('renders header titles and every item', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'Real Madrid', value: 15),
              TableItemModel(title: 'Milan', value: 7),
              TableItemModel(title: 'Liverpool', value: 6),
              TableItemModel(title: 'Bayern', value: 6),
            ],
          ),
        ),
      );

      expect(find.text('Rank'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);
      expect(find.text('Titles'), findsOneWidget);
      expect(find.text('Real Madrid'), findsOneWidget);
      expect(find.text('Bayern'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('hideHeader removes the header row', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            hideHeader: true,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [TableItemModel(title: 'Real Madrid', value: 15)],
          ),
        ),
      );

      expect(find.text('Rank'), findsNothing);
      expect(find.text('Real Madrid'), findsOneWidget);
    });

    testWidgets('medals go to the top three, badges to the rest', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'A', value: 4),
              TableItemModel(title: 'B', value: 3),
              TableItemModel(title: 'C', value: 2),
              TableItemModel(title: 'D', value: 1),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.looks_one), findsOneWidget);
      expect(find.byIcon(Icons.looks_two), findsOneWidget);
      expect(find.byIcon(Icons.looks_3), findsOneWidget);
      // Fourth place shows a numbered badge, not a medal icon.
      expect(find.text('4'), findsWidgets);
    });

    testWidgets('sortByValue ranks the highest value first', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            sortByValue: true,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'Low', value: 1),
              TableItemModel(title: 'High', value: 99),
              TableItemModel(title: 'Mid', value: 50),
            ],
          ),
        ),
      );

      final double gold = tester.getCenter(find.text('High')).dy;
      final double silver = tester.getCenter(find.text('Mid')).dy;
      final double bronze = tester.getCenter(find.text('Low')).dy;
      expect(gold, lessThan(silver));
      expect(silver, lessThan(bronze));
    });

    testWidgets('onItemPressed fires when a row is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(
                title: 'Tap me',
                value: 1,
                onItemPressed: () => tapped = true,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('renders multiple value columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Country',
            valueTitle: 'Total',
            valueTitles: ['Gold', 'Silver', 'Bronze'],
            items: [
              TableItemModel(title: 'USA', values: [40, 44, 42]),
            ],
          ),
        ),
      );

      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('Silver'), findsOneWidget);
      expect(find.text('Bronze'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);
      expect(find.text('44'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });
  });

  group('TableItemModel', () {
    test('copyWith overrides only the given fields', () {
      const original = TableItemModel(title: 'A', value: 1);
      final copy = original.copyWith(value: 2);
      expect(copy.title, 'A');
      expect(copy.value, 2);
    });

    test('equality is value-based', () {
      const a = TableItemModel(title: 'A', value: 1);
      const b = TableItemModel(title: 'A', value: 1);
      const c = TableItemModel(title: 'A', value: 2);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });
  });
}
