import 'package:flutter/material.dart';
import 'cadastro_usuario.dart' as usuario;
import 'cadastro_atividade.dart' as atividade;
import 'cadastro_usuario_atividade.dart' as usuario_atividade;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
        '/cadastroUsuario': (context) => const usuario.CadastroUsuarioScreen(), // Definindo a rota para a tela de cadastro de usuário
        '/cadastroAtividade': (context) => const atividade.CadastroAtividadeScreen(), // Definindo a rota para a tela de cadastro de atividade
        '/cadastroUsuarioAtividade': (context) => const usuario_atividade.CadastroUsuarioAtividadeScreen(), // Definindo a rota para a tela de cadastro de usuário atividade
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Define a cor de fundo do AppBar como roxa
        title: const Text(
          'Menu',
           style: TextStyle(fontSize: 24, color: Colors.white), // Ajusta o tamanho do texto e a cor para branco
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Define a cor do ícone do menu como branco
        toolbarHeight: 100, // Define a altura da barra de navegação
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Center(
                child: Text(
                  'Opções',
                  style: TextStyle(fontSize: 24, color: Colors.white), // Ajusta o tamanho do texto e a cor para branco
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add), // Ícone de adicionar usuário
              title: const Text('Cadastrar Usuário'),
              onTap: () {
                Navigator.pushNamed(context, '/cadastroUsuario'); // Navegar para a tela de cadastro de usuário ao clicar no item do drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle), // Ícone de adicionar atividade
              title: const Text('Cadastrar Atividade'),
              onTap: () {
                Navigator.pushNamed(context, '/cadastroAtividade'); // Navegar para a tela de cadastro de atividade ao clicar no item do drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add), // Ícone de adicionar usuário atividade
              title: const Text('Cadastrar Usuário Atividade'),
              onTap: () {
                Navigator.pushNamed(context, '/cadastroUsuarioAtividade'); // Navegar para a tela de cadastro de usuário atividade ao clicar no item do drawer
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Conteúdo da página!!!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
