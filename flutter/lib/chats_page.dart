import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.chat, size: 100, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            'Chats',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Acesse suas conversas e interaja com outros usuários.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Ação ao clicar no botão
            },
            child: Text('Iniciar Chat'),
          ),
        ],
      ),
    );
  }
}
