import 'package:aprendize/AppStateSingleton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isLoading = true;
  


  // exercícios feitos
  List<FlSpot> exerciciosFeitosTotalSemanal = [ // dados das horas
  const FlSpot(0, 1),
  const FlSpot(1, 3),
  const FlSpot(2, 5),
  const FlSpot(3, 2),
  const FlSpot(4, 4),
  const FlSpot(5, 4),
  const FlSpot(6, 4),
  ];

  List<FlSpot> exerciciosFeitosTotalDiario = [ // dados das horas
  const FlSpot(0, 5),
  const FlSpot(1, 5),
  const FlSpot(2, 5),
  const FlSpot(3, 5),
  const FlSpot(4, 5),
  const FlSpot(5, 5),
  const FlSpot(6, 5),
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


  @override
  void initState() {
    super.initState();
    _fetchStatisticsData();
  }

  Future<void> _fetchStatisticsData() async {
    try {
      final userId = AppStateSingleton().idUsuario;
      final response = await http.get(Uri.parse('${AppStateSingleton().apiUrl}api/statistics?userId=$userId'));
      
      if (response.statusCode == 200) {
        final String jsonString = response.body;
        AppStateSingleton().statisticsJson = jsonString; 
        final data = json.decode(jsonString);
        
        setState(() {
          List<dynamic> bruto = data['exerciciosFeitosTotalDiario'];
          exerciciosFeitosTotalDiario = bruto.asMap().entries.map((entry) {
            int index = entry.key;
            int yValue = entry.value['TotalExerciciosFeitos'] as int;
            return FlSpot(index.toDouble(), yValue.toDouble());
          }).toList();

          bruto = data['exerciciosFeitosTotalSemanal'];
          exerciciosFeitosTotalSemanal = bruto.asMap().entries.map((entry) {
            int index = entry.key;
            int yValue = entry.value['TotalExerciciosFeitos'] as int;
            return FlSpot(index.toDouble(), yValue.toDouble());
          }).toList();

          bruto = data['tempoGastoTotalDiario'];
          tempoGastoTotalDiario = bruto.asMap().entries.map((entry) {
            int index = entry.key;
            int yValue = entry.value['TotalTempoSegundos'] as int;
            return FlSpot(index.toDouble(), (yValue / 60).toDouble());
          }).toList();

          bruto = data['tempoGastoTotalSemanal'];
          tempoGastoTotalSemanal = bruto.asMap().entries.map((entry) {
            int index = entry.key;
            int yValue = entry.value['TotalTempoSegundos'] as int;
            return FlSpot(index.toDouble(), (yValue / 60).toDouble());
          }).toList();
        });
      } else {
        throw Exception('Failed to load statistics data, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching statistics data: $e');
    } finally {
      setState(() {
        isLoading = false;  
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

  List<bool> isSelectedDayWeek = [true, false]; 
  List<bool> isSelectedWeekMonth = [true, false]; 

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
                      duration: const Duration(milliseconds: 300), 
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child); 
                      },
                      child: ToggleButtons(
                        key: ValueKey<bool>(isSelectedDayWeek[0]), 
                        isSelected: isSelectedDayWeek,
                        selectedColor: Colors.white,
                        fillColor: Colors.blue,  
                        borderColor: Colors.blue,  
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
                                ? exerciciosFeitosTotalDiario
                                : exerciciosFeitosTotalSemanal), 
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
                                : tempoGastoTotalSemanal), 
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }


  Widget buildLineGraph(List<FlSpot> spots) {
    double maxYValue = spots.isNotEmpty 
    ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5 
    : 10;
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, 
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < spots.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Transform.rotate(
                      angle: -45 * 3.1415926535 / 180,
                      child: Text( '${isSelectedDayWeek[1] ? 'Semana' : 'Dia'} ${index + 1}', style: const TextStyle(fontSize: 10)),
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
              interval: maxYValue/10,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Align(alignment: Alignment.topRight,
                    child: Text(
                      value.toStringAsFixed(0), 
                      style: const TextStyle(fontSize: 12),  
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
    double maxYValue = spots.isNotEmpty 
    ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5 
    : 10;
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
                  return Text('${isSelectedDayWeek[1] ? 'Semana' : 'Dia'} ${index + 1}', style: const TextStyle(fontSize: 10));
                } else {
                  return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxYValue/10,
              reservedSize: 35,  
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0), 
                  child: Align(alignment: Alignment.topRight,
                    child: Text(
                      value.toStringAsFixed(0), 
                      style: const TextStyle(fontSize: 12),  
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

}
