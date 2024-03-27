import 'package:flutter/material.dart';
import 'cadastro_usuario.dart'; // Importe a tela de cadastro de usuário aqui

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto DevMovel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(), // Definindo MyHomePage como a tela inicial
      routes: {
        '/cadastroUsuario': (context) => const CadastroUsuarioScreen(), // Definindo a rota para a tela de cadastro de usuário
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Define a cor de fundo do AppBar como roxa
        title: Text(
          'Menu',
          style: TextStyle(fontSize: 24, color: Colors.white), // Ajusta o tamanho do texto e a cor para branco
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cadastroUsuario'); // Navegar para a tela de cadastro de usuário ao clicar no botão
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Define a cor de fundo do botão como roxa
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30), // Aumenta o tamanho do botão
          ),
          child: Text(
            'Cadastrar Usuário',
            style: TextStyle(fontSize: 18, color: Colors.white), // Ajusta o tamanho do texto e a cor para branco
          ),
        ),
      ),
    );
  }
}
