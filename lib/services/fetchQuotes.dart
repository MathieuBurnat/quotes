import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/Quote.dart';
import 'dart:convert';

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
