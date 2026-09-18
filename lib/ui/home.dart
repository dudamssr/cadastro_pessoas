import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cadastro.dart';
import 'splash.dart';
import 'style/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> _pessoas = [];

  @override
  void initState() {
    super.initState();
    _carregarPessoas();
  }

  Future<void> _carregarPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dadosJson = prefs.getString('pessoas_cadastradas');
    if (dadosJson != null) {
      final List<dynamic> decoded = jsonDecode(dadosJson);
      setState(() {
        _pessoas =
            decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.modo,
      builder: (context, mode, _) {
        final eEscuro = mode == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Pessoas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    const Text('Tema escuro', style: TextStyle(fontSize: 13)),
                    Switch(
                      value: eEscuro,
                      onChanged: (val) {
                        AppTheme.modo.value =
                            val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: const Text("Sistema de Gestão"),
                  accountEmail: const Text("painel@cadastro.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: const Icon(Icons.person, size: 40),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.flash_on_rounded),
                  title: const Text('Splash'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Splash()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app_rounded),
                  title: const Text('Sair'),
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
          body: _pessoas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 80,
                        color: Theme.of(context).hintColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma pessoa cadastrada.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pessoas.length,
                  itemBuilder: (context, index) {
                    final item = _pessoas[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          child: Text(
                            (item['nome'] ?? 'P')[0].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          item['nome'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text('CEP: ${item['cep'] ?? ''}'),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CadastroScreen()),
              );
              _carregarPessoas();
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
          ),
        );
      },
    );
  }
}