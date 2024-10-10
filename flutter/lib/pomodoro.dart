import 'dart:convert';

import 'package:aprendize/AppStateSingleton.dart';
import 'package:aprendize/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class PomodoroPage extends StatefulWidget {
  int metaTempo;
  int metaExercicios;
  String topicoNome;
  int idTopico;
  int idTarefa;
  
  PomodoroPage({super.key, required this.metaTempo, required this.metaExercicios, required this.topicoNome, required this.idTopico, required this.idTarefa});

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  Timer? _timer;
  late final int _totalSeconds; 
  late int _remainingSeconds; 
  bool _isRunning = false;
  int _exerciciosFeitos = 0;
  int _exerciciosAcertados = 0;
  int _exerciciosErrados = 0;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.metaTempo * 60; 
    _remainingSeconds = _totalSeconds; 
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _stopTimer(); 
        }
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
    });
  }


  void FinalizarEstudo() async {
    final uri = Uri.parse('${AppStateSingleton().apiUrl}api/criarEstudo');
    final idTarefa = widget.idTarefa; 
    final idTopico = widget.idTopico;
    //final idUsuario = AppStateSingleton().userId; 
    final metaExercicios = widget.metaExercicios;
    final metaTempo = widget.metaTempo;
    final qtosExercicios = _exerciciosFeitos;
    final qtosExerciciosAcertados = _exerciciosAcertados; 
    final qtoTempo = 0; //fazer
    final dataEstudo = DateTime.now().toIso8601String();

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idTarefa': idTarefa,
          'idTopico': idTopico,
          'idUsuario': 2,
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
      } else {
        print('Falha ao finalizar estudo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao finalizar estudo: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;

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
                  onPressed: (){setState(() {_exerciciosFeitos++;_exerciciosAcertados++;});},
                  child: Text('✔ ${_exerciciosAcertados}'),
                ),
                const SizedBox(width: 20),
                Text(
                  'Ex. ${_exerciciosFeitos}/${widget.metaExercicios} ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: _exerciciosFeitos >= widget.metaExercicios ? FontWeight.bold : FontWeight.normal, // Define o peso da fonte
                    color: _exerciciosFeitos >= widget.metaExercicios ? Colors.green : Colors.white, // Altera a cor
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (){setState(() {_exerciciosFeitos++;_exerciciosErrados++;});},
                  child: Text('❌ ${_exerciciosErrados}'),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: _isRunning ? (_totalSeconds - _remainingSeconds) / _totalSeconds : 0,
                strokeWidth: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 30), 

            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: !_isRunning ? null : _stopTimer,
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {FinalizarEstudo();},
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
