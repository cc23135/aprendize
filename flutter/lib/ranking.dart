import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<UserRanking> rankings = [];
  bool isLoading = true;
  bool comBaseEmTempo = true; // Define se é baseado em tempo ou não
  int selectedColecao = 0;

  @override
  void initState() {
    super.initState();
    _fetchRanking(); // Carregar o ranking inicialmente
  }

  Future<void> _fetchRanking() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(AppStateSingleton().apiUrl +
          'api/rankingUsers?idColecao=$selectedColecao&comBaseEmTempo=$comBaseEmTempo'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('veio');
        setState(() {
          rankings = data
              .map((item) => UserRanking.fromJson(item, comBaseEmTempo))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load rankings');
      }
    } catch (e) {
      print('Error fetching rankings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onDropdownChanged(int? newValue) {
    setState(() {
      selectedColecao = newValue ?? 1;
      _fetchRanking(); // Atualiza o ranking ao mudar a coleção
    });
  }

  void _onFilterChanged(bool value) {
    setState(() {
      comBaseEmTempo = value;
      _fetchRanking(); // Atualiza o ranking com base na nova opção
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtendo as coleções do AppStateSingleton
    final collections = AppStateSingleton().collections;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              child: DropdownButtonFormField<int>(
                value: selectedColecao,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  DropdownMenuItem<int>(
                    value: 0, // Valor para "Todos"
                    child: const Text('Todos'),
                  ),
                  ...List.generate(
                    collections.length,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1, // Ajuste o valor conforme a coleção
                      child: Text(collections[index][
                          'nome']), // Supondo que 'nome' é a chave para o nome da coleção
                    ),
                  ),
                ],
                onChanged: _onDropdownChanged,
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ranking dos Usuários',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _onFilterChanged(true),
                  child: const Text('Ordenar por Tempo'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _onFilterChanged(false),
                  child: const Text('Ordenar por Exercícios'),
                ),
              ],
            ),
            const SizedBox(height: 20),
Expanded(
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              final user = rankings[index];

              // Define a cor de fundo com base na posição
              Color backgroundColor;
              if (index == 0) {
                backgroundColor = Colors.amber.withOpacity(0.3); // Dourado
              } else if (index == 1) {
                backgroundColor = Colors.grey.withOpacity(0.3); // Prata
              } else if (index == 2) {
                backgroundColor = Colors.brown.withOpacity(0.3); // Bronze
              } else {
                backgroundColor = Colors.transparent; // Fundo padrão
              }

              return Container(
                color: backgroundColor, // Aplica a cor de fundo
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicture),
                  ),
                  title: Text(user.name),
                  subtitle: comBaseEmTempo
                      ? Text('${(user.qtoTempo / 3600).toStringAsFixed(0)} horas estudadas')
                      : Text('${user.qtosExercicios} exercícios feitos'),
                  trailing: Text('#${index + 1}'), // Usando o índice como posição
                  isThreeLine: false,
                ),
              );
            },
          ),
  ),
),

          ],
        ),
      ),
    );
  }
}

class UserRanking {
  UserRanking({
    required this.name,
    required this.qtoTempo,
    required this.qtosExercicios,
    required this.profilePicture,
  });

  final String name;
  final int qtoTempo;
  final int qtosExercicios;
  final String profilePicture;

  factory UserRanking.fromJson(Map<String, dynamic> json, bool comBaseEmTempo) {
    return UserRanking(
      name: json['user']['nome'],
      qtoTempo: json['qtoTempo'],
      qtosExercicios: json['qtosExercicios'],
      profilePicture: json['user']['linkFotoDePerfil'],
    );
  }
}
