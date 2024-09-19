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
        _isLoading = false; // Carregamento concluído
      });
    } else {
      setState(() {
        _isLoading = false; // Carregamento concluído mesmo em caso de erro
      });
      throw Exception('Falha ao carregar membros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membros do Grupo - ${widget.idColecao}'),
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
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            // Lógica para cada opção do menu
            switch (value) {
              case 'Banir':
                // Implementar ação para banir
                break;
              case 'Promover':
                // Implementar ação para promover
                break;
              case 'Cancelar':
                // Implementar ação para cancelar
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'Banir',
                child: Text('Banir'),
              ),
              const PopupMenuItem<String>(
                value: 'Promover',
                child: Text('Promover a Administrador'),
              ),
              const PopupMenuItem<String>(
                value: 'Cancelar',
                child: Text('Cancelar'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
