import 'dart:convert';

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
  final _confirmSenhaController =
      TextEditingController(); // New controller for confirm password

  bool _obscurePassword = true; // To toggle password visibility

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showSnackBarMessage(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _cadastrarUsuario() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;
    final confirmSenha = _confirmSenhaController.text;

    if (senha != confirmSenha) {
      _showSnackBarMessage(context, "As senhas não coincidem");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3010/api/usuario'),
        body: {'nome': nome, 'email': email, 'senha': senha},
      );

      final jsonResponse = json.decode(response.body);

      // Verificar o status da resposta
      if (response.statusCode == 200) {
        final message = jsonResponse['message'] as String;
        print('Usuário vinculado à atividade com sucesso');
        _showSnackBarMessage(context, message, backgroundColor: Colors.green);
      } else {
        final errorMessage = jsonResponse['erro'] as String;
        print('Erro ao vincular usuário à atividade: $errorMessage');
        _showSnackBarMessage(context, errorMessage,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print('Erro durante a solicitação: $e');
      _showSnackBarMessage(context, 'Erro durante a solicitação: $e',
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
          'Cadastro de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.2,
          horizontal: screenWidth * 0.1,
        ),
        child: Center(
          child: SizedBox(
            width: screenWidth * 0.8,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email';
                      }
                      final emailRegExp =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: _obscurePassword, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      // Additional password validation can be added here
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextFormField(
                    controller: _confirmSenhaController,
                    obscureText: _obscurePassword, // Toggle password visibility
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme a senha';
                      }
                      // Additional password validation can be added here
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cadastrarUsuario();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
