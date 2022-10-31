import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './secondController.dart';

Future<List<PokemonData>> fetchPokemonData() async {
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));
  var data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (data['results'] as List)
      .map((p) => PokemonData.fromJson(p))
      .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class PokemonData {
  final String name;
  final String url;

  const PokemonData({
    required this.name,
    required this.url,
  });

  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return PokemonData(
      name: json['name'],
      url: json['url'],
    );
  }
}

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});
  
  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late Future<List<PokemonData>> pokemonData;

  @override
  void initState() {
    super.initState();
    pokemonData = fetchPokemonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokéflutter'),
      ),
      body: Center(
          child: FutureBuilder<List<PokemonData>>(
            future: pokemonData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.length, // <-- required
                  itemBuilder: (_, index) => Container(
                    margin: const EdgeInsets.all(5),
                    color: Colors.grey,
                    child: InkWell(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PokemonDetail(urlPokemon: snapshot.data![index].url)),
                        );
                      }),
                      child: Center(
                        child: Text(snapshot.data?[index].name ?? "got null"),
                      ),
                    )
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
    );
  }
}