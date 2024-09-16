import 'dart:convert';
import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'criar_colecao_page.dart';
import 'colecao_page.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // Controle do texto de pesquisa
  final TextEditingController _searchController = TextEditingController();

  // Lista de coleções (exemplo inicial vazio)
  List<Map<String, dynamic>> _colecoes = [];

  // Função para buscar coleções da API
  Future<void> _fetchColecoes() async {
    final uri = Uri.parse('${AppStateSingleton().ApiUrl}api/getColecoes');
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
    _fetchColecoes(); // Chama a função para buscar coleções quando a página é inicializada
  }

  // Função para filtrar coleções com base no texto de pesquisa
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
              // Título e botão para criar coleção
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Suas Coleções',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CriarColecaoPage()), // Navegação para CriarColecaoPage
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Campo de pesquisa
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
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),
              // Lista de coleções filtradas
              // Lista de coleções filtradas
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Remove a rolagem da lista
                itemCount: _filteredColecoes.length,
                itemBuilder: (context, index) {
                  final colecao = _filteredColecoes[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(colecao['linkImagem']), // URL da imagem de fundo
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.3), // Opacidade para contraste
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        colecao['nome'],
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${colecao['numEstudantes']} estudantes',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.info, color: Colors.white),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailsPage(
                              title: colecao['nome'],
                              students: colecao['numEstudantes'],
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

// Modelo para representar uma coleção (se necessário para outras partes do código)
class Colecao {
  Colecao({
    required this.nome,
    required this.numEstudantes,
  });

  final String nome;
  final int numEstudantes;
}
