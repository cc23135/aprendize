import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.leaderboard, size: 100, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'Ranking',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Confira os melhores desempenhos e rankings.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Ação ao clicar no botão
            },
            child: Text('Ver Ranking'),
          ),
        ],
      ),
    );
  }
}
