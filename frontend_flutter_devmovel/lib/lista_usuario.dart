import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Usuario {
  final int id;
  final String nome;
  final String email;

  Usuario({required this.id, required this.nome, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['ID_USUARIO'],
      nome: json['NOME'],
      email: json['EMAIL'],
    );
  }
}

class ListaUsuarioScreen extends StatefulWidget {
  const ListaUsuarioScreen({Key? key}) : super(key: key);

  @override
  _ListaUsuarioScreenState createState() => _ListaUsuarioScreenState();
}

class _ListaUsuarioScreenState extends State<ListaUsuarioScreen> {
  late Future<List<Usuario>> _usuarios;

  Future<List<Usuario>> _getUsuarios() async {
    final response = await http.get(Uri.parse('http://localhost:3010/api/usuario'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Usuario.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar os usuários');
    }
  }

  @override
  void initState() {
    super.initState();
    _usuarios = _getUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Lista de Usuários',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<Usuario>>(
          future: _usuarios,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(snapshot.data![index].nome),
                      subtitle: Text(snapshot.data![index].email),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaUsuarioScreen(),
  ));
}
