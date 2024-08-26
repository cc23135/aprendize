import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<SalesData> timeStudyData = [
      SalesData(DateTime(2024, 1, 1), 1.5),
      SalesData(DateTime(2024, 1, 2), 2.0),
      SalesData(DateTime(2024, 1, 3), 1.8),
      SalesData(DateTime(2024, 1, 4), 2.2),
      SalesData(DateTime(2024, 1, 5), 1.9),
    ];

    final List<SalesData> subjectPerformanceData = [
      SalesData(DateTime(2024, 1, 1), 70),
      SalesData(DateTime(2024, 1, 2), 75),
      SalesData(DateTime(2024, 1, 3), 80),
      SalesData(DateTime(2024, 1, 4), 85),
      SalesData(DateTime(2024, 1, 5), 90),
    ];

    final List<SalesData> overallProgressData = [
      SalesData(DateTime(2024, 1, 1), 10),
      SalesData(DateTime(2024, 1, 2), 20),
      SalesData(DateTime(2024, 1, 3), 30),
      SalesData(DateTime(2024, 1, 4), 40),
      SalesData(DateTime(2024, 1, 5), 50),
    ];

    final List<PieChartData> pieChartData = [
      PieChartData('Matéria A', 30),
      PieChartData('Matéria B', 25),
      PieChartData('Matéria C', 20),
      PieChartData('Matéria D', 15),
      PieChartData('Matéria E', 10),
    ];

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.trending_up, size: 100, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'Estatísticas',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Veja as estatísticas detalhadas sobre seu desempenho.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Tempo de Estudo por Dia
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Tempo de Estudo por Dia',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        series: <CartesianSeries>[
                          LineSeries<SalesData, DateTime>(
                            dataSource: timeStudyData,
                            xValueMapper: (SalesData data, _) => data.year,
                            yValueMapper: (SalesData data, _) => data.sales,
                            color: Colors.blue,
                            markerSettings: MarkerSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Desempenho em Diferentes Matérias
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Desempenho em Diferentes Matérias',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        series: <CartesianSeries>[
                          LineSeries<SalesData, DateTime>(
                            dataSource: subjectPerformanceData,
                            xValueMapper: (SalesData data, _) => data.year,
                            yValueMapper: (SalesData data, _) => data.sales,
                            color: Colors.green,
                            markerSettings: MarkerSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Progresso Geral
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Progresso Geral',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        series: <CartesianSeries>[
                          LineSeries<SalesData, DateTime>(
                            dataSource: overallProgressData,
                            xValueMapper: (SalesData data, _) => data.year,
                            yValueMapper: (SalesData data, _) => data.sales,
                            color: Colors.red,
                            markerSettings: MarkerSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Gráfico de Pizza
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Desempenho por Matéria',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: SfCircularChart(
                        legend: Legend(isVisible: true),
                        series: <CircularSeries>[
                          PieSeries<PieChartData, String>(
                            dataSource: pieChartData,
                            xValueMapper: (PieChartData data, _) => data.subject,
                            yValueMapper: (PieChartData data, _) => data.value,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            pointColorMapper: (PieChartData data, _) {
                              switch (data.subject) {
                                case 'Matéria A':
                                  return Colors.blue;
                                case 'Matéria B':
                                  return Colors.green;
                                case 'Matéria C':
                                  return Colors.red;
                                case 'Matéria D':
                                  return Colors.orange;
                                case 'Matéria E':
                                  return Colors.purple;
                                default:
                                  return Colors.grey;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Cards com Estatísticas
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Estatísticas Rápidas',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildStatCard('Horas Estudadas', '10h', Colors.blue),
                        _buildStatCard('Média de Notas', '80%', Colors.green),
                        _buildStatCard('Tarefas Completas', '15', Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Tabela de Desempenho
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Tabela de Desempenho',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Data')),
                        DataColumn(label: Text('Horas Estudadas')),
                        DataColumn(label: Text('Nota')),
                      ],
                      rows: <DataRow>[
                        _buildDataRow(DateTime(2024, 1, 1), '1.5h', '70'),
                        _buildDataRow(DateTime(2024, 1, 2), '2.0h', '75'),
                        _buildDataRow(DateTime(2024, 1, 3), '1.8h', '80'),
                        _buildDataRow(DateTime(2024, 1, 4), '2.2h', '85'),
                        _buildDataRow(DateTime(2024, 1, 5), '1.9h', '90'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 5,
      color: color.withOpacity(0.1),
      child: Container(
        padding: EdgeInsets.all(16),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(DateTime date, String studyHours, String grade) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text('${date.day}/${date.month}/${date.year}')),
        DataCell(Text(studyHours)),
        DataCell(Text(grade)),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}

class PieChartData {
  PieChartData(this.subject, this.value);
  final String subject;
  final double value;
}
