import 'package:aprendize/AppStateSingleton.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'colors.dart';
import 'createStudyDay.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime now = DateTime.now();
  late DateTime _selectedDay =
      DateTime.utc(now.year, now.month, now.day).toUtc();
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, List<dynamic>> _estudos = {};
  Map<DateTime, List<dynamic>> _tarefas = {};

  @override
  void initState() {
    super.initState();
    _fetchEstudos();
  }

  Future<void> _fetchEstudos() async {
  try {
    final response = await http.get(Uri.parse(
        '${AppStateSingleton().apiUrl}api/getEstudos?idUsuario=${AppStateSingleton().idUsuario}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> dados = jsonDecode(response.body);

      List<dynamic> estudosData = dados['estudos'];
      List<dynamic> tarefasData = dados['tarefas'];

      Map<DateTime, List<dynamic>> estudosAgrupados = {};
      Map<DateTime, List<dynamic>> tarefasAgrupadas = {};

      // Agrupando os estudos por data
      for (var estudo in estudosData) {
        DateTime dataEstudo = DateTime.parse(estudo['dataEstudo']);
        if (estudosAgrupados[dataEstudo] == null) {
          estudosAgrupados[dataEstudo] = [];
        }
        estudosAgrupados[dataEstudo]!.add(estudo);
      }

      for (var tarefa in tarefasData) {
        DateTime dataTarefa = DateTime.parse(tarefa['dataTarefa']);
        if (tarefasAgrupadas[dataTarefa] == null) {
          tarefasAgrupadas[dataTarefa] = [];
        }
        tarefasAgrupadas[dataTarefa]!.add(tarefa);
      }

      setState(() {
        _estudos = estudosAgrupados;
        _tarefas = tarefasAgrupadas;
      });
    } else {
      throw Exception('Erro ao carregar dados');
    }
  } catch (e) {
    print('Erro: $e');
  }
}

  Widget _getIconForDay(DateTime day) {
  // Verifica se há tarefas no dia, retornando automaticamente o ícone triste
  if (_tarefas[day]?.isNotEmpty ?? false) {
    return _buildIcon('assets/images/CarinhaTriste.svg');
  }

  // Obtém os estudos no dia e, se não houver, retorna sem ícone
  final estudosNoDia = _estudos[day];
  if (estudosNoDia == null || estudosNoDia.isEmpty) {
    return const SizedBox.shrink();
  }

  // Inicializa as variáveis para os cálculos
  int totalExercicios = 0, totalAcertos = 0, totalTempoSegundos = 0, totalMetaTempoSegundos = 0;

  // Acumula os dados dos estudos do dia
  for (var estudo in estudosNoDia) {
    totalExercicios += estudo['metaExercicios'] as int;
    totalAcertos += estudo['qtosExercicios'] as int;
    totalTempoSegundos += _isoTimeToSeconds(estudo['qtoTempo']);
    totalMetaTempoSegundos += _isoTimeToSeconds(estudo['metaTempo']);
  }

  double porcentagemExercicios = totalExercicios > 0 ? totalAcertos / totalExercicios : 0;
  double porcentagemTempo = totalMetaTempoSegundos > 0 ? totalTempoSegundos / totalMetaTempoSegundos : 0;

  return _buildIcon(_selectIcon(porcentagemExercicios, porcentagemTempo));
}

Widget _buildIcon(String iconUrl) {
  return Container(
    padding: const EdgeInsets.all(4),
    child: SvgPicture.asset(
      iconUrl,
      width: 20,
      height: 20,
      fit: BoxFit.cover,
    ),
  );
}

// Função auxiliar para selecionar o ícone baseado nas porcentagens
String _selectIcon(double porcentagemExercicios, double porcentagemTempo) {
  if (porcentagemExercicios >= 1 && porcentagemTempo >= 1) {
    return 'assets/images/CarinhaFeliz.svg';
  } else if (porcentagemExercicios >= 0.5 || porcentagemTempo >= 0.5) {
    return 'assets/images/CarinhaMedia.svg';
  } else {
    return 'assets/images/CarinhaTriste.svg';
  }
}

// Função auxiliar para converter a string ISO 8601 em segundos
  int _isoTimeToSeconds(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    return dateTime.hour * 3600 + dateTime.minute * 60 + dateTime.second;
  }

  List<Widget> _eventLoader(DateTime day) {
    List<dynamic>? estudosNoDia = _estudos[day];

    if (estudosNoDia == null || estudosNoDia.isEmpty) {
      return [];
    }
    return [
      _getIconForDay(day), // Chame a função que retorna o ícone
    ];
  }

String formatTime(String timeString) {
  DateTime time = DateTime.parse(timeString);
  int totalMinutes = time.hour * 60 + time.minute; 
  return '$totalMinutes'; 
}

  int calcularMetaTempoTotal() {
    int totalMetaTempoEmMinutos = 0;

    if (_estudos[_selectedDay] != null) {
      for (var estudo in _estudos[_selectedDay]!) {
        var metaTempo = estudo['metaTempo'];

        totalMetaTempoEmMinutos += formatarTempo(metaTempo);
      }
    }

    return totalMetaTempoEmMinutos; // Retorna o total em minutos
  }

  int calcularTempoGasto() {
    int totalTempoGastoEmMinutos = 0;

    if (_estudos[_selectedDay] != null) {
      for (var estudo in _estudos[_selectedDay]!) {
        var tempoGasto = estudo['qtoTempo'];

        totalTempoGastoEmMinutos += formatarTempo(tempoGasto);
      }
    }

    return totalTempoGastoEmMinutos; // Retorna o total em minutos
  }

  int formatarTempo(String metaTempo) {
    DateTime dateTime = DateTime.parse(metaTempo);

    // Extrai horas e minutos
    int horas = dateTime.hour;
    int minutos = dateTime.minute;

    return minutos + horas * 60; // Retorna o total em minutos
  }

  String formatarTempoVisual(int totalMinutos) {
    int horas = totalMinutos ~/ 60;
    int minutos = totalMinutos % 60; // Resto da divisão para obter minutos

    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}'; // Formata para HH:mm
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 5 * 365)),
            lastDay: DateTime.now().add(const Duration(days: 5 * 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            locale: 'pt_BR',
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronVisible: true,
              rightChevronVisible: true,
            ),
            eventLoader: _eventLoader,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // Verifica se há eventos para o dia
                if (events.isNotEmpty) {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: _getIconForDay(date),
                  );
                }
                return Container();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final now = DateTime.now();
                _selectedDay =
                    DateTime.utc(now.year, now.month, now.day).toUtc();
                _focusedDay = now;
              });
            },
            child: const Text('Voltar ao Hoje'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
    children: [
      // Exibe Tarefas do Dia
      if (_tarefas[_selectedDay]?.isNotEmpty ?? false)
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          color: AppColors.black,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarefas do Dia',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ..._tarefas[_selectedDay]!.asMap().entries.map((entry) {
                  int index = entry.key;
                  var tarefa = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tarefa['topicoNome'],
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Meta de Exercícios: ${tarefa['metaExercicios'] ?? 0}',
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                      Text(
                        'Meta de Tempo: ${formatTime(tarefa['metaTempo'])} minutos',
                        style: TextStyle(color: AppColors.white, fontSize: 16),
                      ),
                      if (index != _tarefas[_selectedDay]!.length - 1)
                        Divider(color: AppColors.white),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        
      // Exibe Resultados Totais e Estudos do Dia
      if (_estudos[_selectedDay]?.isNotEmpty ?? false)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    color: AppColors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resultados Totais',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Exercícios: ${_estudos[_selectedDay]?.fold<int>(0, (sum, estudo) => sum + (estudo['qtosExercicios'] as int? ?? 0)) ?? 0}/${_estudos[_selectedDay]?.fold<int>(0, (sum, estudo) => sum + (estudo['metaExercicios'] as int? ?? 0)) ?? 0}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          // Exiba o texto com o tempo total meta
                          Text(
                            'Meta de Tempo Total: ${calcularTempoGasto()}/${calcularMetaTempoTotal()} minutos',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          if ((_estudos[_selectedDay]?.fold<int>(0,(sum, estudo) =>sum +(estudo['qtosExercicios'] as int? ??0)) ?? 0) >0)
                            Text(
                              'Porcentagem de Acertos: ${((_estudos[_selectedDay]?.fold<int>(0, (sum, estudo) => sum + (estudo['qtosExerciciosAcertados'] as int? ?? 0)) ?? 0) * 100 / (_estudos[_selectedDay]?.fold<int>(0, (sum, estudo) => sum + (estudo['qtosExercicios'] as int? ?? 0)) ?? 1)).toStringAsFixed(1)}% (${_estudos[_selectedDay]?.fold<int>(0, (sum, estudo) => sum + (estudo['qtosExerciciosAcertados'] as int? ?? 0)) ?? 0}/${_estudos[_selectedDay]?.fold<int>(0, (sum, estudo) => sum + (estudo['qtosExercicios'] as int? ?? 0)) ?? 1})',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                // Cards individuais
                ..._estudos[_selectedDay]?.map((estudo) {
                      final qtosExercicios = estudo['qtosExercicios'] as int? ?? 0;
                      final metaExercicios = estudo['metaExercicios'] as int? ?? 0;
                      final qtosAcertos = estudo['qtosExerciciosAcertados'] as int? ?? 0;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        color: AppColors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${estudo['materiaNome']}',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${estudo['topicoNome']}',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Exercícios: $qtosExercicios/$metaExercicios',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              if (qtosExercicios > 0) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Acertos: ${qtosAcertos * 100 ~/ (qtosExercicios == 0 ? 1 : qtosExercicios)}% ($qtosAcertos/$qtosExercicios)',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Meta de Tempo: ${formatTime(estudo['qtoTempo'])}/${formatTime(estudo['metaTempo'])} minutos',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList() ??
                    [],
                if (_estudos[_selectedDay] == null ||
                    _estudos[_selectedDay]!.isEmpty)
                  Text(
                    'Nenhum estudo para hoje',
                    style: TextStyle(color: AppColors.white, fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DateTime today = DateTime.now();
          DateTime selectedDayOnlyDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

          if (selectedDayOnlyDate.isBefore(DateTime(today.year, today.month, today.day))) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Não se pode criar tarefa para dias anteriores!',
                    style: TextStyle(color: Colors.white)),
                backgroundColor: AppColors.darkPurple,
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateStudyDayPage(selectedDay: _selectedDay),
              ),
            );
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
