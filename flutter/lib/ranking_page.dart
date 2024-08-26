import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dados fictícios para os usuários
    final List<UserRanking> rankings = [
      UserRanking(position: 1, name: 'Alice', points: 1500, isMainUser: true),
      UserRanking(position: 2, name: 'Bob', points: 1300),
      UserRanking(position: 3, name: 'Charlie', points: 1200),
      UserRanking(position: 4, name: 'Diana', points: 1100),
      UserRanking(position: 5, name: 'Eve', points: 1000),
    ];

    // Encontrar o rank do usuário principal
    final mainUser = rankings.firstWhere((user) => user.isMainUser);
    final mainUserRank = mainUser.position;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Linha de botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Ação para o botão 1
                  },
                  child: Text('Botão 1'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Ação para o botão 2
                  },
                  child: Text('Botão 2'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Ação para o botão 3
                  },
                  child: Text('Botão 3'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Texto do rank do main user
            Text(
              'Você está no rank #$mainUserRank',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 20),
            // Título do Ranking
            Text(
              'Ranking dos Usuários',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Lista de rankings com borda
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: rankings.length,
                  itemBuilder: (context, index) {
                    final user = rankings[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/mona.png'), // Imagem de perfil
                      ),
                      title: Text(user.name),
                      subtitle: Text('${user.points} pontos'),
                      trailing: user.isMainUser
                          ? Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${user.position}',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            )
                          : Text('${user.position}'),
                      tileColor: user.isMainUser ? Colors.blue.withOpacity(0.1) : null,
                      isThreeLine: true,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Ícones na parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.access_time, size: 30, color: Colors.blue),
                  onPressed: () {
                    // Ação ao clicar no ícone de relógio
                  },
                ),
                SizedBox(width: 30),
                IconButton(
                  icon: Icon(Icons.fitness_center, size: 30, color: Colors.blue),
                  onPressed: () {
                    // Ação ao clicar no ícone de exercícios
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo para representar o ranking do usuário
class UserRanking {
  UserRanking({
    required this.position,
    required this.name,
    required this.points,
    this.isMainUser = false,
  });

  final int position;
  final String name;
  final int points;
  final bool isMainUser;
}
