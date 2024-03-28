import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroAtividadeScreen extends StatefulWidget {
  const CadastroAtividadeScreen({Key? key}) : super(key: key);

  @override
  _CadastroAtividadeScreenState createState() => _CadastroAtividadeScreenState();
}

class _CadastroAtividadeScreenState extends State<CadastroAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataEntregaController = TextEditingController();
  late DateTime _dataEntrega;

  @override
  void initState() {
    super.initState();
    _dataEntrega = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataEntrega,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataEntrega)
      setState(() {
        _dataEntrega = picked;
        _dataEntregaController.text = _dataEntrega.toString(); // Format as needed
      });
  }

  Future<void> _cadastrarAtividade() async {
    final titulo = _tituloController.text;
    final descricao = _descricaoController.text;
    final dataEntrega = _dataEntrega.toString(); // Use formatted date

    final response = await http.post(
      Uri.parse('http://localhost:3010/api/atividade'),
      body: {'titulo': titulo, 'descricao': descricao, 'dataEntrega': dataEntrega},
    );

    if (response.statusCode == 200) {
      // Sucesso
      print('Atividade cadastrada com sucesso');
    } else {
      // Erro
      print('Erro ao cadastrar atividade: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Cadastro de Atividade',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _descricaoController,
                    maxLines: null, // Permite múltiplas linhas
                    decoration: InputDecoration(
                      labelText: 'Descrição da Atividade',
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dataEntregaController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Data de Entrega',
                            border: OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Icon(Icons.date_range),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cadastrarAtividade();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
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
