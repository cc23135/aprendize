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
  
  List<FlSpot> spots = [ // dados das horas
  const FlSpot(0, 1),
  const FlSpot(1, 3),
  const FlSpot(2, 5),
  const FlSpot(3, 2),
  const FlSpot(4, 4),
  const FlSpot(5, 4),
  const FlSpot(6, 4),
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
      final response = await http.get(Uri.parse('http://localhost:6060/api/statistics'));
      if (response.statusCode == 200) {
        final String jsonString = response.body;
        AppStateSingleton().statisticsJson = jsonString;
        final data = json.decode(jsonString);
        setState(() {
          spots = _parseDataToFlSpots(data['graphData']); // Handle graph data
          timeSpent = data['timeSpent']; // Assuming the time spent is returned in minutes
          tasksDone = data['tasksDone']; // Assuming the number of tasks done
          isLoading = false;

          print(timeSpent + tasksDone);
        });
      } else {
        throw Exception('Failed to load statistics data');
      }
    } catch (e) {
      print('Error fetching statistics data: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.center,
                    child: Text("Estatísticas", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600 )),
                  ),
                  

                  const SizedBox(height: 40),
                    // botão para definir semanal ou diário


                    // exercícios feitos 
                    // linha com várias matérias e o total
                    Container(
                      height: 300,
                      child: buildLineGraph(spots),
                    ),

                    // tempo gasto no aplicativo
                    Container(
                      height: 300,
                      child: buildBarGraph(spots),
                    ),



                    // exercícios feitos
                    // linha


                    // exercícios feitos por matéria
                    // coluna deitada
                    
                    // tempo gasto por matéria
                    // coluna deitada

                    // exercícios feitos por coleção
                    // coluna deitada
                    
                    // tempo gasto por coleção
                    // coluna deitada


                    const SizedBox(height: 20),
                    Text(
                      'Time spent on app: $timeSpent minutes', // Display time spent
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Number of tasks done: $tasksDone', // Display tasks done
                      style: const TextStyle(fontSize: 16),
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
                  return Text('Day ${index + 1}', style: const TextStyle(fontSize: 10)); 
                } else {
                  return const Text(''); // Return empty text for out-of-bound indexes
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true), // Default Y-axis titles
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
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
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
                width: 50, // Increased width for wider bars
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


}
