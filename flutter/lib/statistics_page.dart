import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.trending_up, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Estatísticas',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Veja as estatísticas detalhadas sobre seu desempenho.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Ação ao clicar no botão
            },
            child: Text('Ver Detalhes'),
          ),
        ],
      ),
    );
  }
}
