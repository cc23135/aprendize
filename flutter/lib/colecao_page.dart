import 'package:flutter/material.dart';
import 'members_page.dart'; // Importe a nova página
import 'bate_pago_page.dart';
import 'materia_page.dart';

class ChatDetailsPage extends StatelessWidget {
  final String title;
  final int students;

  const ChatDetailsPage({super.key, required this.title, required this.students});

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
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    '$title - $students membros',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembersPage(),
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
                          builder: (context) => const BatePagoPage(title: "Unicamp", students: 134,),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatisticCard('Exercícios', '4.378'),
                _buildStatisticCard('Horas de Estudo', '4.382'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
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
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaCard(String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap, // Adiciona a funcionalidade de clique
      ),
    );
  }

}
