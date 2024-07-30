import 'package:flutter/material.dart';
import 'package:medal_table/model/table_item_model.dart';
import 'package:medal_table/view/medal_table.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medal Table Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MedalTableExamplePage(),
    );
  }
}

class MedalTableExamplePage extends StatelessWidget {
  const MedalTableExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medal Table"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(6),
        child: MedalTable(
          headerDecoration: BoxDecoration(
            color: const Color(0xff091442),
            borderRadius: BorderRadius.circular(6),
          ),
          headerTextStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xff6594C0),
          ),
          labelTitle: "Team",
          leadingTitle: "Rank",
          valueTitle: "UCL Title",
          firstItem: TableItemModel(title: "Real Marid", value: 15),
          secondItem: TableItemModel(title: "Milan", value: 7),
          thirdItem: TableItemModel(title: "Liverpool", value: 6),
          itemTextStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xff091442),
          ),
        ),
      ),
    );
  }
}
