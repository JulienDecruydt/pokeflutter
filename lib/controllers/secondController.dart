import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './mainController.dart';

Future<Pokemon> fetchPokemon(url) async {
  final response = await http
      .get(Uri.parse(url));
  var data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Pokemon.fromJson(data);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Pokemon {
  final String name;
  final int id;
  final String image;

  const Pokemon({
    required this.name,
    required this.id,
    required this.image,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      image: json['sprites']['front_default']
    );
  }
}

class PokemonDetail extends StatefulWidget {
  const PokemonDetail({super.key, required this.urlPokemon});

  final String urlPokemon;

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late Future<Pokemon> _pokemon;

  @override
  void initState() {
    super.initState();
    _pokemon = fetchPokemon(widget.urlPokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokéflutter'),
      ),
      body: FutureBuilder(
        future: _pokemon,
        builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(image: NetworkImage(snapshot.data?.image ?? '')),
                  Row(children: [
                    Column(
                      children: [
                        Text(snapshot.data?.name ?? "got null"),
                        Text(snapshot.data?.name ?? "got null")
                      ]
                    )
                  ],)
                ],
              );
            } else {
              return Text('Loading...');
            }
        },
      )
    );
  }
}