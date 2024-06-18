import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cepController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _searchCEP() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/${_cepController.text}/json/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('erro')) {
        _result = 'CEP não encontrado!';
      } else {
        _result = '''
          CEP: ${data['cep']}
          Logradouro: ${data['logradouro']}
          Complemento: ${data['complemento']}
          Bairro: ${data['bairro']}
          Localidade: ${data['localidade']}
          UF: ${data['uf']}
        ''';
      }
    } else {
      _result = 'Erro ao consultar o CEP.';
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          flexibleSpace: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Consulta de CEP - Gustavo Vendrami do Amaral - 18/06/2024',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.green,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              decoration: const InputDecoration(
                labelText: 'CEP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _searchCEP,
              child: const Text('Consultar'),
            ),
            const SizedBox(height: 18),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _result,
                    style: const TextStyle(fontSize: 18),
                  ),
          ],
        ),
      ),
    );
  }
}
