import 'package:flutter/material.dart';
import 'pomodoro_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Mensagem de boas-vindas
            const Text(
              'Bem-vindo, Usuário!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Row com cartões e botões
            Container(
              height: 200, // Altura ajustada para a Row
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            title: Text('Resumo Diário'),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: _buildProgressCircle('Horas Estudadas', 70), // exemplo de progresso
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildProgressCircle('Exercícios Feitos', 45), // exemplo de progresso
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PomodoroPage()), // Navegação para PomodoroPage
                          );
                        },
                        child: Container(
                          height: 170, // Altura ajustada para a mesma altura do cartão de resumo diário
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.timer, size: 50, color: Colors.green),
                                SizedBox(height: 10),
                                Text('Estudo Livre'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Seção "Para Estudar"
            const Text(
              'Para Estudar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildStudyCard('Matéria ${index + 1}', 'Descrição ${index + 1}'),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Seção "Revisar"
            const Text(
              'Revisar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildStudyCard('Revisão ${index + 1}', 'Descrição ${index + 1}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar um círculo de progresso
  Widget _buildProgressCircle(String label, int progress) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 4,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$label\n$progress%',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Função para criar um cartão de estudo
  Widget _buildStudyCard(String title, String subtitle) {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity, // Ocupa toda a largura disponível
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}
