import 'package:flutter/material.dart';
import 'members_page.dart'; // Importe a nova página
import 'bate_pago_page.dart';
import 'materia_page.dart';

class ChatDetailsPage extends StatelessWidget {

  final int idColecao;

  const ChatDetailsPage({super.key, required this.idColecao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A"),
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
                    '$idColecao',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembersPage( idColecao: this.idColecao,),
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
