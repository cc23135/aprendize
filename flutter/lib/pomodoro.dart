import 'dart:convert';
import 'package:aprendize/AppStateSingleton.dart';
import 'package:aprendize/colors.dart';
import 'package:aprendize/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class PomodoroPage extends StatefulWidget {
  int metaTempo;
  int metaExercicios;
  String topicoNome;
  int idTopico;
  int idTarefa;

  PomodoroPage({
    super.key,
    required this.metaTempo,
    required this.metaExercicios,
    required this.topicoNome,
    required this.idTopico,
    required this.idTarefa,
  });

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  Timer? _timer;
  late final int _totalSeconds;
  late int _remainingSeconds;
  late int _elapsedSeconds; // Tempo decorrido em segundos
  bool _isRunning = false;
  int _exerciciosFeitos = 0;
  int _exerciciosAcertados = 0;
  int _exerciciosErrados = 0;

  @override
  void initState() {
    super.initState();
      if (widget.metaTempo > 0) {
    _totalSeconds = widget.metaTempo * 60;
    _remainingSeconds = _totalSeconds;
  } else {
    _totalSeconds = 1; 
    _remainingSeconds = _totalSeconds;
  }
    _elapsedSeconds = 0; // Inicializa o tempo decorrido
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          }
          _elapsedSeconds++; // Continua incrementando o tempo decorrido
        });
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
    });
  }

  void _resetTimer() {
    if (_isRunning) {
      _stopTimer();
    }
    setState(() {
      _remainingSeconds = _totalSeconds;
      _elapsedSeconds = 0; // Reseta o tempo decorrido
    });
  }

  void _showAgendarRevisaoDialog() {
    TextEditingController _diasRevisaoController =
        TextEditingController(); // Controlador para o TextField
    List<int> diasRevisaoSelecionados =
        []; // Lista de dias selecionados para revisão

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agendar revisão?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Botões para revisão padrão
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    diasRevisaoSelecionados = [7,14,30]; 
                    FinalizarEstudo(diasRevisaoSelecionados);
                  });
                },
                child: const Text('Revisão 7-14-30 dias'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _diasRevisaoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Customizado',
                  hintText: 'Ex: 7-15-20',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  List<int> customDias =
                      _validarDias(_diasRevisaoController.text);
                  if (customDias.isNotEmpty) {
                    setState(() {
                      diasRevisaoSelecionados = customDias;
                    });
                    FinalizarEstudo(diasRevisaoSelecionados);
                  }
                },
                child: const Text('Agendar revisão com os dias inseridos'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  FinalizarEstudo([]); // Não agendar revisão
                },
                child: const Text('Terminar estudo sem revisões'),
              ),
            ],
          ),
        );
      },
    );
  }

  List<int> _validarDias(String value) {
    List<String> partes = value.split('-');

    List<int> dias = [];
    for (var parte in partes) {
      parte = parte.trim();
      if (parte.isEmpty) {
        continue; // Ignora partes vazias
      }
      if (int.tryParse(parte) != null) {
        dias.add(int.parse(parte));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Formato incorreto: "$parte" não é um número válido')));
        return [];
      }
    }

    if (dias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Por favor, insira pelo menos um intervalo válido de dias')));
    } else {
      dias.sort();
    }

    return dias;
  }

  void FinalizarEstudo(List<int> diasRevisao) async {
    _stopTimer();

    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/criarEstudo');
    final idTarefa = widget.idTarefa;
    final idTopico = widget.idTopico;
    final username = AppStateSingleton().username;
    final metaExercicios = widget.metaExercicios;
    final metaTempo = widget.metaTempo;
    final qtosExercicios = _exerciciosFeitos;
    final qtosExerciciosAcertados = _exerciciosAcertados;
    final qtoTempo = (_elapsedSeconds / 60).ceil();
    DateTime now = DateTime.now();
    final dataEstudo =
        DateTime.utc(now.year, now.month, now.day).toUtc().toIso8601String();

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idTarefa': idTarefa,
          'idTopico': idTopico,
          'username': username,
          'metaExercicios': metaExercicios,
          'metaTempo': metaTempo,
          'qtosExercicios': qtosExercicios,
          'qtosExerciciosAcertados': qtosExerciciosAcertados,
          'qtoTempo': qtoTempo,
          'dataEstudo': dataEstudo,
        }),
      );

      if (response.statusCode == 201) {
        print('Estudo finalizado com sucesso');
      } else {
        print('Falha ao finalizar estudo: ${response.statusCode}');
      }

      if (diasRevisao.isNotEmpty) {
        // Preparando a lista de dias no formato correto para a requisição
        List<String> diasRevisaoFormatados = [];
        for (int dias in diasRevisao) {
          DateTime dataRevisao = now.add(Duration(days: dias));
          final dataRevisaoIso =
              DateTime.utc(dataRevisao.year, dataRevisao.month, dataRevisao.day)
                  .toUtc()
                  .toIso8601String();
          diasRevisaoFormatados
              .add(dataRevisaoIso); 
        }

        final uriRevisao =
            Uri.parse('${AppStateSingleton().apiUrl}api/criarRevisao');

    
        final responseRevisao = await http.post(
          uriRevisao,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'idUsuario': AppStateSingleton().idUsuario,
            'dias': diasRevisaoFormatados, 
            'subjects': [
              {
                'idTopico': idTopico,
                'exercicios': metaExercicios,
                'tempoDeEstudo': metaTempo,
              },
            ],
          }),
        );

        if (responseRevisao.statusCode == 200) {
          print("Revisões criadas com sucesso!");
        } else {
          print("Erro ao criar as revisões: ${responseRevisao.body}");
        }
      }

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } catch (e) {
      print('Erro ao finalizar estudo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingMinutes = (_remainingSeconds / 60).floor();
    final remainingSeconds = _remainingSeconds % 60;
    final elapsedMinutes = (_elapsedSeconds / 60).floor();
    final elapsedSeconds = _elapsedSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${widget.topicoNome}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _exerciciosFeitos++;
                      _exerciciosAcertados++;
                    });
                  },
                  child: Text('✔ $_exerciciosAcertados'),
                ),
                const SizedBox(width: 20),
                Text(
                  'Ex. $_exerciciosFeitos/${widget.metaExercicios} ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: _exerciciosFeitos >= widget.metaExercicios
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _exerciciosFeitos >= widget.metaExercicios
                        ? Colors.green
                        : AppColors.white,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _exerciciosFeitos++;
                      _exerciciosErrados++;
                    });
                  },
                  child: Text('❌ $_exerciciosErrados'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: (_totalSeconds - _remainingSeconds) / _totalSeconds,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: const Text('Começar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: !_isRunning ? null : _stopTimer,
                  child: const Text('Parar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Resetar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${elapsedMinutes.toString().padLeft(2, '0')}:${elapsedSeconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showAgendarRevisaoDialog();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.darkPurple,
              ),
              child: const Text('Finalizar Estudo'),
            ),
          ],
        ),
      ),
    );
  }
}
