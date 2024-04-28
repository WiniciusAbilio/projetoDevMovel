import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioAtividade {
  final int idUsuario;
  final int idAtividade;
  String dataEntrega;
  double nota;

  UsuarioAtividade({
    required this.idUsuario,
    required this.idAtividade,
    required this.dataEntrega,
    required this.nota,
  });

  factory UsuarioAtividade.fromJson(Map<String, dynamic> json) {
    return UsuarioAtividade(
      idUsuario: json['USUARIO.ID'],
      idAtividade: json['ATIVIDADE.ID'],
      dataEntrega: json['DATA_ENTREGA'],
      nota: json['NOTA'].toDouble(),
    );
  }

  void atualizarDataEntrega(String novaDataEntrega) {
    this.dataEntrega = novaDataEntrega;
  }

  void atualizarNota(double novaNota) {
    this.nota = novaNota;
  }
}

class ListaUsuarioAtividadeScreen extends StatefulWidget {
  const ListaUsuarioAtividadeScreen({Key? key}) : super(key: key);

  @override
  _ListaUsuarioAtividadeScreenState createState() =>
      _ListaUsuarioAtividadeScreenState();
}

class _ListaUsuarioAtividadeScreenState
    extends State<ListaUsuarioAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<UsuarioAtividade>> _usuariosAtividades;
  late final Map<int, bool> _isEditing = {};

  void startEditing(int id) {
    setState(() {
      _isEditing[id] = true;
    });
  }

  void stopEditing(int id) {
    setState(() {
      _isEditing[id] = false;
    });
    _usuariosAtividades =
        _getUsuariosAtividades(); // Atualiza a lista de atividades ao cancelar a edição
  }

  Future<List<UsuarioAtividade>> _getUsuariosAtividades() async {
    final response = await http
        .get(Uri.parse('http://localhost:3010/api/usuario_atividade'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => UsuarioAtividade.fromJson(data))
          .toList();
    } else {
      throw Exception('Falha ao carregar os usuarios e atividades');
    }
  }

  @override
  void initState() {
    super.initState();
    _usuariosAtividades = _getUsuariosAtividades();
  }

  void editarUsuarioAtividade(UsuarioAtividade usuarioAtividade) {
    startEditing(usuarioAtividade.idUsuario);
  }

  void _showSnackBarMessage(String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void removerUsuarioAtividade(int idUsuario, int idAtividade) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3010/api/usuario_atividade/$idUsuario/$idAtividade'));
      if (response.statusCode == 200) {
        setState(() {
          _usuariosAtividades = _getUsuariosAtividades();
        });
        _showSnackBarMessage('Usuário e Atividade removido com sucesso',
            backgroundColor: Colors.green);
      } else {
        _showSnackBarMessage('Erro ao remover Usuário e Atividade ');
      }
    } catch (error) {
      print('Erro ao fazer requisição DELETE: $error');
      _showSnackBarMessage('Erro ao fazer requisição DELETE');
    }
  }

  void salvarEdicao(UsuarioAtividade usuarioAtividade) async {
    print('Salvando edição do usuário e atividade ${usuarioAtividade.idUsuario} - ${usuarioAtividade.idAtividade}');

    final Uri uri = Uri.parse(
        'http://localhost:3010/api/usuario_atividade/${usuarioAtividade.idUsuario}/${usuarioAtividade.idAtividade}');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'dataEntrega': usuarioAtividade.dataEntrega,
      'nota': usuarioAtividade.nota,
    };

    try {
      final response =
          await http.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        print('Dados do usuário atualizados com sucesso');
        setState(() {
          _usuariosAtividades =
              _getUsuariosAtividades(); // Atualiza a lista de usuários
        });
        stopEditing(usuarioAtividade.idUsuario);
        _showSnackBarMessage('Dados do usuário atualizados com sucesso',
            backgroundColor: Colors.green);
      } else {
        final dynamic responseData = json.decode(response.body);
        final String errorMessage = responseData['erro'];
        print('Falha ao atualizar dados do usuário: $errorMessage');
        _showSnackBarMessage(errorMessage, backgroundColor: Colors.red);
      }
    } catch (error) {
      print('Erro ao fazer requisição PUT: $error');
      _showSnackBarMessage('Erro ao fazer requisição PUT',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Lista de Usuários e Atividades',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<UsuarioAtividade>>(
          future: _usuariosAtividades,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final usuarioAtividade = snapshot.data![index];
                  final isEditing = _isEditing.containsKey(usuarioAtividade) &&
                      _isEditing[usuarioAtividade] == true;

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: isEditing
                        ? _buildEditableUsuario(usuarioAtividade)
                        : _buildStaticUsuario(usuarioAtividade),
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

  Widget _buildStaticUsuario(UsuarioAtividade usuarioAtividade) {
    // Converter a data de entrega para um objeto DateTime
    DateTime dataEntrega = DateTime.parse(usuarioAtividade.dataEntrega);

    // Formatar a data no formato desejado
    String formattedDate =
        '${dataEntrega.day.toString().padLeft(2, '0')}/${dataEntrega.month.toString().padLeft(2, '0')}/${dataEntrega.year}';

    return ListTile(
      title: Text(
          'ID Usuário: ${usuarioAtividade.idUsuario.toString()} | ID Atividade: ${usuarioAtividade.idAtividade.toString()}'),
      subtitle: Text(
          'Nota: ${usuarioAtividade.nota.toString()} | Data de Entrega: $formattedDate'),
      trailing: Wrap(
        spacing: 8,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editarUsuarioAtividade(usuarioAtividade);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removerUsuarioAtividade(usuarioAtividade.idUsuario, usuarioAtividade.idAtividade);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditableUsuario(UsuarioAtividade usuarioAtividade) {
    TextEditingController dataEntregaController =
        TextEditingController(text: usuarioAtividade.dataEntrega);
    TextEditingController notaController =
        TextEditingController(text: usuarioAtividade.nota.toString());

    return Form(
      key: _formKey, // Define the form key
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: dataEntregaController,
            decoration: InputDecoration(labelText: 'Data de Entrega'),
            onChanged: (value) {
              usuarioAtividade.atualizarDataEntrega(value);
            },
          ),
          TextFormField(
            controller: notaController,
            decoration: InputDecoration(labelText: 'Nota'),
            onChanged: (value) {
              usuarioAtividade.atualizarNota(double.parse(value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma nota';
              }
              // Additional validation can be performed here
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform the saving logic here
                    salvarEdicao(usuarioAtividade);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 34, 221, 9),
                ),
                child: Text('Salvar'),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  stopEditing(usuarioAtividade.idUsuario);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 207, 9, 9),
                ),
                child: Text('Cancelar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListaUsuarioAtividadeScreen(),
  ));
}
