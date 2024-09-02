import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membros do Grupo'),
      ),
      body: ListView(
        children: [
          _buildMemberCard('João Silva'),
          _buildMemberCard('Maria Oliveira'),
          _buildMemberCard('Pedro Santos'),
        ],
      ),
    );
  }

  Widget _buildMemberCard(String name) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/images/mona.png'), // Adapte o caminho da imagem conforme necessário
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
              PopupMenuItem<String>(
                value: 'Banir',
                child: Text('Banir'),
              ),
              PopupMenuItem<String>(
                value: 'Promover',
                child: Text('Promover a Administrador'),
              ),
              PopupMenuItem<String>(
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
