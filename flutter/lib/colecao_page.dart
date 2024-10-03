import 'dart:convert';
import 'package:aprendize/colors.dart';
import 'package:http/http.dart' as http;
import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'members_page.dart'; // Importe a nova página
import 'bate_pago_page.dart';
import 'materia_page.dart';

class ChatDetailsPage extends StatefulWidget {
  final int idColecao;

  ChatDetailsPage({super.key, required this.idColecao});

  @override
  _ChatDetailsPageState createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  Map<String, dynamic>? _colecao;

  @override
  void initState() {
    super.initState();
    _fetchColecaoInfo();
  }

  Future<void> _fetchColecaoInfo() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getColecaoInfo');
    final response = await http.post(uri, body: jsonEncode({
      "query": {
        "idColecao": widget.idColecao
      }
    }), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _colecao = Map<String, dynamic>.from(data['colecao']);
      });
    } else {
      throw Exception('Falha ao carregar coleção');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ID: " + widget.idColecao.toString()),
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
                          '${_colecao!["nome"] ?? "Título"}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
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
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BatePagoPage(title: "Unicamp", students: 134),
                          ),
                        );
                      },
                      child: const Text('Chat/Entrar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Estatísticas',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatisticCard('Exercícios', '- -'),
                      _buildStatisticCard('Horas de Estudo', '- -'),
                    ],
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
                                    builder: (context) => MateriaPage(),
                                  ),
                                );
                              },
                            );
                          }).toList()
                        : [],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Sair do grupo'),
                  ),
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
