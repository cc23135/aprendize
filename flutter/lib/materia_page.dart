import 'package:flutter/material.dart';

class MateriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matérias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Matérias Disponíveis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/mona.png', // Adapte o caminho da imagem conforme necessário
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMateriaCard('Matemática 3'),
                  _buildMateriaCard('Biologia 2'),
                  _buildMateriaCard('Física 1'),
                  _buildMateriaCard('Química 4'),
                ],
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
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
      ),
    );
  }
}
