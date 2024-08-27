import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'), // Adicione a imagem de perfil no diretório assets
              backgroundColor: Colors.grey.shade200,
            ),
            SizedBox(height: 20),
            // Nome do usuário
            Text(
              'Nome do Usuário',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Container com cards
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListView(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Título 1'),
                        subtitle: Text('Subtítulo 1'),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Título 2'),
                        subtitle: Text('Subtítulo 2'),
                      ),
                    ),
                    // Adicione mais cartões conforme necessário
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Botões de trocar tema e logout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Trocar Tema'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
