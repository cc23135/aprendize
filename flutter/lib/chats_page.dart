import 'dart:convert';
import 'package:aprendize/AppStateSingleton.dart';
import 'package:aprendize/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'criar_colecao_page.dart';
import 'colecao_page.dart';
import 'colors.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _colecoes = [];

  Future<void> _fetchColecoes() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getColecoes');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _colecoes = List<Map<String, dynamic>>.from(data['colecoes']);
      });
    } else {
      throw Exception('Falha ao carregar coleções');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchColecoes();
  }

  List<Map<String, dynamic>> get _filteredColecoes {
    final query = _searchController.text.toLowerCase();
    return _colecoes.where((colecao) {
      return colecao['nome'].toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Suas Coleções',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CriarColecaoPage()),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Digite o nome da coleção',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredColecoes.length,
                itemBuilder: (context, index) {
                  final colecao = _filteredColecoes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(colecao['linkImagem']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          AppColors.darkPurple.withOpacity(0.4), // Altere para AppColors.lightPurple quando disponível
                          BlendMode.darken,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        colecao['nome'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${colecao['numEstudantes']} estudantes',
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(Icons.chat, color: Colors.white),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailsPage(
                              idColecao: colecao['idColecao'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class Colecao {
  Colecao({
    required this.nome,
    required this.numEstudantes,
  });

  final String nome;
  final int numEstudantes;
}
