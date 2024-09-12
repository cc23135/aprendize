// lib/statistics_page.dart
import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isLoading = true;
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    _fetchStatisticsData();
  }

  Future<void> _fetchStatisticsData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:6060/api/statistics')); // Substitua pela URL real da API
      if (response.statusCode == 200) {
        final String jsonString = response.body;
        AppStateSingleton().statisticsJson = jsonString;
        final data = json.decode(jsonString);
        setState(() {
          // Processa o JSON para obter os dados do gráfico
          spots = _parseDataToFlSpots(data);
          isLoading = false;
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
    // Exemplo de estrutura esperada: [{"label": "Jan", "value": 10}, {"label": "Feb", "value": 20}]
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
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: true),
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
                        maxY: spots.isNotEmpty ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10) : 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppStateSingleton().statisticsJson, // Exibe o JSON como uma string
                    style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
    );
  }
}
