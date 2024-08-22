import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person, size: 100, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'Perfil do Usuário',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Aqui você pode gerenciar suas informações pessoais e configurações.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Ação ao clicar no botão
            },
            child: Text('Editar Perfil'),
          ),
        ],
      ),
    );
  }
}
