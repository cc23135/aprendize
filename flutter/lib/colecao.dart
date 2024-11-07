import 'dart:convert';
import 'package:aprendize/colors.dart';
import 'package:aprendize/criarColecao.dart';
import 'package:http/http.dart' as http;
import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'members.dart';
import 'materia.dart';

class ChatDetailsPage extends StatefulWidget {
  final int idColecao;

  ChatDetailsPage({super.key, required this.idColecao});

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  Map<String, dynamic>? _colecao;
  int usuarioEstaNessaColecao = 0;

  @override
  void initState() {
    super.initState();
    _fetchColecaoInfo();
  }

  Future<void> _fetchColecaoInfo() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getColecaoInfo');
    final response = await http.post(uri, body: jsonEncode({
      "query": {
        "idColecao": widget.idColecao,
        "idUsuario": AppStateSingleton().idUsuario
      }
    }), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _colecao = Map<String, dynamic>.from(data['colecao']);
        usuarioEstaNessaColecao = int.parse(data['cargo']);
      });
    } else {
      throw Exception('Falha ao carregar coleção');
    }
  }



  Future<void> EntrarNaColecao() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/entrarEmUmaColecao');
    final response = await http.post(
      uri,
      body: jsonEncode({
        "idColecao": widget.idColecao,
        "username": AppStateSingleton().username,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final preData = jsonDecode(response.body);
      final data = preData['data'];

      Map<String, dynamic> newCollection = {
        'idColecao': data['idColecao'],
        'nome': data['nome'],
        'descricao': data['descricao'],
        'linkImagem': data['linkImagem'],
        'idCriador': data['idCriador'],
        'dataCriacao': data['dataCriacao'],
      };

      // Add the new collection to the AppStateSingleton
      AppStateSingleton().collections.add(newCollection);

      setState(() {

        usuarioEstaNessaColecao = 1; 
        _fetchColecaoInfo();
      });
    } else {
      throw Exception('Falha ao entrar na coleção: ${response.statusCode} - ${response.body}');
    }
  }



  Future<void> SairDaColecao() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/sairDeUmaColecao');
    final response = await http.post(
      uri,
      body: jsonEncode({
        "idColecao": widget.idColecao,
        "username": AppStateSingleton().username,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Assuming successful exit means removing the collection from the AppStateSingleton
      AppStateSingleton().collections.removeWhere((collection) => collection['idColecao'] == widget.idColecao);

      setState(() {

        usuarioEstaNessaColecao = 0; 
      });
    } else {
      throw Exception('Falha ao sair da coleção: ${response.statusCode} - ${response.body}');
    }
  }



  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("ID: " + widget.idColecao.toString()),
      actions: [
        if (usuarioEstaNessaColecao > 1) 
          IconButton(
            icon: Icon(Icons.edit), // Ícone de lápis
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CriarColecaoPage(collection: _colecao), 
                ),
              );
            },
          ),
      ],
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _colecao == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Adicionado
              child: Column( // Mantido
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      _colecao!["linkImagem"],
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '${_colecao!["nome"] ?? "..."}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_colecao!["descricao"] ?? "..."}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        if(usuarioEstaNessaColecao == 0) ...[ 
                          ElevatedButton(
                            onPressed: () {
                              EntrarNaColecao();
                            },
                            child: const Text('Entrar no grupo'),
                          ),
                          const SizedBox(height: 20),
                        ],

                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MembersPage(idColecao: widget.idColecao),
                              ),
                            );
                          },
                          child: const Text('Ver Membros'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Matérias',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: _colecao != null
                        ? _colecao!["materias"].map<Widget>((materia) {
                            return _buildMateriaCard(
                              materia["nome"],
                              '${materia["quantidadeTopicos"]} Tópicos',
                              materia["linkCapa"].toString(),
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MateriaPage(idMateria: materia["idMateria"],),
                                  ),
                                );
                              },
                            );
                          }).toList()
                        : [],
                  ),
                  const SizedBox(height: 20),

                  if(usuarioEstaNessaColecao > 0) ...[ 
                    ElevatedButton(
                      onPressed: () {
                        SairDaColecao();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Sair do grupo'),
                    ),
                  ]
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Container(
        width: 200,
        height: 100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaCard(String title, String subtitle, String linkImagem, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(linkImagem),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.black.withOpacity(0.8),
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}