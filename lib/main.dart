import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './models/Quote.dart';

Future<Quote> fetchQuote() async {
  final response = await http.get(Uri.parse('https://api.quotable.io/random'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Quote.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Quote');
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Quote> futureQuote;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _refreshQuote() {
    futureQuote = fetchQuote();
    _incrementCounter();
  }

  @override
  void initState() {
    super.initState();
    futureQuote = fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('\'Morning Quote !'),
        ),
        body: Center(
          child: FutureBuilder<Quote>(
            future: futureQuote,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(snapshot.data!.content,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 2.0)),
                    Text(snapshot.data!.author),
                    if (_counter > 0) Text('Refreshed $_counter times'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _refreshQuote,
          tooltip: 'Increment',
          child: const Icon(Icons.sync),
        ),
      ),
    );
  }
}
