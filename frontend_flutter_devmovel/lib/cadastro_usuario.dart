import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({Key? key}) : super(key: key);

  @override
  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _cadastrarUsuario() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;

    final response = await http.post(
      Uri.parse('http://localhost:3010/api/usuario'),
      body: {'nome': nome, 'email': email, 'senha': senha},
    );

    if (response.statusCode == 200) {
      // Sucesso
      print('Usuário cadastrado com sucesso');
    } else {
      // Erro
      print('Erro ao cadastrar usuário: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Define a cor de fundo da barra de navegação
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white), // Define a cor do texto como branco
        ),
        iconTheme: IconThemeData(color: Colors.white), // Define a cor da flecha de voltar como branco
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Define a largura do Container como 80% da largura da tela
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email';
                      }
                      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cadastrarUsuario();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Define a cor de fundo do botão como roxa
                      padding: EdgeInsets.symmetric(vertical: 15), // Define o preenchimento vertical do botão
                    ),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 18, // Ajusta o tamanho do texto
                        color: Colors.white, // Define a cor do texto como branco
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
