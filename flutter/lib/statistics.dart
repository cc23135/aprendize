// day para dia
// day vira week -> mudar quantidade de dados também

import 'dart:ui';
import 'package:aprendize/AppStateSingleton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For json.decode()
import 'package:http/http.dart' as http; // For http.get()

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isLoading = true;
  


  // exercícios feitos
  List<FlSpot> exerciciosFeitosSemanal = [ // dados das horas
  const FlSpot(0, 1),
  const FlSpot(1, 3),
  const FlSpot(2, 5),
  const FlSpot(3, 2),
  const FlSpot(4, 4),
  const FlSpot(5, 4),
  const FlSpot(6, 4),
  ];

  List<FlSpot> exerciciosFeitosDiario = [ // dados das horas
  const FlSpot(0, 5),
  const FlSpot(1, 5),
  const FlSpot(2, 5),
  const FlSpot(3, 5),
  const FlSpot(4, 5),
  const FlSpot(5, 5),
  const FlSpot(6, 5),
  ];
  
  List<FlSpot> exerciciosFeitosMensal = [ // dados das horas
  const FlSpot(0, 2),
  const FlSpot(1, 3),
  const FlSpot(2, 2),
  const FlSpot(3, 3),
  const FlSpot(4, 2),
  const FlSpot(5, 3),
  const FlSpot(6, 2),
  ];
  
  // tempo gasto toal
  List<FlSpot> tempoGastoTotalSemanal = [ // dados das horas
  const FlSpot(0, 1),
  const FlSpot(1, 3),
  const FlSpot(2, 5),
  const FlSpot(3, 2),
  const FlSpot(4, 4),
  const FlSpot(5, 4),
  const FlSpot(6, 4),
  ];
  
  List<FlSpot> tempoGastoTotalDiario = [ // dados das horas
  const FlSpot(0, 1),
  const FlSpot(1, 3),
  const FlSpot(2, 5),
  const FlSpot(3, 2),
  const FlSpot(4, 4),
  const FlSpot(5, 4),
  const FlSpot(6, 4),
  ];

  List<FlSpot> tempoGastoTotalMensal = [ // dados das horas
  const FlSpot(0, 2),
  const FlSpot(1, 3),
  const FlSpot(2, 2),
  const FlSpot(3, 3),
  const FlSpot(4, 2),
  const FlSpot(5, 3),
  const FlSpot(6, 2),
  ];
  

  // exercícios acertados %

  List<int> porcentagemExerciciosAcertados  = [12, 13, 14, 98];

  List<String> nomePorcentagemExerciciosAcertados  = ["Matéria","Matéria","Matéria","Matéria"];

// -------------------------------------------------
  // exercícios feitos por matéria 
  // pegar top 9 matéerias, os outros serão a mesma linha

  List<String> nomesMateriasExerciciosSemanal = [
    "matéria 1",
    "matéria 2",
    "matéria 3",
    "matéria 4",
    "matéria 5",
    "matéria 6",
    "matéria 7",
    "matéria 8",
    "matéria 9",
    "matéria 10"
  ];
  
  List<List<FlSpot>> exerciciosFeitosPorMateriaSemanal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];
  
  List<String> nomesMateriasExerciciosMensal = [
    "matéria 1",
    "matéria 2",
    "matéria 3",
    "matéria 4",
    "matéria 5",
    "matéria 6",
    "matéria 7",
    "matéria 8",
    "matéria 9",
    "matéria 10"
  ];
  
  List<List<FlSpot>> exerciciosFeitosPorMateriaMensal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];

  // tempo gasto por matéria
  
  List<String> nomesMateriasTempoSemanal = [
    "matéria 1",
    "matéria 2",
    "matéria 3",
    "matéria 4",
    "matéria 5",
    "matéria 6",
    "matéria 7",
    "matéria 8",
    "matéria 9",
    "matéria 10"
  ];

  List<List<FlSpot>> tempoGastoPorMateriaSemanal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];

   
  List<String> nomesMateriasTempoMensal = [
    "matéria 1",
    "matéria 2",
    "matéria 3",
    "matéria 4",
    "matéria 5",
    "matéria 6",
    "matéria 7",
    "matéria 8",
    "matéria 9",
    "matéria 10"
  ];

  List<List<FlSpot>> tempoGastoPorMateriaMensal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];

 

  // exercícios feitos por coleção
  
  List<String> nomesColecoesExerciciosSemanal = [
    "coleção 1",
    "coleção 2",
    "coleção 3",
    "coleção 4",
    "coleção 5",
    "coleção 6",
    "coleção 7",
    "coleção 8",
    "coleção 9",
    "coleção 10"
  ];
  
  List<List<FlSpot>> exerciciosFeitosPorColecaoSemanal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];
  
  
  List<String> nomesColecoesExerciciosMensal = [
    "coleção 1",
    "coleção 2",
    "coleção 3",
    "coleção 4",
    "coleção 5",
    "coleção 6",
    "coleção 7",
    "coleção 8",
    "coleção 9",
    "coleção 10"
  ];
  
  List<List<FlSpot>> exerciciosFeitosPorColecaoMensal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];
  

  // tempo gasto por coleção
  
  List<String> nomesColecoesTempoSemanal = [
    "coleção 1",
    "coleção 2",
    "coleção 3",
    "coleção 4",
    "coleção 5",
    "coleção 6",
    "coleção 7",
    "coleção 8",
    "coleção 9",
    "coleção 10"
  ];
  
  List<List<FlSpot>> tempoGastoPorColecaoSemanal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];
  
  List<String> nomesColecoesTempoMensal = [
    "coleção 1",
    "coleção 2",
    "coleção 3",
    "coleção 4",
    "coleção 5",
    "coleção 6",
    "coleção 7",
    "coleção 8",
    "coleção 9",
    "coleção 10"
  ];
  
  List<List<FlSpot>> tempoGastoPorColecaoMensal = [ // dados das horas
    [ // dados das horas
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
    [
    const FlSpot(0, 1),
    const FlSpot(1, 3),
    const FlSpot(2, 5),
    const FlSpot(3, 2),
    const FlSpot(4, 4),
    const FlSpot(5, 4),
    const FlSpot(6, 4),
    ],
  ];
  

  

  // cores
  List<Color> coresLista = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.lightBlue,
    Colors.amber,
    Colors.cyan,
  ];


  int timeSpent = 0;  // Variable to hold time spent
  int tasksDone = 0;  // Variable to hold number of tasks done

  @override
  void initState() {
    super.initState();
    _fetchStatisticsData();
  }

Future<void> _fetchStatisticsData() async {
  try {
    final userId = AppStateSingleton().idUsuario;
    final response = await http.get(Uri.parse('http://localhost:6060/api/statistics?userId=$userId'));
    
    if (response.statusCode == 200) {
      final String jsonString = response.body;
      AppStateSingleton().statisticsJson = jsonString; // Store JSON if needed
      final data = json.decode(jsonString);
      
      setState(() {
        // Accessing the data returned by your API
        exerciciosFeitosSemanal = data['exerciciosFeitosSemanal']; // 4 semanas // BD
        exerciciosFeitosDiario = data['exerciciosFeitosDiario']; // 7 dias // bd
        exerciciosFeitosMensal = data['exerciciosFeitosMensal']; // SEM NADA

        tempoGastoTotalSemanal = data['tempoGastoTotalSemanal']; // BD
        tempoGastoTotalDiario = data['tempoGastoTotalDiario']; // BD
        tempoGastoTotalMensal = data['tempoGastoTotalMensal']; // SEM NADA

        nomesMateriasExerciciosSemanal = data['nomesMateriasExerciciosSemanal']; // BD
        exerciciosFeitosPorMateriaSemanal = data['exerciciosFeitosPorMateriaSemanal'];  // BD

        nomesMateriasExerciciosMensal = data['nomesMateriasExerciciosMensal']; // BD
        exerciciosFeitosPorMateriaMensal = data['exerciciosFeitosPorMateriaMensal']; // BD

        nomesMateriasTempoSemanal = data['nomesMateriasTempoSemanal']; // BD
        tempoGastoPorMateriaSemanal = data['tempoGastoPorMateriaSemanal']; // BD

        nomesMateriasTempoMensal = data['nomesMateriasTempoMensal']; // BD
        tempoGastoPorMateriaMensal = data['tempoGastoPorMateriaMensal']; // BD

        // a fazer BD abaixo

        nomesColecoesExerciciosSemanal = data['nomesColecoesExerciciosSemanal'];
        exerciciosFeitosPorColecaoSemanal = data['exerciciosFeitosPorColecaoSemanal'];

        nomesColecoesExerciciosMensal = data['nomesColecoesExerciciosMensal'];
        exerciciosFeitosPorColecaoMensal = data['exerciciosFeitosPorColecaoMensal'];

        nomesColecoesTempoSemanal = data['nomesColecoesTempoSemanal'];
        tempoGastoPorColecaoSemanal = data['tempoGastoPorColecaoSemanal'];

        nomesColecoesTempoMensal = data['nomesColecoesTempoMensal'];
        tempoGastoPorColecaoMensal = data['tempoGastoPorColecaoMensal'];

        print(data);

        // Process the data as needed, e.g., updating state variables
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to load statistics data');
    }
  } catch (e) {
    print('Error fetching statistics data: $e');
    setState(() {
      isLoading = false; // Handle loading state
    });
  }
}


  List<FlSpot> _parseDataToFlSpots(dynamic data) {
    List<FlSpot> spots = [];
    int index = 0;
    for (var item in data) {
      spots.add(FlSpot(index.toDouble(), item['value'].toDouble()));
      index++;
    }
    return spots;
  }

  List<bool> isSelectedDayWeek = [true, false]; // Initial selection for "Daily"
  List<bool> isSelectedWeekMonth = [true, false]; // Initial selection for "Weekly"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  const SizedBox(height: 20),

                  // título
                  Align(
                    alignment: Alignment.center,
                    child: Text("Estatísticas", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600 )),
                  ),
                  
                  const SizedBox(height: 20),

                  // botão para definir semanal ou diário
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300), // Animation duration
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child); // Fades between states
                      },
                      child: ToggleButtons(
                        key: ValueKey<bool>(isSelectedDayWeek[0]), // Key to trigger the animation
                        isSelected: isSelectedDayWeek,
                        selectedColor: Colors.white,
                        fillColor: Colors.blue, // Background color when selected
                        borderColor: Colors.blue, // Border color for all buttons
                        borderRadius: BorderRadius.circular(10),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Diário'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Semanal'),
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            // Toggle button selection
                            for (int i = 0; i < isSelectedDayWeek.length; i++) {
                              isSelectedDayWeek[i] = i == index;
                            }
                          });
                          // função para recriar os gráficos com as informações 
                        },
                      ),
                    ),
                  ),


                  const SizedBox(height: 40),


                  Align(
                    alignment: Alignment.topCenter,
                      child: Column(
                        children: [

                        // exercícios feitos
                        // linha
                        Text(
                          (isSelectedDayWeek[0]) // diario
                              ? "Exercícios feitos diariamente"
                              : "Exercícios feitos semanalmente",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: buildLineGraph((isSelectedDayWeek[0]) // diario
                                ? exerciciosFeitosDiario
                                : exerciciosFeitosSemanal), // Pass daily or weekly data
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Tempo gasto no aplicativo
                        Text(
                          (isSelectedDayWeek[0])
                              ? "Tempo gasto diariamente"
                              : "Tempo gasto semanalmente",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: buildBarGraph((isSelectedDayWeek[0])
                                ? tempoGastoTotalDiario
                                : tempoGastoTotalSemanal), // Pass daily or weekly data
                          ),
                        ),



                        const SizedBox(height: 50),

                        
                        // % acerto aqui

                        // Semanal mensal abaixo

                        // botão para definir semanal ou mensal
                        const SizedBox(height: 50),


                        Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300), // Animation duration
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child); // Fades between states
                            },
                            child: ToggleButtons(
                              key: ValueKey<bool>(isSelectedWeekMonth[0]), // Key to trigger the animation
                              isSelected: isSelectedWeekMonth,
                              selectedColor: Colors.white,
                              fillColor: Colors.blue, // Background color when selected
                              borderColor: Colors.blue, // Border color for all buttons
                              borderRadius: BorderRadius.circular(10),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('Semanal'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('Mensal'),
                                ),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  // Toggle button selection
                                  for (int i = 0; i < isSelectedWeekMonth.length; i++) {
                                    isSelectedWeekMonth[i] = i == index;
                                  }
                                });
                                // função para recriar os gráficos com as informações 
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Column(
                          children: [
                            Text(
                              (isSelectedWeekMonth[0])
                                  ? "Exercícios feitos por matéria semanalmente"
                                  : "Exercícios feitos por matéria mensalmente",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(right: 35.0),
                              child: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: buildMultiLineGraph(
                                  (isSelectedWeekMonth[0])
                                      ? exerciciosFeitosPorMateriaSemanal
                                      : exerciciosFeitosPorMateriaMensal,
                                  coresLista,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Display the names under the graph with associated colors
                            Wrap(
                              alignment: WrapAlignment.start, // Ensures left alignment for incomplete lines
                              children: List.generate(
                                (isSelectedWeekMonth[0]
                                    ? nomesMateriasExerciciosSemanal.length
                                    : nomesMateriasExerciciosMensal.length),
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0), // Adjust vertical and horizontal padding
                                  child: Chip(
                                    label: Text(
                                      (isSelectedWeekMonth[0]
                                          ? nomesMateriasExerciciosSemanal[index]
                                          : nomesMateriasExerciciosMensal[index]),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: coresLista[index], // Set the color for each subject
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),




                        // tempo gasto por matéria
                        // coluna

                        Text(
                          (isSelectedWeekMonth[0])
                              ? "Tempo gasto por matéria semanalmente"
                              : "Tempo gasto por matéria mensalmente",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: buildMultiLineGraph((isSelectedWeekMonth[0])
                                ? tempoGastoPorMateriaSemanal
                                : tempoGastoPorMateriaMensal,
                                coresLista,
                                ), // Pass daily or weekly data
                          ),
                        ),
                        const SizedBox(height: 30),

                        Wrap(
                          alignment: WrapAlignment.start, // Ensures left alignment for incomplete lines
                          children: List.generate(
                            (isSelectedWeekMonth[0]
                                ? nomesMateriasTempoSemanal.length
                                : nomesMateriasTempoMensal.length),
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0), // Adjust vertical and horizontal padding
                              child: Chip(
                                label: Text(
                                  (isSelectedWeekMonth[0]
                                      ? nomesMateriasTempoSemanal[index]
                                      : nomesMateriasTempoMensal[index]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: coresLista[index], // Set the color for each subject
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Text(
                          (isSelectedWeekMonth[0])
                              ? "Exercícios feitos por coleção semanalmente"
                              : "Exercícios feitos por coleção mensalmente",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: buildMultiLineGraph((isSelectedWeekMonth[0])
                                ? exerciciosFeitosPorColecaoSemanal
                                : exerciciosFeitosPorColecaoMensal,
                                coresLista,
                                ), // Pass daily or weekly data
                          ),
                        ),
                        const SizedBox(height: 30),

                        Wrap(
                          alignment: WrapAlignment.start, // Ensures left alignment for incomplete lines
                          children: List.generate(
                            (isSelectedWeekMonth[0]
                                ? nomesColecoesExerciciosSemanal.length
                                : nomesColecoesExerciciosMensal.length),
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0), // Adjust vertical and horizontal padding
                              child: Chip(
                                label: Text(
                                  (isSelectedWeekMonth[0]
                                      ? nomesColecoesExerciciosSemanal[index]
                                      : nomesColecoesExerciciosMensal[index]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: coresLista[index], // Set the color for each subject
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        Text(
                          (isSelectedWeekMonth[0])
                              ? "Tempo gasto por coleção semanalmente"
                              : "Tempo gasto por coleção mensalmente",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: buildMultiLineGraph((isSelectedWeekMonth[0])
                                ? tempoGastoPorColecaoSemanal
                                : tempoGastoPorColecaoMensal,
                                coresLista,
                                ), // Pass daily or weekly data
                          ),
                        ),
                        const SizedBox(height: 30),

                        Wrap(
                          alignment: WrapAlignment.start, // Ensures left alignment for incomplete lines
                          children: List.generate(
                            (isSelectedWeekMonth[0]
                                ? nomesColecoesTempoSemanal.length
                                : nomesColecoesTempoMensal.length),
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0), // Adjust vertical and horizontal padding
                              child: Chip(
                                label: Text(
                                  (isSelectedWeekMonth[0]
                                      ? nomesColecoesTempoSemanal[index]
                                      : nomesColecoesTempoMensal[index]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: coresLista[index], // Set the color for each subject
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                      ],
                    ),
                  ),



                  const SizedBox(height: 20),
                  Text(
                    AppStateSingleton().statisticsJson, // Show the raw JSON data for debugging
                    style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget buildLineGraph(List<FlSpot> spots) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, // Ensure each day is labeled
              getTitlesWidget: (value, meta) {
                // Dynamically generate day labels based on index
                int index = value.toInt();
                if (index >= 0 && index < spots.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8, // Optional: Adds space between the labels and the graph
                    child: Transform.rotate(
                      angle: -45 * 3.1415926535 / 180, // Rotate 45 degrees counter-clockwise
                      child: Text('Day ${index + 1}', style: const TextStyle(fontSize: 10)),
                    ),
                  );
                } else {
                  return const Text(''); // Return empty text for out-of-bound indexes
                }
              },
            ),
          ),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 35, // Increase this if needed to avoid text cropping
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0), // Add some padding to prevent cropping
                  child: Align(alignment: Alignment.topRight,
                    child: Text(
                      value.toStringAsFixed(0), // Format to prevent large text
                      style: const TextStyle(fontSize: 12), // Adjust font size if needed
                    ),
                  )
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: 0,
        maxX: spots.isNotEmpty ? (spots.length - 1).toDouble() : 0,
        minY: 0,
        maxY: spots.isNotEmpty
            ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10)
            : 10,
      ),
    );
  } 

  Widget buildBarGraph(List<FlSpot> spots) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < spots.length) {
                  return Text('Day ${index + 1}', style: const TextStyle(fontSize: 10));
                } else {
                  return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 35, // Increase this if needed to avoid text cropping
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0), // Add some padding to prevent cropping
                  child: Align(alignment: Alignment.topRight,
                    child: Text(
                      value.toStringAsFixed(0), // Format to prevent large text
                      style: const TextStyle(fontSize: 12), // Adjust font size if needed
                    ),
                  )
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        barGroups: spots.asMap().entries.map((entry) {
          int index = entry.key;
          double yValue = entry.value.y;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: yValue,
                color: Colors.blue,
                width: MediaQuery.of(context).size.width * 0.09, // Increased width for wider bars
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5), // Radius for the top left corner
                  topRight: Radius.circular(5), // Radius for the top right corner

                  bottomLeft: Radius.circular(1), // Radius for the top right corner
                  bottomRight: Radius.circular(1), // Radius for the top right corner
                ),
              ),
            ],
          );
        }).toList(),
        maxY: spots.isNotEmpty
            ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5)
            : 10,
      ),
    );
  }


Widget buildBarGraphVariableTiles(List<FlSpot> spots, List<String> materias) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < materias.length) {
                  return Text(
                    materias[index], // Use materias as titles
                    style: const TextStyle(fontSize: 10),
                  );
                } else {
                  return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 35, 
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xff37434d),
            width: 1,
          ),
        ),
        barGroups: spots.asMap().entries.map((entry) {
          int index = entry.key;
          double yValue = entry.value.y;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: yValue,
                color: Colors.blue,
                width: MediaQuery.of(context).size.width * 0.09,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(1),
                ),
              ),
            ],
          );
        }).toList(),
        maxY: spots.isNotEmpty
            ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5)
            : 10,
      ),
    );
  }


Widget buildMultiLineGraph(List<List<FlSpot>> lineSpots, List<Color> lineColors) {
  return LineChart(
    LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1, // Ensure each label has the correct spacing
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < lineSpots.first.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8, // Adds space between the labels and the graph
                  child: Transform.rotate(
                    angle: -45 * 3.1415926535 / 180, // Rotate 45 degrees counter-clockwise
                    child: Text('Day ${index + 1}', style: const TextStyle(fontSize: 10)),
                  ),
                );
              } else {
                return const Text('');
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 35, // Prevent text cropping
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ),
        rightTitles: AxisTitles( // nome de cada linha
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xff37434d),
          width: 1,
        ),
      ),
      lineBarsData: lineSpots.asMap().entries.map((entry) {
        int index = entry.key;
        List<FlSpot> spots = entry.value;

        return LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColors[index], // Assign each line its color
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        );
      }).toList(),
      minX: 0,
      maxX: lineSpots.isNotEmpty && lineSpots.first.isNotEmpty
          ? (lineSpots.first.length - 1).toDouble()
          : 0,
      minY: 0,
      maxY: lineSpots.isNotEmpty && lineSpots.first.isNotEmpty
          ? (lineSpots.expand((e) => e).map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10)
          : 10,
    ),
  );
}

}
