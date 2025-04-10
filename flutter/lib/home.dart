import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'pomodoro.dart';
import 'package:intl/intl.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _tarefasDoDia = []; // Lista para armazenar as tarefas do dia
  int somatoriaTempo = 0;
  int somatoriaExercicios = 0;
  String nomeUsuario = AppStateSingleton().nome;

  @override
  void initState() {
    super.initState();
    _fetchTarefasDoDia(); // Chama o método para pegar as tarefas do dia
  }

  Future<void> _fetchTarefasDoDia() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/getTarefasDoDia');
    final String username = AppStateSingleton().username;
    final String dataHoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'dataTarefa': dataHoje,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> tarefas = jsonDecode(response.body);
        setState(() {
          _tarefasDoDia = tarefas;
        });
        print(tarefas);

        somatoriaExercicios = 0;
        somatoriaTempo = 0;

        for (var tarefa in _tarefasDoDia) {
          somatoriaExercicios += int.parse(tarefa['metaExercicios'].toString());
          somatoriaTempo += formatarTempo(tarefa["metaTempo"].toString());
        }
      } else {
        print('Falha ao buscar tarefas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  int formatarTempo(String metaTempo) {
    if(metaTempo.length < 19)
      return 0;
    String tempo = metaTempo.substring(11, 19);
    List<String> partes = tempo.split(':');
    int horas = int.parse(partes[0]);
    int minutos = int.parse(partes[1]);

    return minutos + horas * 60;
  }

  String minutosEmTexto(int minutos) {
    int horas = minutos ~/ 60;
    int minutosRestantes = minutos % 60;

    String horasTexto = horas > 0 ? '$horas hora${horas > 1 ? 's' : ''}' : '';
    String minutosTexto = minutosRestantes > 0
        ? '$minutosRestantes minuto${minutosRestantes > 1 ? 's' : ''}'
        : '';

    // Retorna apenas a parte que não está vazia, unindo-as com " e " se ambas existirem
    if (horasTexto.isNotEmpty && minutosTexto.isNotEmpty) {
      return "$horasTexto e $minutosTexto";
    } else if (horasTexto.isNotEmpty) {
      return horasTexto; // Apenas horas
    } else {
      return minutosTexto.isNotEmpty
          ? minutosTexto
          : '0 minutos'; // Apenas minutos ou 0 minutos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Olá, ${nomeUsuario}!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            // Row com cartões e botões
            Container(
              height: 200,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Center(
                      // Centraliza o Card na tela
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Adiciona padding ao redor do Card
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const ListTile(
                                title: Text(
                                  'Resumo Diário',
                                  textAlign:
                                      TextAlign.center, // Centraliza o título
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      8), // Espaço entre o título e o conteúdo
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Exercícios Restantes: " +
                                        somatoriaExercicios.toString(),
                                    textAlign:
                                        TextAlign.center, // Centraliza o texto
                                  ),
                                  const SizedBox(
                                      height: 5), // Espaço entre os textos
                                  Text(
                                    "Tempo Restante: " +
                                        minutosEmTexto(somatoriaTempo),
                                    textAlign:
                                        TextAlign.center, // Centraliza o texto
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  height: 20), // Espaço na parte inferior
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Text(
              'Para Estudar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: _tarefasDoDia.isNotEmpty
                  ? _tarefasDoDia.map<Widget>((tarefa) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildStudyCard(
                          tarefa["idTarefa"],
                          tarefa["topicoNome"].toString(),
                          tarefa["idTopico"],
                          tarefa["metaExercicios"].toString(),
                          tarefa["metaTempo"].toString(),
                        ),
                      );
                    }).toList()
                  : [const Text('Nenhuma tarefa encontrada para hoje.')],
            ),
            const SizedBox(height: 40),

// Seção Para Revisar
            const Text(
              'Para Revisar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: _tarefasDoDia.isNotEmpty
                  ? _tarefasDoDia
                      .where((tarefa) => tarefa["ehRevisao"] == true)
                      .map<Widget>((tarefa) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildStudyCard(
                          tarefa["idTarefa"],
                          tarefa["topicoNome"].toString(),
                          tarefa["idTopico"],
                          tarefa["metaExercicios"].toString(),
                          tarefa["metaTempo"].toString(),
                        ),
                      );
                    }).toList()
                  : [const Text('Nenhuma tarefa de revisão encontrada.')],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyCard(int idTarefa, String title, int idTopico,
      String metaExercicios, String metaTempo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PomodoroPage(
                      metaTempo: formatarTempo(metaTempo),
                      metaExercicios: int.parse(metaExercicios),
                      topicoNome: title,
                      idTopico: idTopico,
                      idTarefa: idTarefa,
                    )));
      },
      child: Card(
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              if (int.parse(metaExercicios) > 0)
                Text("Meta exercícios: " + metaExercicios),
              if (formatarTempo(metaTempo) != 0)
                Text("Meta tempo: " + minutosEmTexto(formatarTempo(metaTempo))),
            ],
          ),
        ),
      ),
    );
  }
}
