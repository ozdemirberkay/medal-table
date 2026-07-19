import 'package:flutter/material.dart';
import 'package:medal_table/medal_table.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medal Table Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MedalTableExamplePage(),
    );
  }
}

class MedalTableExamplePage extends StatelessWidget {
  const MedalTableExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medal Table'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: MedalTable(
          leadingTitle: 'Rank',
          labelTitle: 'Team',
          valueTitle: 'UCL Titles',
          // Just pass the data — the table ranks and medals it for you.
          sortByValue: true,
          showTrend: true,
          oddRowColor: const Color(0x11091442),
          headerDecoration: BoxDecoration(
            color: const Color(0xff091442),
            borderRadius: BorderRadius.circular(6),
          ),
          headerTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xff6594C0),
          ),
          itemTextStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xff091442),
          ),
          items: [
            const TableItemModel(
              title: 'Real Madrid',
              value: 15,
              trend: TrendDirection.same,
            ),
            const TableItemModel(
              title: 'Milan',
              value: 7,
              trend: TrendDirection.up,
            ),
            const TableItemModel(
              title: 'Liverpool',
              value: 6,
              trend: TrendDirection.down,
            ),
            // Beyond the top three, rows get a numbered badge automatically.
            TableItemModel(
              title: 'Bayern',
              value: 6,
              trend: TrendDirection.up,
              highlightColor: Colors.amber.withValues(alpha: 0.25),
              onItemPressed: () => debugPrint('Bayern tapped'),
            ),
            const TableItemModel(title: 'Barcelona', value: 5),
          ],
        ),
      ),
    );
  }
}
