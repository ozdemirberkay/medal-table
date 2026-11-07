import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medal_table/medal_table.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme,
  home: Scaffold(body: child),
);

/// Vertical center of the row titled [title], for checking row order.
double _rowY(WidgetTester tester, String title) =>
    tester.getCenter(find.text(title)).dy;

/// Semantics of the row titled [title], as a screen reader sees it.
SemanticsData _rowSemantics(WidgetTester tester, String title) =>
    tester.getSemantics(find.text(title)).getSemanticsData();

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
              TableItemModel(title: 'A', value: 40),
              TableItemModel(title: 'B', value: 30),
              TableItemModel(title: 'C', value: 20),
              TableItemModel(title: 'D', value: 10),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.looks_one), findsOneWidget);
      expect(find.byIcon(Icons.looks_two), findsOneWidget);
      expect(find.byIcon(Icons.looks_3), findsOneWidget);
      // Fourth place shows a numbered badge, not a medal icon.
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('medalColors limits how many ranks get a medal', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            medalColors: [Color(0xffD4AF37)],
            items: [
              TableItemModel(title: 'A', value: 40),
              TableItemModel(title: 'B', value: 30),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.looks_one), findsOneWidget);
      expect(find.byIcon(Icons.looks_two), findsNothing);
      expect(find.text('2'), findsOneWidget);
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

    testWidgets('tap ripple is painted above the row background', (
      tester,
    ) async {
      const background = Color(0xff123456);
      await tester.pumpWidget(
        _wrap(
          theme: ThemeData(splashFactory: InkRipple.splashFactory),
          MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(
                title: 'Tap me',
                value: 1,
                highlightColor: background,
                onItemPressed: () {},
              ),
            ],
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Tap me')),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // The ripple circle must come after (on top of) the background.
      expect(
        Material.of(tester.element(find.text('Tap me'))),
        paints
          ..rect(color: background)
          ..circle(),
      );

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('renders multiple value columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Country',
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

    testWidgets('mismatched values and valueTitles report an error', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Country',
            valueTitle: 'Total',
            items: [
              TableItemModel(title: 'USA', values: [40, 44, 42]),
            ],
          ),
        ),
      );

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (e) => e.message,
          'message',
          contains('misaligned'),
        ),
      );
    });

    testWidgets('hideHeader only requires rows to match each other', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            hideHeader: true,
            leadingTitle: 'Rank',
            labelTitle: 'Country',
            items: [
              TableItemModel(title: 'USA', values: [40, 44, 42]),
              TableItemModel(title: 'China', values: [38, 32, 19]),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('sorting and ranking', () {
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

      expect(_rowY(tester, 'High'), lessThan(_rowY(tester, 'Mid')));
      expect(_rowY(tester, 'Mid'), lessThan(_rowY(tester, 'Low')));
    });

    testWidgets('equal values keep their original order', (tester) async {
      // Longer than 32 items, where List.sort stops being stable.
      final items = [
        for (var i = 0; i < 40; i++) TableItemModel(title: 'T$i', value: 1),
      ];
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: MedalTable(
              sortByValue: true,
              leadingTitle: 'Rank',
              labelTitle: 'Team',
              valueTitle: 'Titles',
              items: items,
            ),
          ),
        ),
      );

      for (var i = 1; i < 40; i++) {
        expect(_rowY(tester, 'T${i - 1}'), lessThan(_rowY(tester, 'T$i')));
      }
    });

    testWidgets('rows without a value are ranked last in both directions', (
      tester,
    ) async {
      for (final descending in [true, false]) {
        await tester.pumpWidget(
          _wrap(
            MedalTable(
              sortByValue: true,
              descending: descending,
              leadingTitle: 'Rank',
              labelTitle: 'Team',
              valueTitle: 'Titles',
              items: const [
                TableItemModel(title: 'None'),
                TableItemModel(title: 'Low', value: 1),
                TableItemModel(title: 'High', value: 9),
              ],
            ),
          ),
        );

        expect(_rowY(tester, 'Low'), lessThan(_rowY(tester, 'None')));
        expect(_rowY(tester, 'High'), lessThan(_rowY(tester, 'None')));
      }
    });

    testWidgets('values break ties column by column', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            sortByValue: true,
            leadingTitle: 'Rank',
            labelTitle: 'Country',
            valueTitles: ['Gold', 'Silver', 'Bronze'],
            items: [
              TableItemModel(title: 'Third', values: [1, 2, 0]),
              TableItemModel(title: 'Second', values: [1, 3, 0]),
              TableItemModel(title: 'First', values: [2, 0, 0]),
            ],
          ),
        ),
      );

      expect(_rowY(tester, 'First'), lessThan(_rowY(tester, 'Second')));
      expect(_rowY(tester, 'Second'), lessThan(_rowY(tester, 'Third')));
    });

    testWidgets('sharedRanks gives tied rows the same rank and medal', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            sharedRanks: true,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'A', value: 30),
              TableItemModel(title: 'B', value: 20),
              TableItemModel(title: 'C', value: 10),
              TableItemModel(title: 'D', value: 10),
              TableItemModel(title: 'E', value: 1),
            ],
          ),
        ),
      );

      // 1, 2, 3, 3, 5
      expect(find.byIcon(Icons.looks_3), findsNWidgets(2));
      expect(find.text('4'), findsNothing);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('alternating colors follow row position, not rank', (
      tester,
    ) async {
      const odd = Color(0xffff0000);
      const even = Color(0xff0000ff);
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            sharedRanks: true,
            oddRowColor: odd,
            evenRowColor: even,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'A', value: 10),
              TableItemModel(title: 'B', value: 10),
            ],
          ),
        ),
      );

      Finder rowWithColor(Color color) => find.byWidgetPredicate(
        (w) =>
            w is Container && (w.decoration as BoxDecoration?)?.color == color,
      );
      expect(rowWithColor(odd), findsOneWidget);
      expect(rowWithColor(even), findsOneWidget);
    });
  });

  group('maxHeight', () {
    testWidgets('builds rows lazily and keeps the header fixed', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MedalTable(
            maxHeight: 200,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              for (var i = 0; i < 100; i++)
                TableItemModel(title: 'T$i', value: i),
            ],
          ),
        ),
      );

      expect(find.text('T0'), findsOneWidget);
      expect(find.text('T99'), findsNothing);

      await tester.drag(find.byType(ListView), const Offset(0, -10000));
      await tester.pumpAndSettle();

      expect(find.text('T99'), findsOneWidget);
      expect(find.text('Rank'), findsOneWidget);
    });
  });

  group('theming', () {
    testWidgets('numbered badges use the theme colors (dark mode)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          theme: ThemeData(brightness: Brightness.dark),
          const MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'A', value: 40),
              TableItemModel(title: 'B', value: 30),
              TableItemModel(title: 'C', value: 20),
              TableItemModel(title: 'D', value: 10),
            ],
          ),
        ),
      );

      final scheme = Theme.of(tester.element(find.text('4'))).colorScheme;
      final badge = tester.widget<CircleAvatar>(
        find.ancestor(of: find.text('4'), matching: find.byType(CircleAvatar)),
      );
      expect(badge.backgroundColor, scheme.surfaceContainerHighest);
      expect(
        tester.widget<Text>(find.text('4')).style?.color,
        scheme.onSurface,
      );
    });

    testWidgets('trend arrows use the given colors and theme defaults', (
      tester,
    ) async {
      const up = Color(0xff00aa00);
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            showTrend: true,
            trendUpColor: up,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'A', value: 2, trend: TrendDirection.up),
              TableItemModel(title: 'B', value: 1, trend: TrendDirection.same),
            ],
          ),
        ),
      );

      final scheme = Theme.of(tester.element(find.text('A'))).colorScheme;
      expect(tester.widget<Icon>(find.byIcon(Icons.arrow_upward)).color, up);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.remove)).color,
        scheme.outline,
      );
    });
  });

  group('semantics', () {
    testWidgets('each row is announced once, with a tap action if tappable', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          MedalTable(
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(
                title: 'Real Madrid',
                value: 15,
                onItemPressed: () {},
              ),
              const TableItemModel(title: 'Milan', value: 7),
            ],
          ),
        ),
      );

      final tappable = _rowSemantics(tester, 'Real Madrid');
      expect(tappable.label, 'Rank 1, Real Madrid, 15');
      expect(tappable.hasAction(SemanticsAction.tap), isTrue);

      final plain = _rowSemantics(tester, 'Milan');
      expect(plain.label, 'Rank 2, Milan, 7');
      expect(plain.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('default label mentions the trend when shown', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const MedalTable(
            showTrend: true,
            leadingTitle: 'Rank',
            labelTitle: 'Team',
            valueTitle: 'Titles',
            items: [
              TableItemModel(title: 'A', value: 1, trend: TrendDirection.up),
            ],
          ),
        ),
      );

      expect(_rowSemantics(tester, 'A').label, 'Rank 1, A, 1, moving up');
      handle.dispose();
    });

    testWidgets('semanticsLabelBuilder overrides the label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          MedalTable(
            leadingTitle: 'Sıra',
            labelTitle: 'Takım',
            valueTitle: 'Kupa',
            semanticsLabelBuilder: (item, rank) =>
                '$rank. sıra, ${item.title}, ${item.value} kupa',
            items: const [TableItemModel(title: 'Real Madrid', value: 15)],
          ),
        ),
      );

      expect(
        _rowSemantics(tester, 'Real Madrid').label,
        '1. sıra, Real Madrid, 15 kupa',
      );
      handle.dispose();
    });
  });

  group('TableItemModel', () {
    test('copyWith overrides only the given fields', () {
      const original = TableItemModel(title: 'A', value: 1);
      final copy = original.copyWith(value: 2);
      expect(copy.title, 'A');
      expect(copy.value, 2);
    });

    test('copyWith clear flags remove optional fields', () {
      final original = TableItemModel(
        title: 'A',
        value: 1,
        values: const [1, 2],
        highlightColor: const Color(0xff000000),
        leading: const SizedBox(),
        onItemPressed: () {},
      );
      final copy = original.copyWith(
        clearValue: true,
        clearValues: true,
        clearHighlightColor: true,
        clearLeading: true,
        clearOnItemPressed: true,
      );
      expect(copy.title, 'A');
      expect(copy.value, isNull);
      expect(copy.values, isNull);
      expect(copy.highlightColor, isNull);
      expect(copy.leading, isNull);
      expect(copy.onItemPressed, isNull);
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
