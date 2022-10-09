import 'package:flutter/material.dart';
import 'package:medal_table/medal_table.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medal Table Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medal Table"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff6594C0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: MedalTable(
              headerDecoration: BoxDecoration(
                color: const Color(0xff091442),
                borderRadius: BorderRadius.circular(8),
              ),
              firstLabel: "Real Madrid",
              secondLabel: "Milan",
              thirdLabel: "Liverpool",
              labelTitle: "Team",
              leadingTitle: "Rank",
              valueTitle: "UCL Title",
              firstValue: "14",
              secondValue: "7",
              thirdValue: "6",
              textStyle: const TextStyle(
                fontSize: 17,
                color: Color(0xff091442),
              ),
              headerTextStyle: const TextStyle(
                fontSize: 20,
                color: Color(0xff6594C0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
