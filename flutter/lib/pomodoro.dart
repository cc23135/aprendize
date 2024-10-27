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
    _totalSeconds = widget.metaTempo * 60;
    _remainingSeconds = _totalSeconds;
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

  void FinalizarEstudo() async {
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
    final dataEstudo = DateTime.utc(now.year, now.month, now.day).toUtc().toIso8601String();

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
        print('Estudo finalizado e tarefa deletada com sucesso');
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else {
        print('Falha ao finalizar estudo: ${response.statusCode}');
      }
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
                        : Colors.white,
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
                FinalizarEstudo();
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
