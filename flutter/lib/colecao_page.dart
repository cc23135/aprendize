import 'package:flutter/material.dart';
import 'members_page.dart'; // Importe a nova página
import 'pate_pago_page.dart';
import 'materia_page.dart';

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
              child: Column(
                children: [
                  Text(
                    '$title - $students membros',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembersPage(),
                        ),
                      );
                    },
                    child: Text('Ver Membros'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatePagoPage(title: "Unicamp", students: 134,),
                        ),
                      );
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
            Expanded(
              child: ListView(
                children: [
                  _buildMateriaCard('Matemática 3', '12 Tópicos', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MateriaPage(),
                      ),
                    );
                  }),
                  _buildMateriaCard('Matemática 3', '12 Tópicos', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MateriaPage(),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
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

  Widget _buildMateriaCard(String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap, // Adiciona a funcionalidade de clique
      ),
    );
  }

}
