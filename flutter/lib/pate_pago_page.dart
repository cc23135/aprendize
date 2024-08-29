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
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
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
                '$title - $students estudantes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  children: [
                    _buildMessage('assets/images/mona.png', 'João', 'Olá, como estão todos?'),
                    _buildMessage('assets/images/mona.png', 'Maria', 'Estou bem, obrigado!'),
                    // Adicione mais mensagens conforme necessário
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Digite uma mensagem...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Ação ao clicar em "Enviar"
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String userImage, String userName, String messageContent) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(userImage),
      ),
      title: Text(userName),
      subtitle: Text(messageContent),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}