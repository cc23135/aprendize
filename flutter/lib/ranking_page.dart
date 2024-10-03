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
  int selectedColecao = 1; // Inicialmente seleciona o índice 1 (ou outro valor padrão)
  
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
      final response = await http.get(Uri.parse(
          'http://localhost:6060/api/rankingUsers?idColecao=$selectedColecao&comBaseEmTempo=$comBaseEmTempo'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          rankings = data.map((item) => UserRanking.fromJson(item)).toList();
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
                  //child: const Text('Botão 1'),
                ),
                items: List.generate(
                  20,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Opção ${index + 1}'),
                  ),
                  //child: const Text('Botão 2'),
                ),
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
                          return Container(
                            color: user.isMainUser
                                ? Colors.blue.withOpacity(0.1)
                                : null,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePicture),
                              ),
                              title: Text(user.name),
                              subtitle: Text('${user.points} pontos'),
                              trailing: Text('#${user.position}'),
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
    required this.position,
    required this.name,
    required this.points,
    required this.profilePicture,
    this.isMainUser = false,
  });

  final int position;
  final String name;
  final int points;
  final String profilePicture;
  final bool isMainUser;

  factory UserRanking.fromJson(Map<String, dynamic> json) {
    // Convert qtoTempo para um valor numérico de pontos, se necessário
    final qtoTempo = json['qtoTempo'] is String
        ? _parseTempoToPoints(json['qtoTempo'])
        : 0;

    return UserRanking(
      position: json['position'],
      name: json['user']['nome'],
      points: qtoTempo > 0 ? qtoTempo : json['qtosExercicios'],
      profilePicture: json['user']['linkFotoDePerfil'],
      isMainUser: json['idUsuario'] == 1, // Supondo que o usuário com ID 1 é o principal
    );
  }

  static int _parseTempoToPoints(String tempo) {
    // Lógica para converter a string de tempo em pontos
    // Isso deve ser ajustado conforme a lógica de negócios real
    return 0; // Ajuste isso conforme necessário
  }
}
