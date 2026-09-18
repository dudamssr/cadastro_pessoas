import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  bool _carregandoCep = false;

  Future<void> _buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');
    if (cepLimpo.length != 8) return;

    setState(() => _carregandoCep = true);

    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['erro'] == null) {
          setState(() {
            _ruaController.text = data['logradouro'] ?? '';
            _bairroController.text = data['bairro'] ?? '';
            _cidadeController.text = data['localidade'] ?? '';
            _estadoController.text = data['uf'] ?? '';
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CEP não encontrado! Pode preencher manualmente.')),
            );
          }
        }
      }
    } catch (_) {
      // Falha de conexão/CORS no Chrome
    } finally {
      setState(() => _carregandoCep = false);
    }
  }

  Future<void> _salvar() async {
    if (_nomeController.text.trim().isEmpty ||
        _cepController.text.trim().isEmpty ||
        _ruaController.text.trim().isEmpty ||
        _bairroController.text.trim().isEmpty ||
        _cidadeController.text.trim().isEmpty ||
        _estadoController.text.trim().isEmpty ||
        _numeroController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios (exceto complemento)!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? dadosJson = prefs.getString('pessoas_cadastradas');
    List<dynamic> lista = dadosJson != null ? jsonDecode(dadosJson) : [];

    lista.add({
      'nome': _nomeController.text,
      'cep': _cepController.text,
      'rua': _ruaController.text,
      'bairro': _bairroController.text,
      'cidade': _cidadeController.text,
      'estado': _estadoController.text,
      'numero': _numeroController.text,
      'complemento': _complementoController.text,
    });

    await prefs.setString('pessoas_cadastradas', jsonEncode(lista));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre-se'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildField(_nomeController, 'Nome:'),
            _buildField(_cepController, 'CEP:', onChanged: (val) {
              if (val.replaceAll(RegExp(r'\D'), '').length == 8) {
                _buscarCep(val);
              }
            }),
            if (_carregandoCep) const LinearProgressIndicator(),
            // Agora readOnly foi alterado para false, permitindo digitação manual!
            _buildField(_ruaController, 'Rua:'),
            _buildField(_bairroController, 'Bairro:'),
            _buildField(_cidadeController, 'Cidade:'),
            _buildField(_estadoController, 'Estado:'),
            _buildField(_numeroController, 'Número:'),
            _buildField(_complementoController, 'Complemento (Opcional):'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _salvar,
                child: const Text('Salvar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}