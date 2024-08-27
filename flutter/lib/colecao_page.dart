import 'package:flutter/material.dart';


class ChatDetailsPage extends StatelessWidget {
  final String title;
  final int students;

  ChatDetailsPage({required this.title, required this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/mona.png', // Adapte o caminho da imagem conforme necessário
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '$title - $students membros',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: Text('Chat/Entrar'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Estatísticas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatisticCard('Exercícios', '4.378'),
                _buildStatisticCard('Horas de Estudo', '4.382'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Matérias',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            // Aqui você pode adicionar os cards de matérias conforme necessário
            Expanded(
              child: ListView(
                children: [
                  _buildMateriaCard('Matemática 3', '12 Tópicos'),
                  _buildMateriaCard('Biologia 2', '15 Tópicos'),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação ao clicar em "Sair do grupo"
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Sair do grupo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Container(
        width: 300,
        height: 100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            Spacer(),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaCard(String title, String subtitle) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
