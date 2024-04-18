import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Atividade {
  final int id;
  final String titulo;
  final String descricao;
  final String data;

  Atividade({required this.id, required this.titulo, required this.descricao, required this.data});

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['ID_ATIVIDADE'],
      titulo: json['TITULO'],
      descricao: json['DESC'],
      data: json['DATA'],
    );
  }
}

class ListaAtividadeScreen extends StatefulWidget {
  const ListaAtividadeScreen({Key? key}) : super(key: key);

  @override
  _ListaAtividadeScreenState createState() => _ListaAtividadeScreenState();
}

class _ListaAtividadeScreenState extends State<ListaAtividadeScreen> {
  late Future<List<Atividade>> _atividades;

  Future<List<Atividade>> _getAtividades() async {
    final response = await http.get(Uri.parse('http://localhost:3010/api/atividade'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Atividade.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar as atividades');
    }
  }

  @override
  void initState() {
    super.initState();
    _atividades = _getAtividades();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Lista de Atividades',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<Atividade>>(
          future: _atividades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(snapshot.data![index].titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].descricao),
                          Text('Data: ${snapshot.data![index].data}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Nenhuma atividade encontrada.'),
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaAtividadeScreen(),
  ));
}
