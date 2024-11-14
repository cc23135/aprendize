import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

class MateriaPage extends StatefulWidget {
  final int idMateria;

  const MateriaPage({super.key, required this.idMateria});

  @override
  _MateriaPageState createState() => _MateriaPageState();
}

class _MateriaPageState extends State<MateriaPage> {
  Map<String, dynamic>? _materia; 
  bool _isLoading = true; // Variável para rastrear o estado de carregamento

  @override
  void initState() {
    super.initState();
    _fetchMateriaInfo();
  }
  
  Future<void> _fetchMateriaInfo() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getMateriaInfo');
    final response = await http.post(uri, body: jsonEncode({
      "query": {
        "idMateria": widget.idMateria
      }
    }), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        _materia = data; 
        _isLoading = false; // Atualiza o estado de carregamento
      });
    } else {
      throw Exception('Falha ao carregar coleção');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tópicos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading 
            ? Center(child: CircularProgressIndicator()) 
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_materia!["nome"] ?? '-'}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Image.network(
                      _materia!["linkCapa"],
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; 
                        } else {
                          return Container();
                        }
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Container(); 
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _materia?["topicos"]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final topico = _materia!["topicos"][index];
                        return _buildMateriaCard(topico["nome"]);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMateriaCard(String title) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}
