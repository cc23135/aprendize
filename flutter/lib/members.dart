import 'dart:convert';
import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembersPage extends StatefulWidget {
  final int idColecao;

  MembersPage({super.key, required this.idColecao});

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  List<Map<String, dynamic>> _membros = [];
  bool _isLoading = true; // Estado de carregamento

  @override
  void initState() {
    super.initState();
    _fetchMembros();
  }

  Future<void> _fetchMembros() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getGroupMembers');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': {'idColecao': widget.idColecao}}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _membros = List<Map<String, dynamic>>.from(data['membros']);
        _isLoading = false; 
      });
    } else {
      setState(() {
        _isLoading = false; 
      });
      throw Exception('Falha ao carregar membros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membros do Grupo'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Ícone de carregamento
          : ListView.builder(
              itemCount: _membros.length,
              itemBuilder: (context, index) {
                final membro = _membros[index];
                return _buildMemberCard(
                  membro['nome'],
                  membro['linkFotoDePerfil'],
                );
              },
            ),
    );
  }

  Widget _buildMemberCard(String name, String? photoUrl) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: photoUrl != null
              ? NetworkImage(photoUrl)
              : AssetImage('assets/images/mona.png') as ImageProvider,
        ),
        title: Text(name),
      ),
    );
  }
}
